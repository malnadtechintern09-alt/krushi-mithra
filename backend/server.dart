import 'dart:convert';
import 'dart:io';
import 'database.dart';

void main() async {
  final db = DatabaseManager();
  await db.init();

  final port = 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('====================================================');
  print('🌾 KRUSHI MITHRA Backend Server & Web Admin Panel');
  print('🚀 Server listening at http://localhost:$port');
  print('🛡️  Web Admin Panel: http://localhost:$port/admin/');
  print('====================================================');

  await for (HttpRequest request in server) {
    _handleRequest(request, db);
  }
}

void _handleRequest(HttpRequest request, DatabaseManager db) async {
  // CORS Headers
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  request.response.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');

  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.ok;
    await request.response.close();
    return;
  }

  final path = request.uri.path;
  print('[${request.method}] $path');

  try {
    // 1. Static File Serving for Web Admin Panel at /admin/ or /admin/...
    if (path == '/admin' || path.startsWith('/admin/')) {
      await _serveStaticAdminFile(request, path);
      return;
    }

    // Redirect root URL to /admin/
    if (path == '/' || path == '/index.html') {
      request.response.redirect(Uri.parse('/admin/'));
      return;
    }

    // 2. API Endpoints
    if (path.startsWith('/api/v1/')) {
      await _handleApi(request, path.replaceFirst('/api/v1', ''), db);
      return;
    }

    // 404 Not Found
    _sendJson(request, {'error': 'Endpoint not found'}, status: HttpStatus.notFound);
  } catch (e, st) {
    print('Unhandled Error: $e\n$st');
    _sendJson(request, {'error': e.toString()}, status: HttpStatus.internalServerError);
  }
}

Future<void> _serveStaticAdminFile(HttpRequest request, String path) async {
  var relativePath = path.replaceFirst('/admin', '');
  if (relativePath.isEmpty || relativePath == '/') {
    relativePath = '/index.html';
  }

  final file = File('admin_panel$relativePath');
  if (await file.exists()) {
    final contentType = _getContentType(file.path);
    request.response.headers.contentType = contentType;
    await file.openRead().pipe(request.response);
  } else {
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('Admin static file not found: $relativePath');
    await request.response.close();
  }
}

ContentType _getContentType(String filePath) {
  if (filePath.endsWith('.html')) return ContentType.html;
  if (filePath.endsWith('.css')) return ContentType('text', 'css', charset: 'utf-8');
  if (filePath.endsWith('.js')) return ContentType('application', 'javascript', charset: 'utf-8');
  if (filePath.endsWith('.json')) return ContentType.json;
  if (filePath.endsWith('.png')) return ContentType('image', 'png');
  if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) return ContentType('image', 'jpeg');
  if (filePath.endsWith('.svg')) return ContentType('image', 'svg+xml');
  return ContentType.binary;
}

Future<void> _handleApi(HttpRequest request, String path, DatabaseManager db) async {
  final method = request.method;
  final body = method == 'POST' || method == 'PUT' ? await _parseBody(request) : <String, dynamic>{};

  // Auth
  if (path == '/admin/login' && method == 'POST') {
    final email = body['email'];
    final password = body['password'];
    if (email == 'admin@krushimithra.com' && password == 'admin123') {
      _sendJson(request, {
        'token': 'krushi_admin_jwt_token_secret_9988',
        'user': {
          'id': 'adm_1',
          'name': 'Super Administrator',
          'email': email,
          'role': 'Super Admin',
        }
      });
    } else {
      _sendJson(request, {'error': 'Invalid email or password'}, status: HttpStatus.unauthorized);
    }
    return;
  }

  // Dashboard Overview Stats
  if (path == '/dashboard/stats' && method == 'GET') {
    final users = db.getList('users');
    final farmers = db.getList('farmers');
    final machines = db.getList('machines');
    final workers = db.getList('workers');
    final bookings = db.getList('bookings');
    final products = db.getList('marketplace_products');
    final payments = db.getList('payments');
    final apps = db.getList('provider_applications');
    final pendingApps = apps.where((a) => a is Map && a['status'] == 'PENDING').length;

    double totalRevenue = 0;
    for (var p in payments) {
      if (p is Map && p['status'] == 'Success') {
        totalRevenue += ((p['amount'] ?? 0) as num).toDouble();
      }
    }

    _sendJson(request, {
      'totalUsers': users.length + 12450,
      'userGrowth': '+12.5%',
      'totalFarmers': farmers.length + 8920,
      'farmerGrowth': '+10.2%',
      'totalMachines': machines.length + 1280,
      'machineGrowth': '+8.4%',
      'availableMachines': machines.where((m) => m is Map && m['isAvailable'] == true).length,
      'rentedMachines': 326,
      'totalWorkers': workers.length + 580,
      'availableWorkers': workers.where((w) => w is Map && w['isAvailable'] == true).length,
      'totalBookings': bookings.length + 1840,
      'activeBookings': 326,
      'completedBookings': 1480,
      'cancelledBookings': 34,
      'totalMarketplaceProducts': products.length + 420,
      'totalRevenue': totalRevenue + 842500,
      'monthlyRevenue': 842500,
      'pendingProviderApplications': pendingApps,
    });
    return;
  }

  // ----------------------------------------------------
  // PROVIDER APPROVAL SYSTEM ENDPOINTS
  // ----------------------------------------------------
  if (path == '/provider/apply' && method == 'POST') {
    final appNum = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    body['id'] = 'app_${DateTime.now().millisecondsSinceEpoch}';
    body['applicationId'] = 'KM-APP-$appNum';
    body['status'] = 'PENDING';
    body['submittedAt'] = DateTime.now().toString().split('.')[0];
    body['rejectionReason'] = null;

    db.addItem('provider_applications', body);
    _logActivity(db, 'Submitted Provider Application', 'Provider Approvals', 'User ${body['userName']} submitted application ${body['applicationId']} for ${body['machineName'] ?? body['category']}');

    _sendJson(request, body, status: HttpStatus.created);
    return;
  }

  if (path == '/provider/my-applications' && method == 'GET') {
    final userId = request.uri.queryParameters['user_id'] ?? 'usr_101';
    final apps = db.getList('provider_applications');
    final userApps = apps.where((a) => a is Map && a['userId'] == userId).toList();
    _sendJson(request, userApps);
    return;
  }

  if (path == '/admin/provider-applications' && method == 'GET') {
    _sendJson(request, db.getList('provider_applications'));
    return;
  }

  if (path.startsWith('/admin/provider-applications/') && method == 'POST') {
    final parts = path.split('/');
    if (parts.length >= 5) {
      final appId = parts[3];
      final action = parts[4]; // approve or reject

      final app = db.getItem('provider_applications', 'id', appId);
      if (app == null) {
        _sendJson(request, {'error': 'Application not found'}, status: HttpStatus.notFound);
        return;
      }

      if (action == 'approve') {
        // 1. Update application status
        db.updateItem('provider_applications', 'id', appId, {
          'status': 'APPROVED',
          'reviewedAt': DateTime.now().toString().split('.')[0],
          'reviewedBy': 'Super Administrator',
        });

        final serviceType = app['serviceType']?.toString() ?? 'Rent My Machine';

        // 2. Insert into machines catalog if machine owner
        if (serviceType.contains('Machine')) {
          final newMachine = {
            'id': 'm_${DateTime.now().millisecondsSinceEpoch}',
            'name': app['machineName'] ?? 'Agricultural Machine',
            'category': app['category'] ?? 'Tractors',
            'brand': app['brand'] ?? 'Generic',
            'model': app['model'] ?? '',
            'manufacturingYear': app['manufacturingYear'] ?? 2024,
            'horsePower': app['horsePower'] ?? '45 HP',
            'description': app['description'] ?? '',
            'ownerId': app['userId'] ?? 'usr_101',
            'ownerName': app['userName'] ?? 'Farmer Owner',
            'ownerPhone': app['userPhone'] ?? '',
            'location': app['userLocation'] ?? 'Shivamogga, KA',
            'village': app['village'] ?? '',
            'taluk': app['taluk'] ?? '',
            'district': app['district'] ?? '',
            'state': app['state'] ?? 'Karnataka',
            'latitude': 13.9300,
            'longitude': 75.5680,
            'rentalType': app['rentalType'] ?? 'Per Day',
            'rentalPricePerDay': ((app['rentalPricePerDay'] ?? 2200) as num).toDouble(),
            'securityDeposit': ((app['securityDeposit'] ?? 1000) as num).toDouble(),
            'availabilityStatus': 'Available',
            'isAvailable': true,
            'rating': 4.8,
            'reviewCount': 1,
            'verificationStatus': 'Verified',
            'status': 'Approved',
            'images': app['images'] != null ? List<String>.from(app['images']) : ['https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'],
            'documents': {'rcVerified': true, 'insuranceVerified': true},
            'adminNotes': 'Approved via Provider Approval System (App ID: ${app['applicationId']})',
          };
          db.addItem('machines', newMachine);
        }

        // 3. Insert into workers catalog if worker/driver
        if (serviceType.contains('Driver') || serviceType.contains('Worker')) {
          final newWorker = {
            'id': 'w_${DateTime.now().millisecondsSinceEpoch}',
            'userId': app['userId'] ?? 'usr_101',
            'name': app['userName'] ?? 'Farm Worker',
            'phone': app['userPhone'] ?? '',
            'skills': [app['category'] ?? 'Driver'],
            'category': app['category'] ?? 'Tractor Driver',
            'experienceYears': 5,
            'location': app['userLocation'] ?? 'Shivamogga, KA',
            'village': app['village'] ?? '',
            'taluk': app['taluk'] ?? '',
            'district': app['district'] ?? '',
            'state': app['state'] ?? 'Karnataka',
            'dailyRate': ((app['rentalPricePerDay'] ?? 900) as num).toDouble(),
            'availabilityStatus': 'Available',
            'isAvailable': true,
            'rating': 4.9,
            'reviewCount': 1,
            'isVerified': true,
            'verificationStatus': 'Verified',
            'status': 'Active',
            'profilePhoto': app['profilePhoto'] ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
            'bio': app['description'] ?? 'Verified agricultural worker.',
          };
          db.addItem('workers', newWorker);
        }

        // 4. Update user role
        db.updateItem('users', 'id', app['userId'] ?? 'usr_101', {'role': serviceType.contains('Machine') ? 'Machine Owner' : 'Worker', 'isVerified': true});

        _logActivity(db, 'Approved Provider Application', 'Provider Approvals', 'Approved application ${app['applicationId']} for ${app['userName']}');
        _sendJson(request, {'success': true, 'applicationId': app['applicationId'], 'status': 'APPROVED'});
        return;
      }

      if (action == 'reject') {
        final reason = body['rejectionReason'] ?? 'Incomplete details';
        db.updateItem('provider_applications', 'id', appId, {
          'status': 'REJECTED',
          'rejectionReason': reason,
          'reviewedAt': DateTime.now().toString().split('.')[0],
          'reviewedBy': 'Super Administrator',
        });
        _logActivity(db, 'Rejected Provider Application', 'Provider Approvals', 'Rejected application ${app['applicationId']}: $reason');
        _sendJson(request, {'success': true, 'applicationId': app['applicationId'], 'status': 'REJECTED'});
        return;
      }
    }
  }

  // Users
  if (path == '/users') {
    if (method == 'GET') {
      _sendJson(request, db.getList('users'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'usr_${DateTime.now().millisecondsSinceEpoch}';
      body['joinedDate'] = DateTime.now().toString().split(' ')[0];
      body['status'] ??= 'Active';
      db.addItem('users', body);
      _logActivity(db, 'Created User', 'Users', 'Created user ${body['name']} (${body['role']})');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/users/')) {
    final id = path.replaceFirst('/users/', '');
    if (method == 'GET') {
      final user = db.getItem('users', 'id', id);
      if (user != null) _sendJson(request, user);
      else _sendJson(request, {'error': 'User not found'}, status: HttpStatus.notFound);
      return;
    }
    if (method == 'PUT') {
      final updated = db.updateItem('users', 'id', id, body);
      if (updated) {
        _logActivity(db, 'Updated User', 'Users', 'Updated user details for ID: $id');
        _sendJson(request, db.getItem('users', 'id', id)!);
      } else {
        _sendJson(request, {'error': 'User not found'}, status: HttpStatus.notFound);
      }
      return;
    }
    if (method == 'DELETE') {
      final deleted = db.deleteItem('users', 'id', id);
      if (deleted) {
        _logActivity(db, 'Deleted User', 'Users', 'Deleted user ID: $id');
        _sendJson(request, {'success': true});
      } else {
        _sendJson(request, {'error': 'User not found'}, status: HttpStatus.notFound);
      }
      return;
    }
  }

  // Farmers
  if (path == '/farmers') {
    if (method == 'GET') {
      _sendJson(request, db.getList('farmers'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'frm_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Active';
      db.addItem('farmers', body);
      _logActivity(db, 'Added Farmer', 'Farmers', 'Added farmer ${body['name']}');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/farmers/')) {
    final id = path.replaceFirst('/farmers/', '');
    if (method == 'PUT') {
      final updated = db.updateItem('farmers', 'id', id, body);
      if (updated) {
        _logActivity(db, 'Updated Farmer', 'Farmers', 'Updated farmer ID: $id');
        _sendJson(request, db.getItem('farmers', 'id', id)!);
      } else _sendJson(request, {'error': 'Farmer not found'}, status: HttpStatus.notFound);
      return;
    }
    if (method == 'DELETE') {
      final deleted = db.deleteItem('farmers', 'id', id);
      if (deleted) _sendJson(request, {'success': true});
      else _sendJson(request, {'error': 'Farmer not found'}, status: HttpStatus.notFound);
      return;
    }
  }

  // Machines
  if (path == '/machines') {
    if (method == 'GET') {
      _sendJson(request, db.getList('machines'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'm_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Approved';
      body['verificationStatus'] ??= 'Verified';
      body['isAvailable'] = body['isAvailable'] ?? true;
      body['availabilityStatus'] = body['isAvailable'] ? 'Available' : 'Unavailable';
      body['rating'] ??= 5.0;
      body['reviewCount'] ??= 0;
      db.addItem('machines', body);
      _logActivity(db, 'Added Machine', 'Machines', 'Added new machine ${body['name']} (Price: ₹${body['rentalPricePerDay']})');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/machines/')) {
    final remaining = path.replaceFirst('/machines/', '');
    if (remaining.contains('/availability')) {
      final id = remaining.replaceFirst('/availability', '');
      final isAvail = body['isAvailable'] as bool? ?? true;
      final statusStr = body['availabilityStatus'] as String? ?? (isAvail ? 'Available' : 'Unavailable');
      db.updateItem('machines', 'id', id, {
        'isAvailable': isAvail,
        'availabilityStatus': statusStr,
      });
      _logActivity(db, 'Updated Machine Availability', 'Machines', 'Set availability of machine $id to $statusStr');
      _sendJson(request, db.getItem('machines', 'id', id)!);
      return;
    }

    final id = remaining;
    if (method == 'GET') {
      final machine = db.getItem('machines', 'id', id);
      if (machine != null) _sendJson(request, machine);
      else _sendJson(request, {'error': 'Machine not found'}, status: HttpStatus.notFound);
      return;
    }
    if (method == 'PUT') {
      final updated = db.updateItem('machines', 'id', id, body);
      if (updated) {
        _logActivity(db, 'Updated Machine', 'Machines', 'Updated details & price for machine ID: $id');
        _sendJson(request, db.getItem('machines', 'id', id)!);
      } else _sendJson(request, {'error': 'Machine not found'}, status: HttpStatus.notFound);
      return;
    }
    if (method == 'DELETE') {
      final deleted = db.deleteItem('machines', 'id', id);
      if (deleted) {
        _logActivity(db, 'Deleted Machine', 'Machines', 'Deleted machine ID: $id');
        _sendJson(request, {'success': true});
      } else _sendJson(request, {'error': 'Machine not found'}, status: HttpStatus.notFound);
      return;
    }
  }

  // Workers
  if (path == '/workers') {
    if (method == 'GET') {
      _sendJson(request, db.getList('workers'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'w_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Active';
      body['isVerified'] ??= true;
      body['isAvailable'] ??= true;
      body['availabilityStatus'] = body['isAvailable'] ? 'Available' : 'Unavailable';
      db.addItem('workers', body);
      _logActivity(db, 'Added Worker', 'Workers & Drivers', 'Registered worker ${body['name']} (${body['category']})');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/workers/')) {
    final id = path.replaceFirst('/workers/', '');
    if (method == 'PUT') {
      db.updateItem('workers', 'id', id, body);
      _logActivity(db, 'Updated Worker', 'Workers & Drivers', 'Updated worker $id');
      _sendJson(request, db.getItem('workers', 'id', id)!);
      return;
    }
    if (method == 'DELETE') {
      db.deleteItem('workers', 'id', id);
      _sendJson(request, {'success': true});
      return;
    }
  }

  // Bookings
  if (path == '/bookings') {
    if (method == 'GET') {
      _sendJson(request, db.getList('bookings'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'b_${DateTime.now().millisecondsSinceEpoch}';
      body['createdAt'] = DateTime.now().toString().split(' ')[0];
      body['bookingStatus'] ??= 'Pending';
      db.addItem('bookings', body);
      _logActivity(db, 'Created Booking', 'Bookings', 'Created booking ID ${body['id']}');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/bookings/')) {
    final id = path.replaceFirst('/bookings/', '');
    if (method == 'PUT') {
      db.updateItem('bookings', 'id', id, body);
      _logActivity(db, 'Updated Booking', 'Bookings', 'Updated booking status for $id to ${body['bookingStatus']}');
      _sendJson(request, db.getItem('bookings', 'id', id)!);
      return;
    }
  }

  // Marketplace Products
  if (path == '/marketplace') {
    if (method == 'GET') {
      _sendJson(request, db.getList('marketplace_products'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'p_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Approved';
      db.addItem('marketplace_products', body);
      _logActivity(db, 'Added Crop Product', 'Marketplace', 'Added produce ${body['title']}');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/marketplace/')) {
    final id = path.replaceFirst('/marketplace/', '');
    if (method == 'PUT') {
      db.updateItem('marketplace_products', 'id', id, body);
      _sendJson(request, db.getItem('marketplace_products', 'id', id)!);
      return;
    }
    if (method == 'DELETE') {
      db.deleteItem('marketplace_products', 'id', id);
      _sendJson(request, {'success': true});
      return;
    }
  }

  // Agro Store Products
  if (path == '/store') {
    if (method == 'GET') {
      _sendJson(request, db.getList('store_products'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'store_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Active';
      db.addItem('store_products', body);
      _logActivity(db, 'Added Store Item', 'Agro Store', 'Added store product ${body['title']}');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/store/')) {
    final id = path.replaceFirst('/store/', '');
    if (method == 'PUT') {
      db.updateItem('store_products', 'id', id, body);
      _sendJson(request, db.getItem('store_products', 'id', id)!);
      return;
    }
    if (method == 'DELETE') {
      db.deleteItem('store_products', 'id', id);
      _sendJson(request, {'success': true});
      return;
    }
  }

  // Categories
  if (path == '/categories') {
    if (method == 'GET') {
      _sendJson(request, {
        'machineCategories': db.getList('machine_categories'),
        'workerCategories': db.getList('worker_categories'),
        'marketplaceCategories': db.getList('marketplace_categories'),
        'storeCategories': db.getList('store_categories'),
      });
      return;
    }
  }

  // Locations
  if (path == '/locations') {
    if (method == 'GET') {
      _sendJson(request, db.getList('locations'));
      return;
    }
  }

  // Reviews
  if (path == '/reviews') {
    if (method == 'GET') {
      _sendJson(request, db.getList('reviews'));
      return;
    }
  }

  // Notifications
  if (path == '/notifications') {
    if (method == 'GET') {
      _sendJson(request, db.getList('notifications'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'notif_${DateTime.now().millisecondsSinceEpoch}';
      body['sentAt'] = DateTime.now().toString().split('.')[0];
      body['status'] ??= 'Sent';
      db.addItem('notifications', body);
      _logActivity(db, 'Sent Push Notification', 'Notifications', 'Broadcasted notification "${body['title']}"');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  // Banners
  if (path == '/banners') {
    if (method == 'GET') {
      _sendJson(request, db.getList('banners'));
      return;
    }
    if (method == 'POST') {
      body['id'] = 'ban_${DateTime.now().millisecondsSinceEpoch}';
      body['status'] ??= 'Active';
      db.addItem('banners', body);
      _logActivity(db, 'Added Banner', 'Banners', 'Created banner ${body['title']}');
      _sendJson(request, body, status: HttpStatus.created);
      return;
    }
  }

  if (path.startsWith('/banners/')) {
    final id = path.replaceFirst('/banners/', '');
    if (method == 'PUT') {
      db.updateItem('banners', 'id', id, body);
      _sendJson(request, db.getItem('banners', 'id', id)!);
      return;
    }
    if (method == 'DELETE') {
      db.deleteItem('banners', 'id', id);
      _sendJson(request, {'success': true});
      return;
    }
  }

  // Mobile App Content & Home Layout Manager
  if (path == '/mobile-content') {
    if (method == 'GET') {
      _sendJson(request, {
        'content': db.data['app_content'],
        'homeSections': db.getList('home_sections'),
      });
      return;
    }
    if (method == 'PUT') {
      if (body.containsKey('content')) {
        db.data['app_content'] = body['content'];
      }
      if (body.containsKey('homeSections')) {
        db.setList('home_sections', body['homeSections'] as List);
      }
      db.save();
      _logActivity(db, 'Updated Mobile App Content', 'Mobile App Manager', 'Updated mobile home screen text');
      _sendJson(request, {
        'content': db.data['app_content'],
        'homeSections': db.getList('home_sections'),
      });
      return;
    }
  }

  // Payments
  if (path == '/payments') {
    if (method == 'GET') {
      _sendJson(request, db.getList('payments'));
      return;
    }
  }

  // Reports
  if (path == '/reports') {
    if (method == 'GET') {
      _sendJson(request, {
        'summary': {
          'totalRentals': 1842,
          'totalWorkerBookings': 582,
          'totalRevenue': 842500,
          'topCategory': 'Tractors (42%)',
          'topLocation': 'Shivamogga (38%)',
        },
      });
      return;
    }
  }

  // Support Tickets
  if (path == '/support') {
    if (method == 'GET') {
      _sendJson(request, db.getList('support_tickets'));
      return;
    }
  }

  // Activity Logs
  if (path == '/activity-logs') {
    if (method == 'GET') {
      _sendJson(request, db.getList('activity_logs'));
      return;
    }
  }

  // Admin Users
  if (path == '/admin-users') {
    if (method == 'GET') {
      _sendJson(request, db.getList('admin_users'));
      return;
    }
  }

  // Settings
  if (path == '/settings') {
    if (method == 'GET') {
      _sendJson(request, db.data['settings']);
      return;
    }
    if (method == 'PUT') {
      db.data['settings'] = body;
      db.save();
      _logActivity(db, 'Updated Settings', 'Settings', 'Updated platform general & rental settings');
      _sendJson(request, db.data['settings']);
      return;
    }
  }

  _sendJson(request, {'error': 'API Endpoint not found'}, status: HttpStatus.notFound);
}

Future<Map<String, dynamic>> _parseBody(HttpRequest request) async {
  try {
    final content = await utf8.decoder.bind(request).join();
    if (content.isEmpty) return {};
    return jsonDecode(content) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

void _sendJson(HttpRequest request, dynamic data, {int status = HttpStatus.ok}) {
  request.response.statusCode = status;
  request.response.headers.contentType = ContentType.json;
  request.response.write(jsonEncode(data));
  request.response.close();
}

void _logActivity(DatabaseManager db, String action, String module, String details) {
  final log = {
    'id': 'log_${DateTime.now().millisecondsSinceEpoch}',
    'admin': 'Super Administrator',
    'action': action,
    'module': module,
    'date': DateTime.now().toString().split('.')[0],
    'ip': '127.0.0.1',
    'details': details,
  };
  db.addItem('activity_logs', log);
}

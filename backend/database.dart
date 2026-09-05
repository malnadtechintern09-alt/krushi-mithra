import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  late String _filePath;
  Map<String, dynamic> _data = {};

  MySqlConnection? _mysqlConn;
  bool _mysqlConnected = false;

  Future<void> init([String? customPath]) async {
    final dir = Directory('backend_data');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _filePath = customPath ?? 'backend_data/db.json';
    final file = File(_filePath);

    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        _data = jsonDecode(content) as Map<String, dynamic>;
        _ensureDefaults();
      } catch (e) {
        print('Error reading DB file, re-initializing: $e');
        _initializeDefaultData();
        await save();
      }
    } else {
      _initializeDefaultData();
      await save();
    }

    // Initialize MySQL Database Link
    await _initMySql();
  }

  Future<void> _initMySql() async {
    try {
      final settings = ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
      );
      var conn = await MySqlConnection.connect(settings);
      await conn.query('CREATE DATABASE IF NOT EXISTS krushi_mithra;');
      await conn.close();

      final dbSettings = ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: 'root',
        db: 'krushi_mithra',
      );
      _mysqlConn = await MySqlConnection.connect(dbSettings);
      _mysqlConnected = true;
      print('====================================================');
      print('🐬 MySQL Connected Successfully!');
      print('📊 Database: krushi_mithra on 127.0.0.1:3306');
      print('🔗 phpMyAdmin URL: http://localhost/phpmyadmin/');
      print('====================================================');

      await _createMySqlTables();
      await _syncAllToMySql();
    } catch (e) {
      print('⚠️ MySQL Connection Warning (falling back to local DB persistence): $e');
    }
  }

  Future<void> _createMySqlTables() async {
    if (!_mysqlConnected || _mysqlConn == null) return;
    try {
      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS machines (
          id VARCHAR(64) PRIMARY KEY,
          name VARCHAR(255),
          category VARCHAR(100),
          rentalPricePerDay DOUBLE,
          location VARCHAR(255),
          isAvailable TINYINT(1),
          rating DOUBLE,
          raw_json LONGTEXT,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS workers (
          id VARCHAR(64) PRIMARY KEY,
          name VARCHAR(255),
          category VARCHAR(100),
          dailyRate DOUBLE,
          location VARCHAR(255),
          isAvailable TINYINT(1),
          rating DOUBLE,
          raw_json LONGTEXT,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS provider_applications (
          id VARCHAR(64) PRIMARY KEY,
          applicationId VARCHAR(64),
          userName VARCHAR(255),
          userPhone VARCHAR(50),
          serviceType VARCHAR(100),
          status VARCHAR(50),
          rentalPricePerDay DOUBLE,
          raw_json LONGTEXT,
          submittedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS users (
          id VARCHAR(64) PRIMARY KEY,
          name VARCHAR(255),
          phone VARCHAR(50),
          role VARCHAR(100),
          locationName VARCHAR(255),
          raw_json LONGTEXT
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS marketplace_products (
          id VARCHAR(64) PRIMARY KEY,
          title VARCHAR(255),
          category VARCHAR(100),
          price DOUBLE,
          unit VARCHAR(50),
          raw_json LONGTEXT
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS bookings (
          id VARCHAR(64) PRIMARY KEY,
          targetTitle VARCHAR(255),
          customerName VARCHAR(255),
          totalAmount DOUBLE,
          bookingStatus VARCHAR(50),
          raw_json LONGTEXT
        );
      ''');

      await _mysqlConn!.query('''
        CREATE TABLE IF NOT EXISTS activity_logs (
          id VARCHAR(64) PRIMARY KEY,
          admin VARCHAR(100),
          action VARCHAR(255),
          module VARCHAR(100),
          date VARCHAR(100),
          details TEXT,
          raw_json LONGTEXT
        );
      ''');
    } catch (e) {
      print('MySQL Table Creation Error: $e');
    }
  }

  Future<void> _syncItemToMySql(String table, Map<String, dynamic> item) async {
    if (!_mysqlConnected || _mysqlConn == null) return;
    try {
      final id = item['id']?.toString() ?? 'item_${DateTime.now().millisecondsSinceEpoch}';
      final jsonStr = jsonEncode(item);

      if (table == 'machines') {
        final name = item['name']?.toString() ?? '';
        final category = item['category']?.toString() ?? '';
        final price = ((item['rentalPricePerDay'] ?? item['price'] ?? 0) as num).toDouble();
        final location = item['location']?.toString() ?? '';
        final isAvail = (item['isAvailable'] == true || item['availabilityStatus'] == 'Available') ? 1 : 0;
        final rating = ((item['rating'] ?? 5.0) as num).toDouble();

        await _mysqlConn!.query('''
          REPLACE INTO machines (id, name, category, rentalPricePerDay, location, isAvailable, rating, raw_json)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [id, name, category, price, location, isAvail, rating, jsonStr]);
      } else if (table == 'workers') {
        final name = item['name']?.toString() ?? '';
        final category = item['category']?.toString() ?? '';
        final rate = ((item['dailyRate'] ?? 0) as num).toDouble();
        final location = item['location']?.toString() ?? '';
        final isAvail = (item['isAvailable'] == true) ? 1 : 0;
        final rating = ((item['rating'] ?? 5.0) as num).toDouble();

        await _mysqlConn!.query('''
          REPLACE INTO workers (id, name, category, dailyRate, location, isAvailable, rating, raw_json)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [id, name, category, rate, location, isAvail, rating, jsonStr]);
      } else if (table == 'provider_applications') {
        final appId = item['applicationId']?.toString() ?? id;
        final userName = item['userName']?.toString() ?? item['applicantName']?.toString() ?? '';
        final phone = item['userPhone']?.toString() ?? item['applicantPhone']?.toString() ?? '';
        final serviceType = item['serviceType']?.toString() ?? item['applicantRole']?.toString() ?? '';
        final status = item['status']?.toString() ?? 'PENDING';
        final price = ((item['rentalPricePerDay'] ?? item['dailyRate'] ?? 0) as num).toDouble();

        await _mysqlConn!.query('''
          REPLACE INTO provider_applications (id, applicationId, userName, userPhone, serviceType, status, rentalPricePerDay, raw_json)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [id, appId, userName, phone, serviceType, status, price, jsonStr]);
      } else if (table == 'users') {
        final name = item['name']?.toString() ?? '';
        final phone = item['phone']?.toString() ?? '';
        final role = item['role']?.toString() ?? '';
        final loc = item['locationName']?.toString() ?? '';

        await _mysqlConn!.query('''
          REPLACE INTO users (id, name, phone, role, locationName, raw_json)
          VALUES (?, ?, ?, ?, ?, ?)
        ''', [id, name, phone, role, loc, jsonStr]);
      } else if (table == 'marketplace_products') {
        final title = item['title']?.toString() ?? '';
        final category = item['category']?.toString() ?? '';
        final price = ((item['price'] ?? 0) as num).toDouble();
        final unit = item['unit']?.toString() ?? '';

        await _mysqlConn!.query('''
          REPLACE INTO marketplace_products (id, title, category, price, unit, raw_json)
          VALUES (?, ?, ?, ?, ?, ?)
        ''', [id, title, category, price, unit, jsonStr]);
      } else if (table == 'bookings') {
        final title = item['targetTitle']?.toString() ?? '';
        final cust = item['customerName']?.toString() ?? '';
        final amt = ((item['totalAmount'] ?? 0) as num).toDouble();
        final status = item['bookingStatus']?.toString() ?? '';

        await _mysqlConn!.query('''
          REPLACE INTO bookings (id, targetTitle, customerName, totalAmount, bookingStatus, raw_json)
          VALUES (?, ?, ?, ?, ?, ?)
        ''', [id, title, cust, amt, status, jsonStr]);
      } else if (table == 'activity_logs') {
        final admin = item['admin']?.toString() ?? '';
        final action = item['action']?.toString() ?? '';
        final module = item['module']?.toString() ?? '';
        final date = item['date']?.toString() ?? '';
        final details = item['details']?.toString() ?? '';

        await _mysqlConn!.query('''
          REPLACE INTO activity_logs (id, admin, action, module, date, details, raw_json)
          VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', [id, admin, action, module, date, details, jsonStr]);
      }
    } catch (e) {
      print('MySQL Sync Item Error for $table: $e');
    }
  }

  Future<void> _deleteItemFromMySql(String table, String idValue) async {
    if (!_mysqlConnected || _mysqlConn == null) return;
    final validTables = ['machines', 'workers', 'provider_applications', 'users', 'marketplace_products', 'bookings', 'activity_logs'];
    if (!validTables.contains(table)) return;
    try {
      await _mysqlConn!.query('DELETE FROM `$table` WHERE id = ?', [idValue]);
    } catch (e) {
      print('MySQL Delete Error: $e');
    }
  }

  Future<void> _syncAllToMySql() async {
    if (!_mysqlConnected || _mysqlConn == null) return;
    final tables = ['machines', 'workers', 'provider_applications', 'users', 'marketplace_products', 'bookings', 'activity_logs'];
    for (var t in tables) {
      final list = getList(t);
      for (var item in list) {
        if (item is Map<String, dynamic>) {
          await _syncItemToMySql(t, item);
        }
      }
    }
    print('🐬 All collections synced to MySQL database `krushi_mithra`!');
  }

  Future<void> save() async {
    final file = File(_filePath);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(_data));
  }

  Map<String, dynamic> get data => _data;

  List<dynamic> getList(String table) => (_data[table] as List<dynamic>?) ?? [];

  void setList(String table, List<dynamic> list) {
    _data[table] = list;
    save();
    for (var item in list) {
      if (item is Map<String, dynamic>) {
        _syncItemToMySql(table, item);
      }
    }
  }

  Map<String, dynamic>? getItem(String table, String idField, String idValue) {
    final list = getList(table);
    for (var item in list) {
      if (item is Map<String, dynamic> && item[idField]?.toString() == idValue) {
        return item;
      }
    }
    return null;
  }

  void addItem(String table, Map<String, dynamic> item) {
    final list = getList(table);
    list.insert(0, item);
    _data[table] = list;
    save();
    _syncItemToMySql(table, item);
  }

  bool updateItem(String table, String idField, String idValue, Map<String, dynamic> updatedFields) {
    final list = getList(table);
    for (int i = 0; i < list.length; i++) {
      if (list[i] is Map<String, dynamic> && list[i][idField]?.toString() == idValue) {
        final existing = Map<String, dynamic>.from(list[i] as Map<String, dynamic>);
        updatedFields.forEach((key, value) {
          existing[key] = value;
        });
        list[i] = existing;
        _data[table] = list;
        save();
        _syncItemToMySql(table, existing);
        return true;
      }
    }
    return false;
  }

  bool deleteItem(String table, String idField, String idValue) {
    final list = getList(table);
    final initialLen = list.length;
    list.removeWhere((item) => item is Map<String, dynamic> && item[idField]?.toString() == idValue);
    if (list.length != initialLen) {
      _data[table] = list;
      save();
      _deleteItemFromMySql(table, idValue);
      return true;
    }
    return false;
  }

  void _ensureDefaults() {
    _data['users'] ??= _defaultUsers;
    _data['farmers'] ??= _defaultFarmers;
    _data['machines'] ??= _defaultMachines;
    _data['workers'] ??= _defaultWorkers;
    _data['bookings'] ??= _defaultBookings;
    _data['marketplace_products'] ??= _defaultMarketplaceProducts;
    _data['store_products'] ??= _defaultStoreProducts;
    _data['machine_categories'] ??= _defaultMachineCategories;
    _data['worker_categories'] ??= _defaultWorkerCategories;
    _data['marketplace_categories'] ??= _defaultMarketplaceCategories;
    _data['store_categories'] ??= _defaultStoreCategories;
    _data['locations'] ??= _defaultLocations;
    _data['reviews'] ??= _defaultReviews;
    _data['notifications'] ??= _defaultNotifications;
    _data['banners'] ??= _defaultBanners;
    _data['app_content'] ??= _defaultAppContent;
    _data['home_sections'] ??= _defaultHomeSections;
    _data['payments'] ??= _defaultPayments;
    _data['support_tickets'] ??= _defaultSupportTickets;
    _data['admin_users'] ??= _defaultAdminUsers;
    _data['activity_logs'] ??= _defaultActivityLogs;
    _data['settings'] ??= _defaultSettings;
    if (_data['provider_applications'] == null || (_data['provider_applications'] is List && (_data['provider_applications'] as List).isEmpty)) {
      _data['provider_applications'] = List.from(_defaultProviderApplications);
    }
    save();
  }

  void _initializeDefaultData() {
    _data = {
      'users': _defaultUsers,
      'farmers': _defaultFarmers,
      'machines': _defaultMachines,
      'workers': _defaultWorkers,
      'bookings': _defaultBookings,
      'marketplace_products': _defaultMarketplaceProducts,
      'store_products': _defaultStoreProducts,
      'machine_categories': _defaultMachineCategories,
      'worker_categories': _defaultWorkerCategories,
      'marketplace_categories': _defaultMarketplaceCategories,
      'store_categories': _defaultStoreCategories,
      'locations': _defaultLocations,
      'reviews': _defaultReviews,
      'notifications': _defaultNotifications,
      'banners': _defaultBanners,
      'app_content': _defaultAppContent,
      'home_sections': _defaultHomeSections,
      'payments': _defaultPayments,
      'support_tickets': _defaultSupportTickets,
      'admin_users': _defaultAdminUsers,
      'activity_logs': _defaultActivityLogs,
      'settings': _defaultSettings,
      'provider_applications': _defaultProviderApplications,
    };
  }

  // --- Seed Datasets ---
  final List<Map<String, dynamic>> _defaultUsers = [
    {
      'id': 'usr_101',
      'name': 'Bharath Poojary',
      'phone': '+91 8904089051',
      'email': 'bharath.poojary@krushimithra.com',
      'role': 'Farmer',
      'location': 'Shivamogga, KA',
      'village': 'Thirthahalli Road',
      'taluk': 'Shivamogga',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'joinedDate': '2025-11-12',
      'status': 'Active',
      'isVerified': true,
      'profilePhoto': 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
    },
    {
      'id': 'usr_102',
      'name': 'Suresh Patil',
      'phone': '+91 8310856407',
      'email': 'suresh.patil@krushimithra.com',
      'role': 'Machine Owner',
      'location': 'Shivamogga, KA',
      'village': 'Holehonnur',
      'taluk': 'Bhadravati',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'joinedDate': '2025-08-20',
      'status': 'Active',
      'isVerified': true,
      'profilePhoto': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    },
    {
      'id': 'usr_103',
      'name': 'Venkatesh Rao',
      'phone': '+91 7204967137',
      'email': 'venkatesh.rao@krushimithra.com',
      'role': 'Machine Owner',
      'location': 'Chikamagaluru, KA',
      'village': 'Koppa Road',
      'taluk': 'Koppa',
      'district': 'Chikamagaluru',
      'state': 'Karnataka',
      'joinedDate': '2025-06-15',
      'status': 'Active',
      'isVerified': true,
      'profilePhoto': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    },
    {
      'id': 'usr_104',
      'name': 'Basavarajappa M.',
      'phone': '+91 7019064948',
      'email': 'basavaraj.m@krushimithra.com',
      'role': 'Worker',
      'location': 'Shivamogga, KA',
      'village': 'Ayanur',
      'taluk': 'Shivamogga',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'joinedDate': '2026-01-10',
      'status': 'Active',
      'isVerified': true,
      'profilePhoto': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    },
    {
      'id': 'usr_105',
      'name': 'Narayana Hegde',
      'phone': '+91 7892570830',
      'email': 'narayana.hegde@krushimithra.com',
      'role': 'Seller',
      'location': 'Shivamogga, KA',
      'village': 'Sagara Town',
      'taluk': 'Sagara',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'joinedDate': '2026-02-01',
      'status': 'Active',
      'isVerified': true,
      'profilePhoto': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
    },
  ];

  final List<Map<String, dynamic>> _defaultFarmers = [
    {
      'id': 'frm_101',
      'userId': 'usr_101',
      'name': 'Bharath Poojary',
      'phone': '+91 8904089051',
      'email': 'bharath.poojary@krushimithra.com',
      'village': 'Green Farm House, Thirthahalli Road',
      'taluk': 'Shivamogga',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'profilePhoto': 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
      'farmSizeAcres': 12.5,
      'cropTypes': ['Arecanut', 'Paddy', 'Pepper'],
      'machinesOwnedCount': 1,
      'bookingsCount': 18,
      'verificationStatus': 'Verified',
      'status': 'Active',
    },
  ];

  final List<Map<String, dynamic>> _defaultMachines = [
    {
      'id': 'm_1',
      'name': 'Mahindra 575 DI Tractor (45 HP)',
      'category': 'Tractors',
      'brand': 'Mahindra',
      'model': '575 DI',
      'manufacturingYear': 2023,
      'horsePower': '45 HP',
      'description': 'Heavy duty 45 HP Mahindra tractor with rotavator attachment. Perfect for deep ploughing, puddling, and crop transport.',
      'ownerId': 'usr_102',
      'ownerName': 'Suresh Patil',
      'ownerPhone': '+91 8310856407',
      'location': 'Shivamogga, KA',
      'village': 'Holehonnur',
      'taluk': 'Bhadravati',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'latitude': 13.9300,
      'longitude': 75.5680,
      'rentalType': 'Per Day',
      'rentalPricePerDay': 2200.0,
      'securityDeposit': 1000.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.8,
      'reviewCount': 24,
      'verificationStatus': 'Verified',
      'status': 'Approved',
      'images': [
        'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
        'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800'
      ],
      'documents': {
        'rcVerified': true,
        'insuranceVerified': true,
        'rcNumber': 'KA-14-EA-4521',
      },
      'adminNotes': 'Machine in top working condition with serviced engine.',
    },
    {
      'id': 'm_2',
      'name': 'Kubota Combine Harvester Pro-688',
      'category': 'Harvesters',
      'brand': 'Kubota',
      'model': 'PRO-688Q',
      'manufacturingYear': 2024,
      'horsePower': '68 HP',
      'description': 'High-speed paddy and wheat combine harvester. Complete grain harvesting with minimal loss and high fuel efficiency.',
      'ownerId': 'usr_103',
      'ownerName': 'Venkatesh Rao',
      'ownerPhone': '+91 7204967137',
      'location': 'Chikamagaluru, KA',
      'village': 'Koppa Road',
      'taluk': 'Koppa',
      'district': 'Chikamagaluru',
      'state': 'Karnataka',
      'latitude': 13.3161,
      'longitude': 75.7720,
      'rentalType': 'Per Day',
      'rentalPricePerDay': 5500.0,
      'securityDeposit': 3000.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.9,
      'reviewCount': 18,
      'verificationStatus': 'Verified',
      'status': 'Approved',
      'images': [
        'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800',
        'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800'
      ],
      'documents': {
        'rcVerified': true,
        'insuranceVerified': true,
        'rcNumber': 'KA-18-M-9012',
      },
      'adminNotes': 'High performance harvester, includes skilled operator.',
    },
    {
      'id': 'm_3',
      'name': 'VST Shakti 130 DI Power Tiller',
      'category': 'Power Tillers',
      'brand': 'VST Shakti',
      'model': '130 DI',
      'manufacturingYear': 2022,
      'horsePower': '13 HP',
      'description': 'Versatile 13 HP power tiller suitable for wet paddy field tilling, vegetable garden preparation, and narrow farm pathways.',
      'ownerId': 'usr_102',
      'ownerName': 'Manjunatha K.',
      'ownerPhone': '+91 8310080549',
      'location': 'Hassan, KA',
      'village': 'Alur Road',
      'taluk': 'Hassan',
      'district': 'Hassan',
      'state': 'Karnataka',
      'latitude': 13.0033,
      'longitude': 76.1004,
      'rentalType': 'Per Day',
      'rentalPricePerDay': 1200.0,
      'securityDeposit': 500.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.6,
      'reviewCount': 15,
      'verificationStatus': 'Verified',
      'status': 'Approved',
      'images': [
        'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800'
      ],
      'documents': {
        'rcVerified': true,
        'insuranceVerified': true,
      },
      'adminNotes': 'Economical power tiller.',
    },
    {
      'id': 'm_4',
      'name': 'Honda 4-Stroke Heavy Duty Bush Cutter',
      'category': 'Brush Cutters',
      'brand': 'Honda',
      'model': 'GX35',
      'manufacturingYear': 2023,
      'horsePower': '2 HP',
      'description': 'Portable grass and weed cutter machine for plantation maintenance, arecanut orchards, and edge clearing.',
      'ownerId': 'usr_105',
      'ownerName': 'Ganesh Bhat',
      'ownerPhone': '+91 9945583380',
      'location': 'Udupi, KA',
      'village': 'Karkala',
      'taluk': 'Karkala',
      'district': 'Udupi',
      'state': 'Karnataka',
      'latitude': 13.3409,
      'longitude': 74.7421,
      'rentalType': 'Per Day',
      'rentalPricePerDay': 600.0,
      'securityDeposit': 300.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.7,
      'reviewCount': 31,
      'verificationStatus': 'Verified',
      'status': 'Approved',
      'images': [
        'https://images.unsplash.com/photo-1592417817098-8f3d6ef23a28?w=800'
      ],
      'documents': {
        'rcVerified': true,
        'insuranceVerified': true,
      },
      'adminNotes': 'Includes safety gear.',
    },
    {
      'id': 'm_5',
      'name': 'Borewell Rig Machine',
      'category': 'Borewell Machines',
      'brand': 'PRD Rig',
      'model': 'Hydraulic Truck-1000',
      'manufacturingYear': 2024,
      'horsePower': '220 HP',
      'description': 'Heavy duty high-pressure hydraulic borewell drilling rig truck for agricultural water wells, casing pipe installation, and deep groundwater drilling.',
      'ownerId': 'usr_103',
      'ownerName': 'Ramesh G.',
      'ownerPhone': '+91 9113664733',
      'location': 'Davanagere, KA',
      'village': 'Harihar',
      'taluk': 'Harihar',
      'district': 'Davanagere',
      'state': 'Karnataka',
      'latitude': 14.4673,
      'longitude': 75.9241,
      'rentalType': 'Per Hour',
      'rentalPricePerDay': 1800.0,
      'securityDeposit': 5000.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.7,
      'reviewCount': 12,
      'verificationStatus': 'Pending',
      'status': 'Pending Approval',
      'images': [
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800'
      ],
      'documents': {
        'rcVerified': true,
        'insuranceVerified': true,
      },
      'adminNotes': 'Hydraulic borewell rig.',
    },
  ];

  final List<Map<String, dynamic>> _defaultWorkers = [
    {
      'id': 'w_1',
      'userId': 'usr_104',
      'name': 'Basavarajappa M.',
      'phone': '+91 7019064948',
      'skills': ['Tractor Driver', 'Harvester Operator', 'Paddy Planter/Harvester'],
      'category': 'Tractor Driver',
      'experienceYears': 12,
      'location': 'Shivamogga, KA',
      'village': 'Ayanur',
      'taluk': 'Shivamogga',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'latitude': 13.9290,
      'longitude': 75.5670,
      'dailyRate': 900.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.9,
      'reviewCount': 42,
      'isVerified': true,
      'verificationStatus': 'Verified',
      'status': 'Active',
      'profilePhoto': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'languages': ['Kannada', 'Hindi'],
      'bio': 'Expert tractor and combine harvester driver with 12+ years field experience across Malnad region farms.',
    },
    {
      'id': 'w_2',
      'userId': 'usr_103',
      'name': 'Subramanya Bhat',
      'phone': '+91 8217353139',
      'skills': ['Arecanut Tree Climber/Harvester', 'Bush & Grass Cutting Specialist'],
      'category': 'Arecanut Worker',
      'experienceYears': 8,
      'location': 'Chikamagaluru, KA',
      'village': 'Koppa',
      'taluk': 'Koppa',
      'district': 'Chikamagaluru',
      'state': 'Karnataka',
      'latitude': 13.3150,
      'longitude': 75.7710,
      'dailyRate': 1100.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.95,
      'reviewCount': 56,
      'isVerified': true,
      'verificationStatus': 'Verified',
      'status': 'Active',
      'profilePhoto': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'languages': ['Kannada'],
      'bio': 'Professional arecanut harvester & spraying expert with safety harness equipment and high speed harvesting skills.',
    },
    {
      'id': 'w_3',
      'userId': 'usr_101',
      'name': 'Kumar & Team (4 Workers)',
      'phone': '+91 9019439854',
      'skills': ['Paddy Planter/Harvester', 'General Farm Laborer'],
      'category': 'Harvesting Team',
      'experienceYears': 10,
      'location': 'Mandya, KA',
      'village': 'Maddur',
      'taluk': 'Maddur',
      'district': 'Mandya',
      'state': 'Karnataka',
      'latitude': 12.5218,
      'longitude': 76.8951,
      'dailyRate': 2800.0,
      'availabilityStatus': 'Available',
      'isAvailable': true,
      'rating': 4.7,
      'reviewCount': 29,
      'isVerified': true,
      'verificationStatus': 'Verified',
      'status': 'Active',
      'profilePhoto': 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=400',
      'languages': ['Kannada', 'Tamil'],
      'bio': 'Paddy transplanting & sugarcane cutting field labor team. Fast execution and well-disciplined farm workers.',
    },
  ];

  final List<Map<String, dynamic>> _defaultProviderApplications = [
    {
      'id': 'app_1001',
      'applicationId': 'KM-APP-10245',
      'userId': 'usr_101',
      'userName': 'Bharath Poojary',
      'userPhone': '+91 8904089051',
      'userEmail': 'bharath.poojary@krushimithra.com',
      'userLocation': 'Shivamogga, KA',
      'village': 'Thirthahalli Road',
      'taluk': 'Shivamogga',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'profilePhoto': 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
      'serviceType': 'Rent My Machine',
      'machineName': 'John Deere 5310 Tractor (55 HP)',
      'category': 'Tractors',
      'brand': 'John Deere',
      'model': '5310 Trem IV',
      'manufacturingYear': 2024,
      'horsePower': '55 HP',
      'description': 'Heavy duty 55 HP John Deere 4WD tractor with 7-foot rotavator attachment and tipping trailer.',
      'rentalType': 'Per Day',
      'rentalPricePerDay': 2500.0,
      'securityDeposit': 1500.0,
      'operatorIncluded': true,
      'fuelIncluded': false,
      'availabilityStatus': 'Available',
      'serviceRadiusKm': 25,
      'images': [
        'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
        'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800'
      ],
      'documents': [
        {'name': 'Tractor RC Copy', 'status': 'Uploaded', 'url': 'rc_doc_sample.pdf'},
        {'name': 'Insurance Policy', 'status': 'Uploaded', 'url': 'insurance_doc_sample.pdf'}
      ],
      'agreementAccepted': true,
      'acceptedDate': '2026-09-04 10:30 AM',
      'status': 'PENDING',
      'submittedAt': '2026-09-04 10:30 AM',
      'rejectionReason': null,
    },
    {
      'id': 'app_1002',
      'applicationId': 'KM-APP-10246',
      'userId': 'usr_105',
      'userName': 'Narayana Hegde',
      'userPhone': '+91 7892570830',
      'userEmail': 'narayana.hegde@krushimithra.com',
      'userLocation': 'Shivamogga, KA',
      'village': 'Sagara Town',
      'taluk': 'Sagara',
      'district': 'Shivamogga',
      'state': 'Karnataka',
      'profilePhoto': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
      'serviceType': 'Work as Driver',
      'machineName': 'Expert Arecanut Climber & Harvester',
      'category': 'Arecanut Worker',
      'brand': 'N/A',
      'model': 'N/A',
      'manufacturingYear': 2024,
      'horsePower': 'N/A',
      'description': '8+ years experience in Arecanut harvesting, spraying and tree pruning with safety gear.',
      'rentalType': 'Per Day',
      'rentalPricePerDay': 1200.0,
      'securityDeposit': 0.0,
      'operatorIncluded': true,
      'fuelIncluded': false,
      'availabilityStatus': 'Available',
      'serviceRadiusKm': 35,
      'images': [
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400'
      ],
      'documents': [
        {'name': 'Aadhaar Card', 'status': 'Uploaded', 'url': 'aadhaar_doc.pdf'}
      ],
      'agreementAccepted': true,
      'acceptedDate': '2026-09-03 04:15 PM',
      'status': 'PENDING',
      'submittedAt': '2026-09-03 04:15 PM',
      'rejectionReason': null,
    }
  ];

  final List<Map<String, dynamic>> _defaultBookings = [
    {
      'id': 'b_1001',
      'bookingType': 'machine',
      'targetId': 'm_1',
      'targetTitle': 'Mahindra 575 DI Tractor (45 HP)',
      'targetImageUrl': 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
      'customerId': 'usr_101',
      'customerName': 'Bharath Poojary',
      'customerPhone': '+91 8904089051',
      'providerId': 'usr_102',
      'providerName': 'Suresh Patil',
      'providerPhone': '+91 8310856407',
      'startDate': '2026-09-01',
      'endDate': '2026-09-02',
      'totalAmount': 2200.0,
      'securityDeposit': 1000.0,
      'paymentMethod': 'Cash on Delivery',
      'paymentStatus': 'Paid',
      'bookingStatus': 'Completed',
      'createdAt': '2026-08-28',
      'serviceLocation': 'Shivamogga, KA',
      'timeline': [
        {'title': 'Booking Created', 'date': '2026-08-28 10:00 AM', 'completed': true},
        {'title': 'Owner Accepted', 'date': '2026-08-28 11:30 AM', 'completed': true},
        {'title': 'Payment Completed', 'date': '2026-09-01 08:00 AM', 'completed': true},
        {'title': 'Rental Started', 'date': '2026-09-01 09:00 AM', 'completed': true},
        {'title': 'Rental Completed', 'date': '2026-09-02 06:00 PM', 'completed': true},
      ]
    }
  ];

  final List<Map<String, dynamic>> _defaultMarketplaceProducts = [
    {
      'id': 'p_1',
      'title': 'Premium Quality Red Rashi Arecanut (Dry)',
      'category': 'Arecanut',
      'sellerId': 'usr_105',
      'sellerName': 'Narayana Hegde',
      'sellerPhone': '+91 7892570830',
      'images': [
        'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800',
      ],
      'description': 'Sun-dried high grade Malnad Rashi arecanut harvest. 100% organic processed without chemical dyes.',
      'price': 480.0,
      'unit': 'kg',
      'quantityAvailable': 500.0,
      'location': 'Shivamogga, KA',
      'isAgroStoreItem': false,
      'rating': 4.9,
      'status': 'Approved',
      'isFeatured': true,
    },
  ];

  final List<Map<String, dynamic>> _defaultStoreProducts = [
    {
      'id': 'store_1',
      'title': 'Hybrid Paddy Seeds - Jyothi High Yield (10 kg Bag)',
      'category': 'Seeds',
      'brand': 'Krushi Mithra Certified',
      'sellerId': 'store_admin',
      'sellerName': 'Krushi Mithra Official Agro Store',
      'sellerPhone': '+91 8000999000',
      'images': [
        'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800',
      ],
      'description': 'Certified disease-resistant high yield paddy seed variety suitable for irrigated and rainfed conditions.',
      'price': 850.0,
      'discount': 10.0,
      'unit': 'bag',
      'quantityAvailable': 100.0,
      'location': 'Shivamogga, KA',
      'isAgroStoreItem': true,
      'rating': 4.8,
      'status': 'Active',
      'isFeatured': true,
    },
  ];

  final List<Map<String, dynamic>> _defaultMachineCategories = [
    {'id': 'cat_m1', 'name': 'Tractors', 'icon': '🚜', 'description': 'Heavy & mini tractors for tilling and haulage', 'status': 'Enabled', 'displayOrder': 1},
    {'id': 'cat_m2', 'name': 'Harvesters', 'icon': '🌾', 'description': 'Paddy, wheat & sugarcane combine harvesters', 'status': 'Enabled', 'displayOrder': 2},
    {'id': 'cat_m3', 'name': 'Power Tillers', 'icon': '⚙️', 'description': 'Lightweight rotary tillers for wet/dry fields', 'status': 'Enabled', 'displayOrder': 3},
    {'id': 'cat_m4', 'name': 'Rotavators', 'icon': '🔩', 'description': 'Tractor rotary tillers for soil preparation', 'status': 'Enabled', 'displayOrder': 4},
    {'id': 'cat_m5', 'name': 'Cultivators', 'icon': '🌱', 'description': 'Secondary tillage cultivators', 'status': 'Enabled', 'displayOrder': 5},
    {'id': 'cat_m6', 'name': 'Seeders', 'icon': '🌾', 'description': 'Seed drillers and precision seeders', 'status': 'Enabled', 'displayOrder': 6},
    {'id': 'cat_m7', 'name': 'Ploughs', 'icon': '🗡️', 'description': 'Disc & mouldboard ploughs', 'status': 'Enabled', 'displayOrder': 7},
    {'id': 'cat_m8', 'name': 'Trailers', 'icon': '🚛', 'description': 'Hydraulic & tipping farm trailers', 'status': 'Enabled', 'displayOrder': 8},
    {'id': 'cat_m9', 'name': 'Brush Cutters', 'icon': '✂️', 'description': 'Grass, weed & orchard bush cutters', 'status': 'Enabled', 'displayOrder': 9},
    {'id': 'cat_m10', 'name': 'Sprayers', 'icon': '💦', 'description': 'Power sprayers and boom sprayers', 'status': 'Enabled', 'displayOrder': 10},
    {'id': 'cat_m11', 'name': 'Water Pumps', 'icon': '🚰', 'description': 'Diesel & electric irrigation pumps', 'status': 'Enabled', 'displayOrder': 11},
    {'id': 'cat_m12', 'name': 'Borewell Machines', 'icon': '🕳️', 'description': 'Hydraulic drilling rig trucks', 'status': 'Enabled', 'displayOrder': 12},
    {'id': 'cat_m13', 'name': 'Wical Machines', 'icon': '🏭', 'description': 'De-huskers and specialized agri machinery', 'status': 'Enabled', 'displayOrder': 13},
    {'id': 'cat_m14', 'name': 'Threshers', 'icon': '⚡', 'description': 'Multi-crop threshing machinery', 'status': 'Enabled', 'displayOrder': 14},
    {'id': 'cat_m15', 'name': 'Reapers', 'icon': '🔪', 'description': 'Paddy & crop reapers', 'status': 'Enabled', 'displayOrder': 15},
    {'id': 'cat_m16', 'name': 'Transplanters', 'icon': '🌿', 'description': 'Paddy transplanter machines', 'status': 'Enabled', 'displayOrder': 16},
    {'id': 'cat_m17', 'name': 'Other Agricultural Equipment', 'icon': '🔧', 'description': 'Misc farming tools', 'status': 'Enabled', 'displayOrder': 17},
  ];

  final List<Map<String, dynamic>> _defaultWorkerCategories = [
    {'id': 'cat_w1', 'name': 'Tractor Driver', 'icon': '🚜', 'description': 'Skilled drivers for tractors & haulage', 'status': 'Enabled'},
    {'id': 'cat_w2', 'name': 'Harvester Operator', 'icon': '🌾', 'description': 'Combine harvester operators', 'status': 'Enabled'},
    {'id': 'cat_w3', 'name': 'Power Tiller Operator', 'icon': '⚙️', 'description': 'Power tiller field operators', 'status': 'Enabled'},
    {'id': 'cat_w4', 'name': 'Paddy Worker', 'icon': '🌱', 'description': 'Transplanting, weeding, paddy harvesting', 'status': 'Enabled'},
    {'id': 'cat_w5', 'name': 'Plantation Worker', 'icon': '🌴', 'description': 'Coffee, tea & rubber plantation labor', 'status': 'Enabled'},
    {'id': 'cat_w6', 'name': 'Arecanut Worker', 'icon': '🥥', 'description': 'Tree climbing, harvesting & husk removal', 'status': 'Enabled'},
    {'id': 'cat_w7', 'name': 'Harvesting Team', 'icon': '👥', 'description': 'Group teams for large scale harvest', 'status': 'Enabled'},
    {'id': 'cat_w8', 'name': 'General Farm Worker', 'icon': '👨‍🌾', 'description': 'General farm maintenance labor', 'status': 'Enabled'},
    {'id': 'cat_w9', 'name': 'Other', 'icon': '🛠️', 'description': 'Specialized labor', 'status': 'Enabled'},
  ];

  final List<Map<String, dynamic>> _defaultMarketplaceCategories = [
    {'id': 'cat_mp1', 'name': 'Arecanut', 'icon': '🥥', 'status': 'Enabled'},
    {'id': 'cat_mp2', 'name': 'Pepper', 'icon': '🌶️', 'status': 'Enabled'},
    {'id': 'cat_mp3', 'name': 'Rice', 'icon': '🌾', 'status': 'Enabled'},
    {'id': 'cat_mp4', 'name': 'Coconut', 'icon': '🥥', 'status': 'Enabled'},
    {'id': 'cat_mp5', 'name': 'Vegetables', 'icon': '🥦', 'status': 'Enabled'},
    {'id': 'cat_mp6', 'name': 'Fruits', 'icon': '🍎', 'status': 'Enabled'},
    {'id': 'cat_mp7', 'name': 'Seeds', 'icon': '🌱', 'status': 'Enabled'},
    {'id': 'cat_mp8', 'name': 'Other Crops', 'icon': '📦', 'status': 'Enabled'},
  ];

  final List<Map<String, dynamic>> _defaultStoreCategories = [
    {'id': 'cat_st1', 'name': 'Seeds', 'icon': '🌱', 'status': 'Enabled'},
    {'id': 'cat_st2', 'name': 'Fertilizers', 'icon': '🧪', 'status': 'Enabled'},
    {'id': 'cat_st3', 'name': 'Pesticides', 'icon': '🛡️', 'status': 'Enabled'},
    {'id': 'cat_st4', 'name': 'Tools', 'icon': '🛠️', 'status': 'Enabled'},
    {'id': 'cat_st5', 'name': 'Farm Equipment', 'icon': '🚜', 'status': 'Enabled'},
    {'id': 'cat_st6', 'name': 'Organic Products', 'icon': '🥬', 'status': 'Enabled'},
    {'id': 'cat_st7', 'name': 'Irrigation', 'icon': '💧', 'status': 'Enabled'},
    {'id': 'cat_st8', 'name': 'Other', 'icon': '📦', 'status': 'Enabled'},
  ];

  final List<Map<String, dynamic>> _defaultLocations = [
    {
      'state': 'Karnataka',
      'districts': [
        {
          'name': 'Shivamogga',
          'taluks': ['Shivamogga Taluk', 'Bhadravati', 'Sagara', 'Thirthahalli', 'Shikaripura', 'Sorghab', 'Hosanagara']
        },
        {
          'name': 'Chikamagaluru',
          'taluks': ['Chikamagaluru Taluk', 'Koppa', 'Mudigere', 'Sringeri', 'Tarikere', 'Kadur']
        },
        {
          'name': 'Hassan',
          'taluks': ['Hassan Taluk', 'Alur', 'Arkalgud', 'Belur', 'Channarayapatna', 'Holenarasipur', 'Sakleshpur']
        },
        {
          'name': 'Mandya',
          'taluks': ['Mandya Taluk', 'Maddur', 'Malavalli', 'Pandavapura', 'Srirangapatna', 'Nagarmangala']
        },
        {
          'name': 'Udupi',
          'taluks': ['Udupi Taluk', 'Karkala', 'Kundapura', 'Brahmavara', 'Kaup', 'Byndoor']
        },
        {
          'name': 'Davanagere',
          'taluks': ['Davanagere Taluk', 'Harihar', 'Honnali', 'Channagiri', 'Jagalur']
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _defaultReviews = [
    {
      'id': 'rev_1',
      'userName': 'Bharath Poojary',
      'targetType': 'Machine',
      'targetTitle': 'Mahindra 575 DI Tractor',
      'rating': 5,
      'comment': 'Tractor performance was smooth and rotavator done a great job on my paddy field. Punctual delivery.',
      'date': '2026-09-02',
      'status': 'Approved',
    },
  ];

  final List<Map<String, dynamic>> _defaultNotifications = [
    {
      'id': 'notif_1',
      'title': 'Monsoon Machine Rental Discount!',
      'message': 'Get 15% off on combine harvester bookings this week across Shivamogga & Chikamagaluru.',
      'targetAudience': 'Farmers',
      'type': 'Promotion',
      'status': 'Sent',
      'sentAt': '2026-09-01 09:00 AM',
    },
  ];

  final List<Map<String, dynamic>> _defaultBanners = [
    {
      'id': 'ban_1',
      'title': 'Tractor & Machinery Rentals',
      'subtitle': 'Rent top-grade farm tractors, rotavators & harvesters starting @ ₹600/day',
      'buttonText': 'Rent Machine Now',
      'targetScreen': 'Machines',
      'imageUrl': 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
      'status': 'Active',
      'displayOrder': 1,
    },
  ];

  final Map<String, dynamic> _defaultAppContent = {
    'homeGreeting': 'Together we grow, together we prosper.',
    'heroTitle': 'KRUSHI MITHRA',
    'heroSubtitle': 'Digital Farming Marketplace & Agricultural Services Platform',
    'machineSectionTitle': 'Available Machinery for Rent',
    'workerSectionTitle': 'Hire Skilled Farm Workers & Drivers',
    'marketplaceSectionTitle': 'Direct Farmer Produce Marketplace',
    'agroStoreSectionTitle': 'Agro Store - Supplies & Fertilizers',
    'safetyMessage': 'All machines and workers are verified by Krushi Mithra safety team.',
    'supportMessage': 'Need assistance with your booking? Call our Helpline: +91 8000 999 000',
  };

  final List<Map<String, dynamic>> _defaultHomeSections = [
    {'id': 'sec_hero', 'title': 'Hero Banner', 'enabled': true, 'order': 1},
    {'id': 'sec_services', 'title': 'Main Services Grid', 'enabled': true, 'order': 2},
    {'id': 'sec_machines', 'title': 'Featured Machinery', 'enabled': true, 'order': 3},
    {'id': 'sec_workers', 'title': 'Featured Workers & Drivers', 'enabled': true, 'order': 4},
  ];

  final List<Map<String, dynamic>> _defaultPayments = [
    {
      'id': 'pay_9001',
      'user': 'Bharath Poojary',
      'bookingId': 'b_1001',
      'amount': 2200.0,
      'method': 'Cash on Delivery',
      'date': '2026-09-01',
      'status': 'Success',
    },
  ];

  final List<Map<String, dynamic>> _defaultSupportTickets = [
    {
      'id': 'tkt_501',
      'userName': 'Suresh Patil',
      'userPhone': '+91 8310856407',
      'category': 'Booking issue',
      'subject': 'Delay in machine return by renter',
      'description': 'The tractor was scheduled to return at 6 PM but renter returned at 8 PM.',
      'priority': 'Medium',
      'status': 'In Progress',
      'createdAt': '2026-09-03 07:00 PM',
      'adminReply': 'Support agent contacted both parties. Extended hour fee credited to wallet.',
    }
  ];

  final List<Map<String, dynamic>> _defaultAdminUsers = [
    {
      'id': 'adm_1',
      'name': 'Super Administrator',
      'email': 'admin@krushimithra.com',
      'role': 'Super Admin',
      'status': 'Active',
      'lastLogin': '2026-09-04 10:00 AM',
    },
  ];

  final List<Map<String, dynamic>> _defaultActivityLogs = [
    {
      'id': 'log_1',
      'admin': 'Super Administrator',
      'action': 'System Initialized',
      'module': 'System',
      'date': '2026-09-04 09:30 AM',
      'ip': '127.0.0.1',
      'details': 'Krushi Mithra Provider Approval System online',
    },
  ];

  final Map<String, dynamic> _defaultSettings = {
    'appName': 'KRUSHI MITHRA',
    'tagline': 'Digital Farming Marketplace & Agricultural Services Platform',
    'logoUrl': 'assets/images/app_logo.png',
    'supportEmail': 'support@krushimithra.com',
    'supportPhone': '+91 8000 999 000',
    'officeAddress': 'Agri Tech Hub, Near DC Office, Shivamogga, Karnataka 577201',
    'currencySymbol': '₹',
    'currencyCode': 'INR',
    'minRentalDays': 1,
    'maxRentalDays': 30,
    'cancellationFeePercent': 5.0,
    'defaultSecurityDeposit': 1000.0,
    'termsAndConditions': 'Standard Krushi Mithra farmer platform terms apply.',
    'privacyPolicy': 'We respect farmer privacy and protect agricultural data.',
  };
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../database/sample_data.dart';
import '../../features/machinery/domain/entities/machine.dart';
import '../../features/workers/domain/entities/worker.dart';
import '../../features/marketplace/domain/entities/product.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final HttpClient _client = HttpClient();
  String? _activeBaseUrl;

  Future<String> _getWorkingBaseUrl() async {
    if (_activeBaseUrl != null) return _activeBaseUrl!;
    
    final candidates = ApiConfig.candidateBaseUrls;
    for (final base in candidates) {
      try {
        final uri = Uri.parse('$base/machines');
        final request = await _client.getUrl(uri).timeout(const Duration(milliseconds: 3000));
        final response = await request.close();
        if (response.statusCode == 200) {
          _activeBaseUrl = base;
          debugPrint('[API] Connected successfully to backend host: $base');
          return base;
        }
      } catch (_) {
        // Try next candidate host
      }
    }
    _activeBaseUrl = ApiConfig.baseUrl;
    return _activeBaseUrl!;
  }

  Future<dynamic> _get(String endpoint) async {
    final base = await _getWorkingBaseUrl();
    try {
      debugPrint('[API] GET $base$endpoint');
      final request = await _client.getUrl(Uri.parse('$base$endpoint')).timeout(const Duration(milliseconds: 10000));
      final response = await request.close();
      if (response.statusCode == 200) {
        final content = await response.transform(utf8.decoder).join();
        debugPrint('[API] Response: ${response.statusCode} from $endpoint');
        return jsonDecode(content);
      }
    } catch (e) {
      debugPrint('[API ERROR] Failed GET $base$endpoint: $e');
      _activeBaseUrl = null; // Reset so next request retries host candidates
    }
    return null;
  }

  Future<dynamic> _post(String endpoint, Map<String, dynamic> data) async {
    final base = await _getWorkingBaseUrl();
    try {
      debugPrint('[API] POST $base$endpoint');
      final request = await _client.postUrl(Uri.parse('$base$endpoint')).timeout(const Duration(milliseconds: 10000));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(data));
      final response = await request.close();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final content = await response.transform(utf8.decoder).join();
        debugPrint('[API] Response: ${response.statusCode} from $endpoint');
        return jsonDecode(content);
      }
    } catch (e) {
      debugPrint('[API ERROR] Failed POST $base$endpoint: $e');
      _activeBaseUrl = null;
    }
    return null;
  }

  Future<List<Machine>> fetchMachines() async {
    debugPrint('[MACHINES] Requesting machines list...');
    final data = await _get('/machines');
    
    List<dynamic>? rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic> && data['machines'] is List) {
      rawList = data['machines'] as List;
    }

    if (rawList != null && rawList.isNotEmpty) {
      try {
        final machines = rawList.map((item) {
          final m = item as Map<String, dynamic>;
          final rawImages = m['images'] ?? m['image'];
          List<String> images = [];
          if (rawImages is List) {
            images = rawImages.map((e) => e.toString()).toList();
          } else if (rawImages is String && rawImages.isNotEmpty) {
            images = [rawImages];
          }
          if (images.isEmpty) {
            images = ['https://images.unsplash.com/photo-1592982537447-7440770cbfc9?w=800'];
          }

          final price = ((m['rentalPricePerDay'] ?? m['price'] ?? 2200) as num).toDouble();
          final name = m['name']?.toString() ?? 'Machine';

          debugPrint('[MACHINES] Machine parsed: $name | Price: ₹$price/day | Available: ${m['isAvailable']}');

          return Machine(
            id: m['id']?.toString() ?? 'm_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            category: m['category']?.toString() ?? 'Tractors',
            ownerId: m['ownerId']?.toString() ?? 'owner_1',
            ownerName: m['ownerName']?.toString() ?? 'Owner',
            ownerPhone: m['ownerPhone']?.toString() ?? '',
            images: images,
            description: m['description']?.toString() ?? '',
            rentalPricePerDay: price,
            location: m['location']?.toString() ?? 'Shivamogga, KA',
            latitude: ((m['latitude'] ?? 13.9300) as num).toDouble(),
            longitude: ((m['longitude'] ?? 75.5680) as num).toDouble(),
            isAvailable: m['isAvailable'] == true || m['availabilityStatus'] == 'Available',
            rating: ((m['rating'] ?? 4.8) as num).toDouble(),
            reviewCount: (m['reviewCount'] ?? 10) as int,
            isNew: m['isNew'] == true,
          );
        }).toList();

        debugPrint('[MACHINES] Successfully loaded ${machines.length} machines from backend API.');
        return machines;
      } catch (e, st) {
        debugPrint('[MACHINES ERROR] Error parsing machine JSON: $e\n$st');
      }
    }

    debugPrint('[MACHINES WARNING] API returned null/empty. Using fallback sample dataset.');
    return SampleData.initialMachines;
  }

  Future<List<Worker>> fetchWorkers() async {
    debugPrint('[WORKERS] Requesting workers list...');
    final data = await _get('/workers');
    
    List<dynamic>? rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic> && data['workers'] is List) {
      rawList = data['workers'] as List;
    }

    if (rawList != null && rawList.isNotEmpty) {
      try {
        final workers = rawList.map((item) {
          final w = item as Map<String, dynamic>;
          final rawSkills = w['skills'];
          List<String> skills = [];
          if (rawSkills is List) {
            skills = rawSkills.map((e) => e.toString()).toList();
          } else if (rawSkills is String) {
            skills = [rawSkills];
          }
          if (skills.isEmpty) skills = ['Driver'];

          return Worker(
            id: w['id']?.toString() ?? 'w_1',
            name: w['name']?.toString() ?? 'Worker',
            phone: w['phone']?.toString() ?? '',
            skills: skills,
            experienceYears: (w['experienceYears'] ?? 5) as int,
            location: w['location']?.toString() ?? 'Shivamogga, KA',
            latitude: ((w['latitude'] ?? 13.9290) as num).toDouble(),
            longitude: ((w['longitude'] ?? 75.5670) as num).toDouble(),
            dailyRate: ((w['dailyRate'] ?? 900) as num).toDouble(),
            isAvailable: w['isAvailable'] == true || w['availabilityStatus'] == 'Available',
            availabilityStatus: w['availabilityStatus']?.toString() ?? ((w['isAvailable'] == true || w['availabilityStatus'] == 'Available') ? 'Available' : 'Busy'),
            rating: ((w['rating'] ?? 4.8) as num).toDouble(),
            reviewCount: (w['reviewCount'] ?? 12) as int,
            isVerified: w['isVerified'] == true || w['status'] == 'Approved',
            profilePhoto: w['profilePhoto']?.toString() ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
            bio: w['bio']?.toString() ?? '',
          );
        }).toList();

        debugPrint('[WORKERS] Loaded ${workers.length} workers from API.');
        return workers;
      } catch (e) {
        debugPrint('[WORKERS ERROR] $e');
      }
    }

    return SampleData.initialWorkers;
  }

  Future<List<Product>> fetchMarketplaceProducts() async {
    debugPrint('[MARKETPLACE] Requesting produce & store lists...');
    final data = await _get('/marketplace');
    final storeData = await _get('/store');
    
    final List<dynamic> rawList = [];
    if (data is List) {
      rawList.addAll(data);
    } else if (data is Map<String, dynamic> && data['products'] is List) {
      rawList.addAll(data['products'] as List);
    }

    if (storeData is List) {
      for (final s in storeData) {
        if (s is Map<String, dynamic>) {
          s['isAgroStoreItem'] = true;
          rawList.add(s);
        }
      }
    }

    if (rawList.isNotEmpty) {
      try {
        final products = rawList.map((item) {
          final p = item as Map<String, dynamic>;
          final rawImages = p['images'] ?? p['image'];
          List<String> images = [];
          if (rawImages is List) {
            images = rawImages.map((e) => e.toString()).toList();
          } else if (rawImages is String && rawImages.isNotEmpty) {
            images = [rawImages];
          }
          if (images.isEmpty) {
            images = ['https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800'];
          }

          return Product(
            id: p['id']?.toString() ?? 'p_1',
            title: p['title']?.toString() ?? 'Product',
            category: p['category']?.toString() ?? 'Seeds',
            sellerId: p['sellerId']?.toString() ?? 'krushi_store',
            sellerName: p['brand']?.toString() ?? p['sellerName']?.toString() ?? 'Krushi Mithra Official Agro Store',
            sellerPhone: p['sellerPhone']?.toString() ?? '+91 8000 999 000',
            images: images,
            description: p['description']?.toString() ?? '',
            price: ((p['price'] ?? 850) as num).toDouble(),
            unit: p['unit']?.toString() ?? 'bag',
            quantityAvailable: ((p['quantityAvailable'] ?? 100) as num).toDouble(),
            location: p['location']?.toString() ?? 'Shivamogga, KA',
            isAgroStoreItem: p['isAgroStoreItem'] == true || p['isAgroStoreItem'] == 'true',
            rating: ((p['rating'] ?? 4.9) as num).toDouble(),
          );
        }).toList();

        debugPrint('[MARKETPLACE] Loaded ${products.length} products (produce + store) from API.');
        return products;
      } catch (e) {
        debugPrint('[MARKETPLACE ERROR] $e');
      }
    }

    return SampleData.initialProducts;
  }

  Future<Map<String, dynamic>?> submitMarketplaceProduct(Map<String, dynamic> productData) async {
    debugPrint('[API] Submitting marketplace produce item: ${productData['title']}');
    final res = await _post('/marketplace', productData);
    if (res is Map<String, dynamic>) {
      return res;
    }
    return productData;
  }

  Future<Map<String, dynamic>?> submitProviderApplication(Map<String, dynamic> appData) async {
    final res = await _post('/provider/apply', appData);
    if (res is Map<String, dynamic>) {
      return res;
    }
    // Fallback local response
    final appNum = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    appData['id'] = 'app_${DateTime.now().millisecondsSinceEpoch}';
    appData['applicationId'] = 'KM-APP-$appNum';
    appData['status'] = 'PENDING';
    appData['submittedAt'] = DateTime.now().toString().split('.')[0];
    return appData;
  }

  Future<Map<String, dynamic>?> submitMachine(Map<String, dynamic> machineData) async {
    debugPrint('[API] Submitting machine listing to backend: ${machineData['name']}');
    final res = await _post('/machines', machineData);
    if (res is Map<String, dynamic>) {
      return res;
    }
    return machineData;
  }

  Future<Map<String, dynamic>?> submitWorker(Map<String, dynamic> workerData) async {
    debugPrint('[API] Submitting worker registration to backend: ${workerData['name']}');
    final res = await _post('/workers', workerData);
    if (res is Map<String, dynamic>) {
      return res;
    }
    return workerData;
  }


  Future<Map<String, dynamic>> fetchMyApplications([String? userId]) async {
    final targetId = userId ?? 'user_101';
    final data = await _get('/provider/my-applications?user_id=$targetId');
    if (data is List) {
      return {'success': true, 'applications': data};
    }
    if (data is Map<String, dynamic> && data['applications'] != null) {
      return data;
    }
    return {
      'success': true,
      'applications': [
        {
          'id': 'app_1001',
          'applicationId': 'KM-APP-10245',
          'userId': targetId,
          'applicantName': 'Bharath Poojary',
          'applicantPhone': '+91 8904089051',
          'applicantRole': 'Machine Owner',
          'title': 'John Deere 5310 Tractor (55 HP)',
          'category': 'Tractors',
          'district': 'Shivamogga',
          'taluk': 'Thirthahalli',
          'dailyRate': 2500.0,
          'status': 'PENDING',
          'submittedAt': '2026-09-04 10:30 AM',
        }
      ]
    };
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final data = await _get('/notifications');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [
      {
        'id': 'notif_1',
        'title': '🌾 Seasonal Discount: 15% Off Harvesters',
        'message': 'Book paddy and arecanut harvesters this week and get instant 15% discount on daily rates.',
        'targetAudience': 'All Users',
        'type': 'Promotion',
        'sentAt': 'Today, 9:30 AM',
        'isRead': false,
      },
      {
        'id': 'notif_2',
        'title': '⛈️ Weather Advisory: Rain Alert Shivamogga',
        'message': 'Moderate to heavy rainfall expected in Malnad region. Protect harvested arecanut and crops.',
        'targetAudience': 'Farmers',
        'type': 'Alert',
        'sentAt': 'Yesterday, 4:15 PM',
        'isRead': false,
      },
      {
        'id': 'notif_3',
        'title': '🚜 Booking Confirmed: John Deere 5310',
        'message': 'Your tractor rental booking #BK-9041 has been confirmed by provider. Operator arrives tomorrow.',
        'targetAudience': 'Farmers',
        'type': 'System',
        'sentAt': '2 days ago',
        'isRead': true,
      },
    ];
  }
}

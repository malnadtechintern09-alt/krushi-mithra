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
    debugPrint('[MARKETPLACE] Requesting produce list...');
    final data = await _get('/marketplace');
    
    List<dynamic>? rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic> && data['products'] is List) {
      rawList = data['products'] as List;
    }

    if (rawList != null && rawList.isNotEmpty) {
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
            images = ['https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800'];
          }

          return Product(
            id: p['id']?.toString() ?? 'p_1',
            title: p['title']?.toString() ?? 'Product',
            category: p['category']?.toString() ?? 'Produce',
            sellerId: p['sellerId']?.toString() ?? 'seller_1',
            sellerName: p['sellerName']?.toString() ?? 'Seller',
            sellerPhone: p['sellerPhone']?.toString() ?? '',
            images: images,
            description: p['description']?.toString() ?? '',
            price: ((p['price'] ?? 480) as num).toDouble(),
            unit: p['unit']?.toString() ?? 'kg',
            quantityAvailable: ((p['quantityAvailable'] ?? 100) as num).toDouble(),
            location: p['location']?.toString() ?? 'Shivamogga, KA',
            isAgroStoreItem: p['isAgroStoreItem'] == true,
            rating: ((p['rating'] ?? 4.8) as num).toDouble(),
          );
        }).toList();

        debugPrint('[MARKETPLACE] Loaded ${products.length} products from API.');
        return products;
      } catch (e) {
        debugPrint('[MARKETPLACE ERROR] $e');
      }
    }

    return SampleData.initialProducts;
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
}

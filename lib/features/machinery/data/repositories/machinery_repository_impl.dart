import '../../domain/entities/machine.dart';
import '../../domain/repositories/machinery_repository.dart';
import '../../../../core/services/api_service.dart';

class MachineryRepositoryImpl implements MachineryRepository {
  List<Machine> _machines = [];

  @override
  Future<List<Machine>> getMachines({
    String? category,
    String? location,
    String? searchQuery,
  }) async {
    _machines = await ApiService().fetchMachines();
    var results = List<Machine>.from(_machines);

    if (category != null && category != 'All') {
      results = results.where((m) => m.category == category).toList();
    }

    if (location != null && location.isNotEmpty && location != 'All Locations') {
      results = results.where((m) => m.location.toLowerCase().contains(location.toLowerCase())).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      results = results.where((m) =>
        m.name.toLowerCase().contains(q) ||
        m.description.toLowerCase().contains(q) ||
        m.category.toLowerCase().contains(q)
      ).toList();
    }

    return results;
  }

  @override
  Future<Machine?> getMachineById(String id) async {
    if (_machines.isEmpty) {
      _machines = await ApiService().fetchMachines();
    }
    try {
      return _machines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Machine> addMachine(Machine machine) async {
    _machines.insert(0, machine);

    try {
      final machineMap = {
        'id': machine.id,
        'name': machine.name,
        'category': machine.category,
        'ownerId': machine.ownerId,
        'ownerName': machine.ownerName,
        'ownerPhone': machine.ownerPhone,
        'images': machine.images,
        'description': machine.description,
        'rentalPricePerDay': machine.rentalPricePerDay,
        'location': machine.location,
        'latitude': machine.latitude,
        'longitude': machine.longitude,
        'rating': machine.rating,
        'isNew': machine.isNew,
        'status': 'Pending',
        'isAvailable': false,
        'availabilityStatus': 'Pending Approval',
      };
      await ApiService().submitMachine(machineMap);
    } catch (_) {}

    return machine;
  }

  @override
  Future<Machine> updateMachine(Machine machine) async {
    final index = _machines.indexWhere((m) => m.id == machine.id);
    if (index != -1) {
      _machines[index] = machine;
    }
    try {
      final machineMap = {
        'id': machine.id,
        'name': machine.name,
        'category': machine.category,
        'rentalPricePerDay': machine.rentalPricePerDay,
        'location': machine.location,
        'isAvailable': machine.isAvailable,
        'availabilityStatus': machine.isAvailable ? 'Available' : 'Unavailable',
        'rating': machine.rating,
      };
      await ApiService().updateMachineApi(machineMap);
    } catch (_) {}
    return machine;
  }

  @override
  Future<void> deleteMachine(String id) async {
    _machines.removeWhere((m) => m.id == id);
    try {
      await ApiService().deleteMachineApi(id);
    } catch (_) {}
  }
}

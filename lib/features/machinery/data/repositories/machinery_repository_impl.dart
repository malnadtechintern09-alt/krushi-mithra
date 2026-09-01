import '../../domain/entities/machine.dart';
import '../../domain/repositories/machinery_repository.dart';
import '../../../../core/database/sample_data.dart';

class MachineryRepositoryImpl implements MachineryRepository {
  final List<Machine> _machines = List.from(SampleData.initialMachines);

  @override
  Future<List<Machine>> getMachines({
    String? category,
    String? location,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
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
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _machines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Machine> addMachine(Machine machine) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _machines.insert(0, machine);
    return machine;
  }

  @override
  Future<Machine> updateMachine(Machine machine) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _machines.indexWhere((m) => m.id == machine.id);
    if (index != -1) {
      _machines[index] = machine;
    }
    return machine;
  }

  @override
  Future<void> deleteMachine(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _machines.removeWhere((m) => m.id == id);
  }
}

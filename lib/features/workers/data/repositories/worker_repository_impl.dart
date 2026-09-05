import '../../domain/entities/worker.dart';
import '../../domain/repositories/worker_repository.dart';
import '../../../../core/services/api_service.dart';

class WorkerRepositoryImpl implements WorkerRepository {
  List<Worker> _workers = [];

  @override
  Future<List<Worker>> getWorkers({
    String? skill,
    String? location,
    String? searchQuery,
  }) async {
    _workers = await ApiService().fetchWorkers();
    var results = List<Worker>.from(_workers);

    if (skill != null && skill != 'All') {
      results = results.where((w) => w.skills.contains(skill)).toList();
    }

    if (location != null && location.isNotEmpty && location != 'All Locations') {
      results = results.where((w) => w.location.toLowerCase().contains(location.toLowerCase())).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      results = results.where((w) =>
        w.name.toLowerCase().contains(q) ||
        w.skills.any((s) => s.toLowerCase().contains(q)) ||
        w.bio.toLowerCase().contains(q)
      ).toList();
    }

    return results;
  }

  @override
  Future<Worker?> getWorkerById(String id) async {
    if (_workers.isEmpty) {
      _workers = await ApiService().fetchWorkers();
    }
    try {
      return _workers.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Worker> registerWorker(Worker worker) async {
    _workers.insert(0, worker);
    return worker;
  }

  @override
  Future<Worker> updateWorker(Worker worker) async {
    final index = _workers.indexWhere((w) => w.id == worker.id);
    if (index != -1) {
      _workers[index] = worker;
    }
    return worker;
  }
}

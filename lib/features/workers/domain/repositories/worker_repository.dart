import '../entities/worker.dart';

abstract class WorkerRepository {
  Future<List<Worker>> getWorkers({
    String? skill,
    String? location,
    String? searchQuery,
  });
  Future<Worker?> getWorkerById(String id);
  Future<Worker> registerWorker(Worker worker);
  Future<Worker> updateWorker(Worker worker);
}

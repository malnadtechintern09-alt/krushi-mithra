import '../entities/machine.dart';

abstract class MachineryRepository {
  Future<List<Machine>> getMachines({
    String? category,
    String? location,
    String? searchQuery,
  });
  Future<Machine?> getMachineById(String id);
  Future<Machine> addMachine(Machine machine);
  Future<Machine> updateMachine(Machine machine);
  Future<void> deleteMachine(String id);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/worker.dart';
import '../../../../shared/providers/repository_providers.dart';

class WorkerFilterState {
  final String selectedSkill;
  final String selectedLocation;
  final String searchQuery;

  const WorkerFilterState({
    this.selectedSkill = 'All',
    this.selectedLocation = 'All Locations',
    this.searchQuery = '',
  });

  WorkerFilterState copyWith({
    String? selectedSkill,
    String? selectedLocation,
    String? searchQuery,
  }) {
    return WorkerFilterState(
      selectedSkill: selectedSkill ?? this.selectedSkill,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final workerFilterProvider = StateProvider<WorkerFilterState>((ref) {
  return const WorkerFilterState();
});

final workerListProvider = FutureProvider<List<Worker>>((ref) async {
  final repo = ref.watch(workerRepositoryProvider);
  final filter = ref.watch(workerFilterProvider);
  return repo.getWorkers(
    skill: filter.selectedSkill,
    location: filter.selectedLocation,
    searchQuery: filter.searchQuery,
  );
});

final workerDetailProvider = FutureProvider.family<Worker?, String>((ref, id) async {
  final repo = ref.watch(workerRepositoryProvider);
  return repo.getWorkerById(id);
});

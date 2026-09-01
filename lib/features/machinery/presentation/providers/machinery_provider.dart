import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/machine.dart';
import '../../../../shared/providers/repository_providers.dart';

class MachineryFilterState {
  final String selectedCategory;
  final String selectedLocation;
  final String searchQuery;

  const MachineryFilterState({
    this.selectedCategory = 'All',
    this.selectedLocation = 'All Locations',
    this.searchQuery = '',
  });

  MachineryFilterState copyWith({
    String? selectedCategory,
    String? selectedLocation,
    String? searchQuery,
  }) {
    return MachineryFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final machineryFilterProvider = StateProvider<MachineryFilterState>((ref) {
  return const MachineryFilterState();
});

final machineryListProvider = FutureProvider<List<Machine>>((ref) async {
  final repo = ref.watch(machineryRepositoryProvider);
  final filter = ref.watch(machineryFilterProvider);
  return repo.getMachines(
    category: filter.selectedCategory,
    location: filter.selectedLocation,
    searchQuery: filter.searchQuery,
  );
});

final machineDetailProvider = FutureProvider.family<Machine?, String>((ref, id) async {
  final repo = ref.watch(machineryRepositoryProvider);
  return repo.getMachineById(id);
});

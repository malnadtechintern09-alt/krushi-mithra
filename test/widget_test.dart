import 'package:flutter_test/flutter_test.dart';
import 'package:krushi_mithra/app/config/constants.dart';
import 'package:krushi_mithra/core/database/sample_data.dart';

void main() {
  test('Krushi Mithra constants and initial sample data test', () {
    expect(AppConstants.appName, equals('Krushi Mithra'));
    expect(AppConstants.machineCategories.contains('Tractors'), isTrue);
    expect(AppConstants.workerSkills.contains('Tractor Driver'), isTrue);
    expect(AppConstants.marketplaceCategories.contains('Arecanut'), isTrue);
    expect(AppConstants.agroStoreCategories.contains('Seeds'), isTrue);

    expect(SampleData.initialMachines.isNotEmpty, isTrue);
    expect(SampleData.initialWorkers.isNotEmpty, isTrue);
    expect(SampleData.initialProducts.isNotEmpty, isTrue);
    expect(SampleData.initialOrders.isNotEmpty, isTrue);
  });
}

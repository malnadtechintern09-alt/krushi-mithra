import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krushi_mithra/app/config/constants.dart';
import 'package:krushi_mithra/core/database/sample_data.dart';
import 'package:krushi_mithra/core/widgets/animated_farm_background.dart';
import 'package:krushi_mithra/features/machinery/presentation/screens/machinery_list_screen.dart';
import 'package:krushi_mithra/features/workers/presentation/screens/worker_list_screen.dart';

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

  testWidgets('AnimatedFarmBackground renders child and painter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedFarmBackground(
            height: 200,
            child: Text('Test Banner Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Banner Content'), findsOneWidget);
  });

  testWidgets('MachineryListScreen renders header and title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MachineryListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rent Agricultural Machines'), findsOneWidget);
    expect(find.text('Trusted by farmers like you'), findsOneWidget);
    expect(find.text('Top Rated Machines'), findsOneWidget);
  });

  testWidgets('WorkerListScreen renders header and title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: WorkerListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hire Farm\nWorkers & Drivers'), findsOneWidget);
    expect(find.text('Right people for better farming.'), findsOneWidget);
  });
}

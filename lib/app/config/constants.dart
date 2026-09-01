class AppConstants {
  static const String appName = 'Krushi Mithra';
  static const String appTagline = 'Your Digital Agricultural Companion';

  // User Roles
  static const String roleFarmer = 'Farmer';
  static const String roleMachineOwner = 'Machine Owner';
  static const String roleWorker = 'Farm Worker / Operator';
  static const String roleSeller = 'Agro Seller';
  static const String roleAdmin = 'Admin';

  static const List<String> allRoles = [
    roleFarmer,
    roleMachineOwner,
    roleWorker,
    roleSeller,
    roleAdmin,
  ];

  // Machine Categories
  static const List<String> machineCategories = [
    'All',
    'Tractors',
    'Harvesters',
    'Power Tillers',
    'Borewell Machines',
    'Bush Cutters',
    'Wood Cutting Machines',
    'Sprayers & Pumps',
    'Transplanting Machines',
  ];

  // Worker Skills
  static const List<String> workerSkills = [
    'All',
    'Tractor Driver',
    'Harvester Operator',
    'Power Tiller Operator',
    'Arecanut Tree Climber/Harvester',
    'Paddy Planter/Harvester',
    'Bush & Grass Cutting Specialist',
    'General Farm Laborer',
  ];

  // Marketplace Categories
  static const List<String> marketplaceCategories = [
    'All',
    'Arecanut',
    'Coffee',
    'Pepper',
    'Paddy & Rice',
    'Spices',
    'Vegetables',
    'Fruits',
    'Used Farm Machinery',
    'Other Produce',
  ];

  // Agro Store Categories
  static const List<String> agroStoreCategories = [
    'All',
    'Seeds',
    'Fertilisers',
    'Crop Protection',
    'Farming Tools',
    'Irrigation Equipment',
  ];

  // Sample Nearby Locations (Karnataka Regions)
  static const List<String> sampleLocations = [
    'Shivamogga, KA',
    'Chikamagaluru, KA',
    'Hassan, KA',
    'Mysuru, KA',
    'Mandya, KA',
    'Davanagere, KA',
    'Udupi, KA',
    'Tumakuru, KA',
  ];
}

class RoutePaths {
  static const String home = '/';
  static const String machinery = '/machinery';
  static const String machineDetail = '/machinery/:id';
  static const String addMachine = '/machinery/add';
  static const String bookMachine = '/machinery/:id/book';

  static const String workers = '/workers';
  static const String workerDetail = '/workers/:id';
  static const String bookWorker = '/workers/:id/book';
  static const String registerWorker = '/workers/register';

  static const String marketplace = '/marketplace';
  static const String productDetail = '/marketplace/:id';
  static const String createListing = '/marketplace/create';

  static const String agroStore = '/agro-store';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  static const String myOrders = '/my-orders';
  static const String profile = '/profile';
  static const String admin = '/admin';

  static const String joinProvider = '/provider/join';
  static const String myApplications = '/provider/my-applications';
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/agro_store/presentation/screens/agro_store_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/agro_store/presentation/screens/cart_screen.dart';
import '../../features/agro_store/presentation/screens/checkout_screen.dart';
import '../../features/agro_store/presentation/screens/order_success_screen.dart';
import '../../features/bookings_orders/presentation/screens/my_orders_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/machinery/presentation/screens/add_machine_screen.dart';
import '../../features/machinery/presentation/screens/book_machine_screen.dart';
import '../../features/machinery/presentation/screens/machinery_detail_screen.dart';
import '../../features/machinery/presentation/screens/machinery_list_screen.dart';
import '../../features/marketplace/presentation/screens/create_listing_screen.dart';
import '../../features/marketplace/presentation/screens/marketplace_list_screen.dart';
import '../../features/marketplace/presentation/screens/product_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/provider/presentation/screens/join_provider_screen.dart';
import '../../features/provider/presentation/screens/my_applications_screen.dart';
import '../../features/workers/presentation/screens/book_worker_screen.dart';
import '../../features/workers/presentation/screens/register_worker_screen.dart';
import '../../features/workers/presentation/screens/worker_detail_screen.dart';
import '../../features/workers/presentation/screens/worker_list_screen.dart';
import 'main_navigation_shell.dart';
import 'route_names.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Machines
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.machinery,
              name: RouteNames.machinery,
              builder: (context, state) => const MachineryListScreen(),
            ),
          ],
        ),

        // Tab 2: Post Ad (Triggers Modal Sheet in MainNavigationShell)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/post-ad-placeholder',
              builder: (context, state) => const SizedBox.shrink(),
            ),
          ],
        ),

        // Tab 3: Workers
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.workers,
              name: RouteNames.workers,
              builder: (context, state) => const WorkerListScreen(),
            ),
          ],
        ),

        // Tab 4: History & Activity Details
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.myOrders,
              name: RouteNames.myOrders,
              builder: (context, state) => const MyOrdersScreen(),
            ),
          ],
        ),
      ],
    ),

    // Push routes outside shell (Full screen views)
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.marketplace,
      name: RouteNames.marketplace,
      builder: (context, state) => const MarketplaceListScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.agroStore,
      name: RouteNames.agroStore,
      builder: (context, state) => const AgroStoreScreen(),
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/machinery/add',
      name: RouteNames.addMachine,
      builder: (context, state) => const AddMachineScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/machinery/:id',
      name: RouteNames.machineDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MachineryDetailScreen(machineId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/machinery/:id/book',
      name: RouteNames.bookMachine,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookMachineScreen(machineId: id);
      },
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/workers/register',
      name: RouteNames.registerWorker,
      builder: (context, state) => const RegisterWorkerScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/workers/:id',
      name: RouteNames.workerDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return WorkerDetailScreen(workerId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/workers/:id/book',
      name: RouteNames.bookWorker,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookWorkerScreen(workerId: id);
      },
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/marketplace/create',
      name: RouteNames.createListing,
      builder: (context, state) => const CreateListingScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/marketplace/:id',
      name: RouteNames.productDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(productId: id);
      },
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.cart,
      name: RouteNames.cart,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.checkout,
      name: RouteNames.checkout,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.orderSuccess,
      name: RouteNames.orderSuccess,
      builder: (context, state) => const OrderSuccessScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.profile,
      name: RouteNames.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.joinProvider,
      name: RouteNames.joinProvider,
      builder: (context, state) => const JoinProviderScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.myApplications,
      name: RouteNames.myApplications,
      builder: (context, state) => const MyApplicationsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RoutePaths.admin,
      name: RouteNames.admin,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);

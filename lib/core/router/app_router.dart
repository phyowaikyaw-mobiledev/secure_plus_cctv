import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../features/auth/presentation/bloc/pin_auth_cubit.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/customer/contact/presentation/screens/contact_about_screen.dart';
import '../../features/customer/services/presentation/screens/service_packages_screen.dart';
import '../../features/customer/services/presentation/screens/service_request_form_screen.dart';
import '../../features/customer/tickets/presentation/screens/maintenance_ticket_form_screen.dart';
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/owner/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/owner/projects/presentation/screens/project_edit_screen.dart';
import '../../features/owner/projects/presentation/screens/projects_admin_screen.dart';
import '../../features/owner/quotes/presentation/screens/quote_builder_screen.dart';
import '../../features/owner/requests/presentation/screens/requests_admin_screen.dart';
import '../../features/owner/settings/presentation/screens/owner_settings_screen.dart';
import '../../features/owner/shell/presentation/screens/owner_shell_screen.dart';
import '../../features/owner/tickets/presentation/screens/tickets_admin_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/projects/presentation/screens/projects_grid_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String customerLogin = '/customer/login';
  static const String adminLogin = '/admin/login';
  static const String customerServices = '/customer/services';
  static const String customerServiceRequest = '/customer/service-request';
  static const String customerTicket = '/customer/ticket';
  static const String customerProjects = '/customer/projects';
  static const String customerProjectDetail = '/customer/projects/:id';
  static const String customerContact = '/customer/contact';
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerProjects = '/owner/projects';
  static const String ownerProjectEdit = '/owner/projects/edit';
  static const String ownerRequests = '/owner/requests';
  static const String ownerTickets = '/owner/tickets';
  static const String ownerQuotes = '/owner/quotes';
  static const String ownerSettings = '/owner/settings';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}

class AppRouter {
  AppRouter({required this.onboardingCubit, required this.pinAuthCubit});
  final OnboardingCubit onboardingCubit;
  final PinAuthCubit pinAuthCubit;

  Stream<dynamic> _refreshStream() {
    final controller = StreamController<dynamic>.broadcast();
    late final StreamSubscription s1, s2;
    s1 = onboardingCubit.stream.listen((e) => controller.add(e));
    s2 = pinAuthCubit.stream.listen((e) => controller.add(e));
    controller.onCancel = () async { await s1.cancel(); await s2.cancel(); await controller.close(); };
    return controller.stream;
  }

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(_refreshStream()),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final unlocked = pinAuthCubit.state.isUnlocked;
      if (loc.startsWith('/owner') && !unlocked) return AppRoutes.roleSelection;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.roleSelection, builder: (_, __) => const RoleSelectionScreen()),
      GoRoute(path: AppRoutes.customerLogin, builder: (_, __) => const CustomerLoginScreen()),
      GoRoute(path: AppRoutes.adminLogin, builder: (_, __) => const AdminLoginScreen()),
      GoRoute(path: AppRoutes.customerServices, builder: (_, __) => const ServicePackagesScreen()),
      GoRoute(path: AppRoutes.customerServiceRequest, builder: (_, __) => const ServiceRequestFormScreen()),
      GoRoute(path: AppRoutes.customerTicket, builder: (_, __) => const MaintenanceTicketFormScreen()),
      GoRoute(path: AppRoutes.customerProjects, builder: (_, __) => const ProjectsGridScreen(isAdmin: false)),
      GoRoute(
        path: AppRoutes.customerProjectDetail,
        builder: (_, state) => ProjectDetailScreen(projectId: state.pathParameters['id'] ?? '', isAdmin: false),
      ),
      GoRoute(path: AppRoutes.customerContact, builder: (_, __) => const ContactAboutScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => OwnerShellScreen(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: AppRoutes.ownerDashboard, builder: (_, __) => const AdminDashboardScreen())]),
          StatefulShellBranch(routes: [GoRoute(
            path: AppRoutes.ownerProjects,
            builder: (_, __) => const ProjectsAdminScreen(),
            routes: [GoRoute(path: 'edit', builder: (_, state) => ProjectEditScreen(projectId: state.uri.queryParameters['id']))],
          )]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoutes.ownerRequests, builder: (_, __) => const RequestsAdminScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoutes.ownerTickets, builder: (_, __) => const TicketsAdminScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoutes.ownerQuotes, builder: (_, __) => const QuoteBuilderScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoutes.ownerSettings, builder: (_, __) => const OwnerSettingsScreen())]),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(AppLocalizations.of(context)!.routeNotFound)),
    ),
  );
}

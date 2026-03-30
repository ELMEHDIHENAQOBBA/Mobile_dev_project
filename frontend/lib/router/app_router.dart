import 'package:flutter/material.dart';
import 'package:guideme/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:guideme/features/auth/presentation/screens/login_screen.dart';
import 'package:guideme/features/auth/presentation/screens/register_screen.dart';
import 'package:guideme/features/auth/presentation/screens/splash_screen.dart';
import 'package:guideme/features/booking/domain/entities/booking_entity.dart';
import 'package:guideme/features/booking/presentation/pages/booking_page.dart';
import 'package:guideme/features/booking/presentation/pages/my_bookings_page.dart';
import 'package:guideme/features/guide_space/presentation/pages/guide_dashboard_page.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';
import 'package:guideme/features/guides/presentation/pages/guide_details_page.dart';
import 'package:guideme/features/guides/presentation/pages/guides_list_page.dart';
import 'package:guideme/features/guides/presentation/pages/search_guides_page.dart';
import 'package:guideme/features/home/presentation/layout/home_layout.dart';
import 'package:guideme/features/home/presentation/screens/home_screen.dart';
import 'package:guideme/features/payment/presentation/pages/payment_page.dart';
import 'package:guideme/features/profile/presentation/pages/profile_page.dart';
import 'package:guideme/features/reviews/presentation/pages/review_page.dart';
import 'package:guideme/router/guards.dart';
import 'package:guideme/router/routes.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Routes.splash,
        redirect: AuthGuard.guard,
        routes: [
          GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
          GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
          GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
          GoRoute(
              path: Routes.booking,
              builder: (_, state) => BookingPage(guide: state.extra as GuideEntity)),
          GoRoute(
              path: Routes.payment,
              builder: (_, state) => PaymentPage(booking: state.extra as BookingEntity)),
          GoRoute(
              path: Routes.review,
              builder: (_, state) => ReviewPage(booking: state.extra as BookingEntity)),
          // GuideDashboardPage crée son propre cubit en interne
          GoRoute(
              path: Routes.guideDashboard,
              builder: (_, __) => const GuideDashboardPage()),
          ShellRoute(
            builder: (_, state, child) => HomeLayout(child: child),
            routes: [
              GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
              GoRoute(path: Routes.searchGuides, builder: (_, __) => const SearchGuidesPage()),
              GoRoute(path: Routes.guidesList, builder: (_, __) => const GuidesListPage()),
              GoRoute(
                  path: Routes.guideDetails,
                  builder: (_, state) => GuideDetailsPage(guide: state.extra as GuideEntity)),
              GoRoute(path: Routes.myBookings, builder: (_, __) => const MyBookingsPage()),
              GoRoute(path: Routes.profile, builder: (_, __) => const ProfilePage()),
              GoRoute(path: Routes.aiChat, builder: (_, __) => const AiChatPage()),
            ],
          ),
        ],
      );
}

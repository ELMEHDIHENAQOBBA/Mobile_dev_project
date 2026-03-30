import 'package:flutter/material.dart';
import 'package:guideme/router/routes.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, required this.child});
  final Widget child;

  int _currentIndex(String location) {
    if (location.startsWith(Routes.myBookings)) return 1;
    if (location.startsWith(Routes.profile)) return 2;
    if (location.startsWith(Routes.aiChat)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(location),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'My Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Guide',
          ),
        ],
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go(Routes.searchGuides);
            case 1: context.go(Routes.myBookings);
            case 2: context.go(Routes.profile);
            case 3: context.go(Routes.aiChat);
          }
        },
      ),
    );
  }
}

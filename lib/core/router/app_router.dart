import 'package:ab_abroz_inventory/features/home/presentation/onboarding_screen.dart';
import 'package:ab_abroz_inventory/features/home/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── Splash (no shell / no bottom nav) ──────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Onboarding (no shell / no bottom nav) ──────────────────────────
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex(state.uri.path),
            onTap: (index) => context.go(_tabRoutes[index]),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Inventory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.phone_outlined),
                label: 'Contact',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Inventory Screen'),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Favorites Screen'),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Contact Screen'),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Profile Screen'),
        ),
      ],
    ),

    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return _PlaceholderScreen(title: 'Item Detail - $id');
      },
    ),
  ],
);

const List<String> _tabRoutes = [
  '/home',
  '/inventory',
  '/favorites',
  '/contact',
  '/profile',
];

int _currentIndex(String location) {
  final index = _tabRoutes.indexWhere((route) => location.startsWith(route));
  return index == -1 ? 0 : index;
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title)),
    );
  }
}

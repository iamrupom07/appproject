import 'package:ab_abroz_inventory/features/home/presentation/onboarding_screen.dart';
import 'package:ab_abroz_inventory/features/home/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/detail/presentation/product_detail_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../features/home/presentation/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── Splash ────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Onboarding ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Main Shell with custom bottom nav ─────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) {
        return _AppShell(location: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Favorites'),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Contact'),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Profile'),
        ),
      ],
    ),

    // ── Item Detail ───────────────────────────────────────────────────────────
    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailScreen(machineId: id);
      },
    ),
  ],
);

// ─── Tab Configuration ─────────────────────────────────────────────────────────

const List<String> _tabRoutes = [
  '/home',
  '/inventory',
  '/favorites',
  '/contact',
  '/profile',
];

int _currentIndex(String location) {
  final index = _tabRoutes.indexWhere((r) => location.startsWith(r));
  return index == -1 ? 0 : index;
}

// ─── App Shell ─────────────────────────────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: _AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_tabRoutes[index]),
      ),
    );
  }
}

// ─── Custom Bottom Nav Bar ─────────────────────────────────────────────────────

class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                outlinedIcon: Icons.home_outlined,
                label: 'Home',
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.inventory_2_rounded,
                outlinedIcon: Icons.inventory_2_outlined,
                label: 'Inventory',
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.favorite_rounded,
                outlinedIcon: Icons.favorite_border_rounded,
                label: 'Favorites',
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.phone_rounded,
                outlinedIcon: Icons.phone_outlined,
                label: 'Contact',
                onTap: onTap,
              ),
              _NavItem(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_rounded,
                outlinedIcon: Icons.person_outline_rounded,
                label: 'Profile',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.outlinedIcon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData outlinedIcon;
  final String label;
  final ValueChanged<int> onTap;

  bool get _isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isActive ? icon : outlinedIcon,
                key: ValueKey(_isActive),
                color: _isActive ? AppColors.gold : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: _isActive ? AppColors.gold : AppColors.textSecondary,
                fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Placeholder Screens ──────────────────────────────────────────────────────

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

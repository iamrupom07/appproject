import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../home/presentation/providers/home_providers.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/favorites_header_bar.dart';
import 'widgets/favorites_machine_card.dart';
import 'widgets/favorites_sort_bar.dart';

/// Favorites screen — displays all machines the user has hearted.
///
/// State is driven entirely by [favoritedMachinesProvider] and
/// [favoritesSortProvider] — no local state needed.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(favoritedMachinesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: machines.isEmpty
              ? _EmptyLayout(machines: machines)
              : _ListLayout(machines: machines, ref: ref),
        ),
      ),
    );
  }
}

// ─── Empty layout (no saved machines) ────────────────────────────────────────

class _EmptyLayout extends StatelessWidget {
  const _EmptyLayout({required this.machines});

  // ignore: unused_field
  final List machines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header still visible so the screen feels consistent
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            0,
          ),
          child: FavoritesHeaderBar(savedCount: 0),
        ),
        const Expanded(child: FavoritesEmptyState()),
      ],
    );
  }
}

// ─── List layout (one or more saved machines) ─────────────────────────────────

class _ListLayout extends StatelessWidget {
  const _ListLayout({required this.machines, required this.ref});

  final List machines;
  final WidgetRef ref;

  void _clearAll(WidgetRef ref) {
    // Toggle all currently favourited machines off
    final ids = ref.read(favoritesProvider);
    for (final id in ids.toList()) {
      ref.read(favoritesProvider.notifier).toggle(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceMd,
              AppSizes.spaceMd,
              AppSizes.spaceMd,
              0,
            ),
            child: FavoritesHeaderBar(
              savedCount: machines.length,
              onClearAll: () => _showClearDialog(context, ref),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),

        // ── Sort bar ─────────────────────────────────────────────────────────
        const SliverToBoxAdapter(child: FavoritesSortBar()),

        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),

        // ── Machine cards list ───────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMd,
            0,
            AppSizes.spaceMd,
            AppSizes.spaceXl + AppSizes.navBarHeight,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final machine = machines[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceMd),
                  child: FavoritesMachineCard(machine: machine),
                );
              },
              childCount: machines.length,
            ),
          ),
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        title: const Text('Clear all favourites?'),
        content: const Text(
          'This will remove all saved machines from your favourites list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _clearAll(ref);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.outOfStock),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

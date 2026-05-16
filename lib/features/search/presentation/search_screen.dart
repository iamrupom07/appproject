import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/stock_badge.dart';
import '../../home/domain/machine_model.dart';
import '../../home/presentation/providers/home_providers.dart';

// ─── Recent Searches Provider ─────────────────────────────────────────────────

final _recentSearchesProvider =
    StateNotifierProvider<_RecentSearchesNotifier, List<String>>(
  (ref) => _RecentSearchesNotifier(),
);

class _RecentSearchesNotifier extends StateNotifier<List<String>> {
  _RecentSearchesNotifier() : super([]);

  void add(String query) {
    if (query.trim().isEmpty) return;
    final updated = [query, ...state.where((s) => s != query)].take(6).toList();
    state = updated;
  }

  void remove(String query) {
    state = state.where((s) => s != query).toList();
  }

  void clear() => state = [];
}

// ─── Live Search Query Provider (scoped to search screen) ─────────────────────

final _searchInputProvider = StateProvider<String>((ref) => '');

final _searchResultsProvider = Provider<List<MachineModel>>((ref) {
  final query = ref.watch(_searchInputProvider).trim().toLowerCase();
  if (query.isEmpty) return [];
  final all = ref.watch(allMachinesProvider);
  return all
      .where(
        (m) =>
            m.name.toLowerCase().contains(query) ||
            m.subtitle.toLowerCase().contains(query) ||
            m.category.label.toLowerCase().contains(query),
      )
      .toList();
});

// ─── Search Screen ────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // Auto-focus the search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    // Reset search query when leaving
    ref.read(_searchInputProvider.notifier).state = '';
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(_searchInputProvider.notifier).state = value;
  }

  void _onSubmit(String value) {
    if (value.trim().isEmpty) return;
    ref.read(_recentSearchesProvider.notifier).add(value.trim());
  }

  void _applyRecent(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    ref.read(_searchInputProvider.notifier).state = query;
    _focusNode.requestFocus();
  }

  void _clearInput() {
    _controller.clear();
    ref.read(_searchInputProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  void _navigateToItem(String id, String name) {
    ref.read(_recentSearchesProvider.notifier).add(name);
    context.push('/item/$id');
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(_searchInputProvider);
    final results = ref.watch(_searchResultsProvider);
    final recents = ref.watch(_recentSearchesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search bar row ─────────────────────────────────────────────
              _SearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onQueryChanged,
                onSubmit: _onSubmit,
                onClear: _clearInput,
                onBack: () => context.pop(),
              ),

              const Divider(height: 1, color: AppColors.divider),

              // ── Body ───────────────────────────────────────────────────────
              Expanded(
                child: query.isEmpty
                    ? _RecentSearchesView(
                        recents: recents,
                        onTap: _applyRecent,
                        onRemove: (q) => ref
                            .read(_recentSearchesProvider.notifier)
                            .remove(q),
                        onClearAll: () =>
                            ref.read(_recentSearchesProvider.notifier).clear(),
                      )
                    : results.isEmpty
                        ? _EmptyResults(query: query)
                        : _ResultsList(
                            results: results,
                            query: query,
                            onTap: _navigateToItem,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
    required this.onClear,
    required this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmit;
  final VoidCallback onClear;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceSm,
        AppSizes.spaceSm,
        AppSizes.spaceMd,
        AppSizes.spaceSm,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
            iconSize: 22,
          ),

          // Input field
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: onSubmit,
                textInputAction: TextInputAction.search,
                style: AppTextStyles.bodyMedium,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search machinery, model, brand...',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (_, value, __) => value.text.isNotEmpty
                        ? IconButton(
                            onPressed: onClear,
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Searches ──────────────────────────────────────────────────────────

class _RecentSearchesView extends StatelessWidget {
  const _RecentSearchesView({
    required this.recents,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  final List<String> recents;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (recents.isEmpty) {
      return _SearchHint();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd,
        vertical: AppSizes.spaceSm,
      ),
      children: [
        // Header
        Row(
          children: [
            Text('Recent Searches', style: AppTextStyles.headingSmall),
            const Spacer(),
            TextButton(
              onPressed: onClearAll,
              child: Text(
                'Clear all',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.outOfStock,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXs),

        // Recent items
        ...recents.map(
          (query) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
            title: Text(query, style: AppTextStyles.bodyMedium),
            trailing: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              onPressed: () => onRemove(query),
            ),
            onTap: () => onTap(query),
          ),
        ),

        const SizedBox(height: AppSizes.spaceLg),

        // Category quick-search chips
        Text('Browse by Category', style: AppTextStyles.headingSmall),
        const SizedBox(height: AppSizes.spaceSm),
        Wrap(
          spacing: AppSizes.spaceSm,
          runSpacing: AppSizes.spaceSm,
          children: MachineCategory.values
              .where((c) => c != MachineCategory.all)
              .map((c) => _CategoryPill(
                    label: c.label,
                    onTap: () => onTap(c.label),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 36,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Text('Search Machinery', style: AppTextStyles.headingMedium),
          const SizedBox(height: 6),
          Text(
            'Type a name, model, or category\nto find what you\'re looking for.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Results List ─────────────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.query,
    required this.onTap,
  });

  final List<MachineModel> results;
  final String query;
  final void Function(String id, String name) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            AppSizes.spaceSm,
          ),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} found',
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceMd,
              0,
              AppSizes.spaceMd,
              AppSizes.spaceXl,
            ),
            itemCount: results.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final machine = results[index];
              return _ResultTile(
                machine: machine,
                query: query,
                onTap: () => onTap(machine.id, machine.name),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.machine,
    required this.query,
    required this.onTap,
  });

  final MachineModel machine;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSm),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: CachedNetworkImage(
                imageUrl: machine.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    width: 64,
                    height: 64,
                    color: AppColors.shimmerBase,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: AppColors.pageBackground,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceMd),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightedText(
                    text: machine.name,
                    highlight: query,
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    machine.category.label,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatPrice(machine.price),
                        style: AppTextStyles.priceSmall,
                      ),
                      const SizedBox(width: AppSizes.spaceSm),
                      StockBadge(status: machine.status),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final s = price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '\$$s';
  }
}

// ─── Highlighted Text (bolds the matching query substring) ───────────────────

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.highlight,
    required this.style,
  });

  final String text;
  final String highlight;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) return Text(text, style: style, maxLines: 1);

    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();
    final index = lowerText.indexOf(lowerHighlight);

    if (index == -1) return Text(text, style: style, maxLines: 1);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          if (index > 0) TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + highlight.length),
            style: style.copyWith(
              color: AppColors.goldDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: text.substring(index + highlight.length)),
        ],
      ),
    );
  }
}

// ─── Empty Results ────────────────────────────────────────────────────────────

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Text('No results found', style: AppTextStyles.headingMedium),
            const SizedBox(height: 6),
            Text(
              'No machinery matched "$query".\nTry a different name or category.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

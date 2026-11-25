import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/core/themes/app_colors.dart';
import 'package:gif_explorer/app/core/themes/theme_controller.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/explorer_controller.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/widget/trending_content_widget.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final ScrollController _scrollController = ScrollController();

  bool _requestedTrending = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_requestedTrending) return;

    _requestedTrending = true;

    unawaited(
      context.read<ExplorerController>().loadTrendingGifs(
            limit: 4,
            offset: 0,
          ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Começa a buscar antes de chegar exatamente ao fim.
    if (position.extentAfter > 400) return;

    final explorerController = context.read<ExplorerController>();
    final state = explorerController.state;

    // Evita chamadas duplicadas e requisições quando não há mais resultados.
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.gifs.isEmpty ||
        state.loadMoreError != null) {
      return;
    }

    unawaited(explorerController.loadMoreTrendingGifs());
  }

  void _searchCategory(String query) {
    unawaited(
      context.read<ExplorerController>().searchGifs(
            limit: 4,
            offset: 0,
            query: query,
          ),
    );
  }

  void _showTrending() {
    unawaited(
      context.read<ExplorerController>().loadTrendingGifs(
            limit: 4,
            offset: 0,
          ),
    );
  }

  void _retryCurrentFeed() {
    final controller = context.read<ExplorerController>();
    final query = controller.state.searchQuery;

    if (query == null) {
      unawaited(
        controller.loadTrendingGifs(
          limit: 4,
          offset: 0,
        ),
      );
      return;
    }

    unawaited(
      controller.searchGifs(
        limit: 4,
        offset: 0,
        query: query,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final explorerController = context.watch<ExplorerController>();
    final explorerState = explorerController.state;
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = themeController.state.themeMode == ThemeMode.dark;

    final feedTitle = explorerState.searchQuery == null
        ? 'Trending'
        : 'Resultados para "${explorerState.searchQuery}"';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
            children: [
              TextSpan(
                text: 'GIF ',
                style: TextStyle(color: colors.primary),
              ),
              const TextSpan(text: 'Explorer'),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip:
                isDark ? 'Mudar para tema claro' : 'Mudar para tema escuro',
            onPressed: themeController.toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: colors.text,
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (query) {
                    unawaited(
                      explorerController.searchGifs(
                        limit: 4,
                        offset: 0,
                        query: query,
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for GIFs...',
                    hintStyle: TextStyle(color: colors.textMuted),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.textMuted,
                    ),
                    errorText: explorerState.searchInputError,
                    filled: true,
                    fillColor: colors.surfaceVariant,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // Categorias acima do feed.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(color: colors.primary),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryPill(
                      label: '🔥 Trending',
                      colors: colors,
                      onTap: _showTrending,
                    ),
                    _CategoryPill(
                      label: '😀 Funny',
                      colors: colors,
                      onTap: () => _searchCategory('funny'),
                    ),
                    _CategoryPill(
                      label: '❤️ Love',
                      colors: colors,
                      onTap: () => _searchCategory('love'),
                    ),
                    _CategoryPill(
                      label: '🎮 Gaming',
                      colors: colors,
                      onTap: () => _searchCategory('gaming'),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Popular',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Mais descobertas em breve',
                  style: TextStyle(color: colors.textMuted),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  feedTitle,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Center(
                  child: Text(
                    'Powered by GIPHY',
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
            ),

            TrendingContentWidget(
              state: explorerState,
              onRetry: _retryCurrentFeed,
            ),

            if (explorerState.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            if (explorerState.loadMoreError != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        explorerState.loadMoreError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMuted),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          unawaited(
                            explorerController.loadMoreTrendingGifs(),
                          );
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // As rotas de Collection e Viewer serão conectadas depois.
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Collection',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_arrow_outlined),
            selectedIcon: Icon(Icons.play_arrow),
            label: 'Viewer',
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final AppColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Text(
                label,
                style: TextStyle(color: colors.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
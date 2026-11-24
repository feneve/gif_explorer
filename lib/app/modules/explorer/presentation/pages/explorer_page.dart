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
  bool _requestedTrending = false;
  //so aconte no primeiro build das arvores de widget
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_requestedTrending) return;

    _requestedTrending = true;
    context.read<ExplorerController>().loadTrendingGifs(limit: 4, offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final explorerController = context.watch<ExplorerController>();
    final explorerState = explorerController.state;
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = themeController.state.themeMode == ThemeMode.dark;

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
            tooltip: isDark
                ? 'Mudar para tema claro'
                : 'Mudar para tema escuro',
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
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: colors.text,
                          ),
                          children: [
                            TextSpan(
                              text: 'GIF  ',
                              style: TextStyle(color: colors.primary),
                            ),
                            const TextSpan(text: 'Explorer'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Search for GIFs...',
                    hintStyle: TextStyle(color: colors.textMuted),
                    prefixIcon: Icon(Icons.search, color: colors.textMuted),
                    filled: true,
                    fillColor: colors.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('See all', style: TextStyle(color: colors.primary)),
                  ],
                ),
              ),
            ),
            TrendingContentWidget(
              state: explorerState,
              onRetry: () =>
                  explorerController.loadTrendingGifs(limit: 10, offset: 0),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Center(
                  child: explorerState.gifs.isEmpty || !explorerState.hasMore
                      ? const SizedBox.shrink()
                      : explorerState.isLoadingMore
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            explorerController.loadMoreTrendingGifs();
                          },
                          child: const Text('Carregar mais'),
                        ),
                ),
              ),
            ),
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
                    Text('See all', style: TextStyle(color: colors.primary)),
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
                    _CategoryPill(label: '🔥 Trending', colors: colors),
                    _CategoryPill(label: '😀 Funny', colors: colors),
                    _CategoryPill(label: '❤️ Love', colors: colors),
                    _CategoryPill(label: '🎮 Gaming', colors: colors),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  'Mais descobertas em breve',
                  style: TextStyle(color: colors.textMuted),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Center(
                  child: Text(
                    'Powered by GIPHY',
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
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
  const _CategoryPill({required this.label, required this.colors});

  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label, style: TextStyle(color: colors.text)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/themes/app_colors.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/states/explorer_state.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/widget/gif_grade_widget.dart';


class TrendingContentWidget extends StatelessWidget {
  const TrendingContentWidget({
    required this.state,
    required this.onRetry,
    super.key,
  });

  final ExplorerState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    switch (state.stateEnum) {
      case ExplorerStateEnum.initial:
      case ExplorerStateEnum.loading:
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );

      case ExplorerStateEnum.success:
        return GifGridWidget(gifs: state.gifs);

      case ExplorerStateEnum.empty:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Nenhum GIF encontrado.',
                style: TextStyle(color: colors.textMuted),
              ),
            ),
          ),
        );

      case ExplorerStateEnum.error:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  state.errorMensagem ??
                      'Não foi possível carregar os GIFs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textMuted),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
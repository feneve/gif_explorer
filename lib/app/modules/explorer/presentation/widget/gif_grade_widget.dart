import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/themes/app_colors.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class GifGridWidget extends StatelessWidget {
  const GifGridWidget({
    required this.gifs,
    super.key,
  });

  final List<Gif> gifs;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final gif = gifs[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                gif.previewUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: colors.surfaceVariant,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colors.textMuted,
                    ),
                  );
                },
              ),
            );
          },
          childCount: gifs.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
      ),
    );
  }
}
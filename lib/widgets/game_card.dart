import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import '../utils/format.dart';
import 'giveaway_image.dart';

/// Height of the text area under the image (title + meta row).
const double gameCardBodyHeight = 92;

/// Image aspect ratio on the card (matches the Figma design: 173 x 104).
const double gameCardImageRatio = 173 / 104;

/// One tile in the games grid.
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.giveaway, required this.onTap});

  final Giveaway giveaway;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final g = giveaway;
    final ends = formatShortDate(g.endDate);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: gameCardImageRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'giveaway-image-${g.id}',
                    child: GiveawayImage(url: g.thumbnail),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CardBadge(
                      label: g.type.toUpperCase(),
                      background: Colors.black.withValues(alpha: 0.55),
                      foreground: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: CardBadge(
                      label: g.hasWorth ? g.worth : 'FREE',
                      background: scheme.primary,
                      foreground: scheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.people_alt_outlined,
                            size: 14, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${formatCompact(g.users)} • '
                            '${ends != null ? 'Ends $ends' : 'No end date'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBadge extends StatelessWidget {
  const CardBadge({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

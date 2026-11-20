import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/giveaway.dart';
import '../utils/format.dart';
import '../widgets/giveaway_image.dart';

/// Full details of one giveaway.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.giveaway});

  final Giveaway giveaway;

  Future<void> _openGiveaway(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(giveaway.openGiveawayUrl);
    var ok = false;
    if (uri != null) {
      try {
        ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        ok = false;
      }
    }
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the giveaway link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = giveaway;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final steps = g.steps;

    final activeBg = isDark ? const Color(0xFF123A22) : const Color(0xFFDDF5E3);
    final activeFg = isDark ? const Color(0xFF7FE0A0) : const Color(0xFF1B6B35);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: scheme.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filled(
                tooltip: 'Back',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'giveaway-image-${g.id}',
                child: GiveawayImage(url: g.heroImage, iconSize: 96),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        label: g.type.toUpperCase(),
                        background: scheme.primaryContainer,
                        foreground: scheme.onPrimaryContainer,
                      ),
                      _Pill(
                        label: '● ${g.status}',
                        background:
                            g.isActive ? activeBg : scheme.errorContainer,
                        foreground:
                            g.isActive ? activeFg : scheme.onErrorContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    g.title,
                    style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (g.hasWorth) ...[
                        Text(
                          g.worth,
                          style: text.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        'FREE',
                        style: text.headlineSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.people_alt_outlined,
                          value: formatThousands(g.users),
                          label: 'Users claimed',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.schedule,
                          value: formatShortDate(g.endDate) ?? 'Open',
                          label: 'Ends',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.calendar_today_outlined,
                          value: formatShortDate(g.publishedDate) ?? '-',
                          label: 'Published',
                        ),
                      ),
                    ],
                  ),
                  if (g.platformList.isNotEmpty) ...[
                    const _SectionTitle('Platforms'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final p in g.platformList)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            child: Text(p,
                                style: text.labelLarge?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                          ),
                      ],
                    ),
                  ],
                  if (g.cleanDescription.isNotEmpty) ...[
                    const _SectionTitle('About'),
                    Text(
                      g.cleanDescription,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (steps.isNotEmpty) ...[
                    const _SectionTitle('How to claim'),
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: scheme.primaryContainer,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(steps[i],
                                    style: text.bodyMedium
                                        ?.copyWith(height: 1.4)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: g.openGiveawayUrl.isEmpty
                ? null
                : () => _openGiveaway(context),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Get Giveaway'),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(height: 6),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/giveaway.dart';
import '../services/giveaway_api.dart';
import '../widgets/game_card.dart';
import 'detail_screen.dart';

/// Games tab: loads the API and shows giveaways in a GridView.
class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  static const _filters = ['All', 'Game', 'DLC', 'Early Access'];

  final _api = GiveawayApi();
  final _searchController = TextEditingController();

  late Future<List<Giveaway>> _future;
  String _filter = 'All';
  String _query = '';
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchGiveaways();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final future = _api.fetchGiveaways();
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // The FutureBuilder shows the error.
    }
  }

  List<Giveaway> _visible(List<Giveaway> all) {
    final q = _query.trim().toLowerCase();
    return all.where((g) {
      final typeOk = _filter == 'All' || g.type == _filter;
      final queryOk = q.isEmpty ||
          g.title.toLowerCase().contains(q) ||
          g.platforms.toLowerCase().contains(q);
      return typeOk && queryOk;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  void _openDetail(Giveaway g) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(giveaway: g)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 16,
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search title or platform',
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giveaways',
                      style: text.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Free games & loot · GamerPower',
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = _filters[i];
                return ChoiceChip(
                  label: Text(f),
                  selected: _filter == f,
                  onSelected: (_) => setState(() => _filter = f),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Giveaway>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _MessageView(
                    icon: Icons.wifi_off_rounded,
                    title: 'Could not load giveaways',
                    message: snapshot.error.toString(),
                    onRetry: _reload,
                  );
                }
                final items = _visible(snapshot.data ?? const []);
                if (items.isEmpty) {
                  return _MessageView(
                    icon: Icons.search_off_rounded,
                    title: 'No giveaways found',
                    message: 'Try another filter or search word.',
                    onRetry: _reload,
                  );
                }
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: _GiveawayGrid(items: items, onTap: _openDetail),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GiveawayGrid extends StatelessWidget {
  const _GiveawayGrid({required this.items, required this.onTap});

  final List<Giveaway> items;
  final ValueChanged<Giveaway> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = 16.0;
        const spacing = 12.0;
        final width = constraints.maxWidth;
        // 2 columns on phones, more on tablets / desktop web.
        final columns = width < 600 ? 2 : (width < 900 ? 3 : (width < 1200 ? 4 : 5));
        final itemWidth =
            (width - padding * 2 - spacing * (columns - 1)) / columns;
        final itemHeight = itemWidth / gameCardImageRatio + gameCardBodyHeight;

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(padding, 8, padding, padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            mainAxisExtent: itemHeight,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) =>
              GameCard(giveaway: items[i], onTap: () => onTap(items[i])),
        );
      },
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 60),
          Icon(icon, size: 56, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: text.titleMedium),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';

/// Settings tab: dark mode switch + color theme picker.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Text('Settings',
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _SectionLabel('APPEARANCE'),
          _SettingsCard(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                secondary: const _IconTile(Icons.dark_mode),
                title: const Text('Dark mode'),
                subtitle: Text(controller.isDark
                    ? 'On · dark theme active'
                    : 'Off · light theme active'),
                value: controller.isDark,
                onChanged: controller.setDark,
              ),
              Divider(height: 1, indent: 72, color: scheme.outlineVariant),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: _IconTile(Icons.palette),
                title: Text('Color theme'),
                subtitle: Text('Choose the app accent color'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final seed in ThemeSeed.values)
                      _Swatch(
                        seed: seed,
                        selected: controller.seed == seed,
                        onTap: () => controller.setSeed(seed),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionLabel('ABOUT'),
          _SettingsCard(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: _IconTile(Icons.info),
                title: Text('Data source'),
                subtitle: Text('gamerpower.com/api/giveaways'),
              ),
              Divider(height: 1, indent: 72, color: scheme.outlineVariant),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: _IconTile(Icons.sports_esports),
                title: Text('Version'),
                subtitle: Text('1.0.0 · Flutter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: scheme.onPrimaryContainer),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.seed,
    required this.selected,
    required this.onTap,
  });

  final ThemeSeed seed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '${seed.label} theme',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? scheme.onSurface : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: seed.color,
                    shape: BoxShape.circle,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 22)
                      : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                seed.label,
                style: text.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

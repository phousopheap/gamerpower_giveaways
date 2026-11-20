import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.load();
  runApp(GamerPowerApp(themeController: themeController));
}

class GamerPowerApp extends StatelessWidget {
  const GamerPowerApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: themeController,
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) => MaterialApp(
          title: 'GamerPower Giveaways',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(themeController.seed.color),
          darkTheme: AppTheme.dark(themeController.seed.color),
          themeMode: themeController.themeMode,
          home: const HomeShell(),
        ),
      ),
    );
  }
}

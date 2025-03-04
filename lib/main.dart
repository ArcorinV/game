import 'package:flutter/material.dart';
import 'package:game/features/main/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game',
      theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MyHomePage(title: 'Game'),
    );
  }
}

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  bool _isDarkMode = false;

  ThemeNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:freela_flutter/screens/login.dart';

const kPrimaryColor = Color(0xFFE2A30);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FreelaApp());
}

class FreelaApp extends StatelessWidget {
  const FreelaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: kPrimaryColor);

    return MaterialApp(
      title: 'Freela',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
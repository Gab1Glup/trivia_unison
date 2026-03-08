import 'package:flutter/material.dart';
import 'screens/inicio_screen.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/resultado_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TriviaApp());
}

class TriviaApp extends StatelessWidget {
  const TriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivia Unison',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1A2CA3),
          secondary: Color(0xFFF68048),
        ),
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1A63),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2845D6),
          secondary: Color(0xFFF68048),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioScreen(),
        '/bienvenida': (context) => const BienvenidaScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/resultado': (context) => const ResultadoScreen(),
      },
    );
  }
}
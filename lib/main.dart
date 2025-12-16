// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const TaskPomodoroApp());
}

class TaskPomodoroApp extends StatelessWidget {
  const TaskPomodoroApp({super.key});

  // Este StatelessWidget apenas define o tema e a rota inicial.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task & Pomodoro Tracker',
      themeMode: ThemeMode.system, // Alterna entre Light e Dark automaticamente
      // --- TEMA LIGHT ---
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme:
            const ColorScheme.light(
              primary: Color(0xFF7F4D4D),
              surface: Color(0xFFFDFDFD),
            ).copyWith(
              secondary: Colors.blue, // Usado para botões e acentos.
            ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true,

        // Adaptação dos Cards para o modo Light
        cardTheme: CardThemeData(
          color: const Color(0xFFFDFDFD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1,
            ), // Borda sutil
          ),
        ),
      ),

      // --- TEMA DARK (Extraído do seu CSS) ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // --background

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFEAD9B4), // --primary (Dourado/Âmbar)
          onPrimary: Color(0xFF332D1D), // --primary-foreground

          secondary: Color(0xFF4D4639), // --secondary
          onSecondary: Color(0xFFEAD9B4), // --secondary-foreground

          surface: Color(0xFF242424), // --card
          onSurface: Color(0xFFF2F2F2), // --foreground

          outline: Color(0xFF333538), // --border
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFF2F2F2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFF2F2F2)),
        ),

        // Adaptação dos Cards para o modo Dark
        cardTheme: CardThemeData(
          color: const Color(0xFF242424),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF333538),
              width: 1,
            ), // Borda sutil
          ),
        ),
      ),
      home:
          const TaskListScreen(), // Onde o estado da lista de tarefas será gerenciado
    );
  }
}

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
      theme: ThemeData(
        // Tema iOS-like (White Theme)
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(
          0xFFF5F5F5,
        ), // Background mais suave
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
        // Cor de destaque (Ação) em azul sutil, mas vibrante.
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(
              secondary: Colors.blue, // Usado para botões e acentos.
            ),
        useMaterial3: true,
      ),
      home:
          const TaskListScreen(), // Onde o estado da lista de tarefas será gerenciado
    );
  }
}

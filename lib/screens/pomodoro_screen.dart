// lib/screens/pomodoro_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../models/task.dart';
import '../utils/time_formatter.dart';

// RF-2.1: Visualização do Tempo
class PomodoroScreen extends StatefulWidget {
  final Task? activeTask; // Recebe a tarefa ativa do TaskListScreen

  const PomodoroScreen({super.key, required this.activeTask});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // Configurações globais (RF-2.3)
  static const int _shortBreakMinutes = 5;
  static const int _longBreakMinutes = 15;
  static const int _defaultFocusMinutes = 25;

  Timer? _timer;
  bool _isRunning = false;

  // Estado do ciclo do Pomodoro
  // Total de segundos restantes no ciclo atual
  late int _totalSecondsRemaining;
  // Tipo de ciclo atual (Foco, Pausa Curta, Pausa Longa)
  String _cycleType = 'Work';
  // Contador de ciclos completos (para Pausa Longa)
  int _pomodoroCount = 0;

  // Variável para armazenar a duração do foco real (da tarefa ou padrão)
  late int _currentFocusMinutes;

  @override
  void initState() {
    super.initState();
    // Inicializa o tempo restante no início
    _initializeTimerState();
  }

  // Chamado sempre que o widget é reconstruído com novos dados (nova activeTask)
  @override
  void didUpdateWidget(covariant PomodoroScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeTask != oldWidget.activeTask) {
      // Se a tarefa ativa mudar, redefina o temporizador para a nova configuração
      _initializeTimerState();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Funções de Manipulação de Estado do Timer ---

  // Inicializa ou reseta o estado do timer
  void _initializeTimerState() {
    _timer?.cancel();
    _isRunning = false;
    _cycleType = 'Work';
    _pomodoroCount = 0;

    // RF-2.4 & RF-2.6: Determina a duração do Foco
    _currentFocusMinutes = _defaultFocusMinutes;
    if (widget.activeTask != null && widget.activeTask!.hasPomodoro) {
      _currentFocusMinutes = widget.activeTask!.focusDurationMinutes;
    }

    _totalSecondsRemaining = _currentFocusMinutes * 60;

    // Força a reconstrução da UI
    if (mounted) {
      setState(() {});
    }
  }

  // Inicia ou pausa o timer (RF-2.2)
  void _toggleTimer() {
    if (_isRunning) {
      // Pausa
      _timer?.cancel();
    } else {
      // Inicia (RF-2.2: Gerenciando a execução do Timer do Dart com setState)
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_totalSecondsRemaining > 0) {
            _totalSecondsRemaining--;
          } else {
            // Tempo esgotado, avança para o próximo ciclo
            _moveToNextCycle();
          }
        });
      });
    }

    setState(() {
      _isRunning = !_isRunning;
    });
  }

  // Avança para o próximo ciclo (RF-2.7: Transição de Ciclos)
  void _moveToNextCycle() {
    _timer?.cancel(); // Para o timer

    setState(() {
      if (_cycleType == 'Work') {
        _pomodoroCount++;
        if (_pomodoroCount % 4 == 0) {
          // Pausa Longa a cada 4 focos
          _cycleType = 'Long Break';
          _totalSecondsRemaining = _longBreakMinutes * 60;
        } else {
          // Pausa Curta
          _cycleType = 'Short Break';
          _totalSecondsRemaining = _shortBreakMinutes * 60;
        }
      } else {
        // Volta ao Foco
        _cycleType = 'Work';
        _totalSecondsRemaining = _currentFocusMinutes * 60;
      }

      _isRunning = false; // Começa pausado após a transição
      // Para iniciar automaticamente: _toggleTimer();
    });
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    // Exibe o título da tarefa ativa ou um padrão.
    final String currentTaskTitle = widget.activeTask != null
        ? widget.activeTask!.title
        : 'Default Focus (25m)';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Pomodoro Timer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Exibe a tarefa e o tipo de ciclo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Color(0xFF181818),
              ),
              const SizedBox(width: 8),
              Text(
                'Current Task: $currentTaskTitle',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            'Cycle: $_cycleType',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),

          // Círculo do Timer (Representação Visual do Tempo)
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progresso do Círculo
                CircularProgressIndicator(
                  value:
                      1.0 -
                      (_totalSecondsRemaining / (_currentFocusMinutes * 60)),
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                // Tempo Exibido (RF-2.1)
                Text(
                  TimeFormatter.formatDuration(_totalSecondsRemaining),
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight:
                        FontWeight.w200, // Light weight for minimal look
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Controles (RF-2.2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão Play/Pause
              IconButton(
                icon: Icon(
                  _isRunning
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 80,
                  color: const Color(0xFF181818),
                ),
                onPressed: _toggleTimer,
              ),
              const SizedBox(width: 40),
              // Botão Reset
              IconButton(
                icon: const Icon(
                  Icons.replay_circle_filled,
                  size: 50,
                  color: Color(0xFF181818),
                ),
                onPressed: _initializeTimerState,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

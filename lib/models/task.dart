// lib/models/task.dart

class Task {
  String title;
  String description;
  bool isCompleted;
  bool hasPomodoro;
  int focusDurationMinutes; // Duração do ciclo de Foco (Padrão: 25 min)
  String category;
  String priority; // Nível de Prioridade (Ex: Alta, Média)
  DateTime createdAt; // Data de criação da tarefa

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.hasPomodoro = true, // Padrão de Pomodoro habilitado
    this.focusDurationMinutes = 25, // Padrão de 25 minutos
    this.category = 'Inbox',
    this.priority = 'Medium',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

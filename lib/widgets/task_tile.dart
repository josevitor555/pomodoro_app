// lib/widgets/task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final bool isActive; // Se a tarefa está marcada como ativa para o Pomodoro
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onSetActive; // Define a tarefa como ativa/focada
  final VoidCallback onEdit; // Nova função para acionar a edição

  const TaskTile({
    super.key,
    required this.task,
    required this.isActive,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onSetActive,
    required this.onEdit, // Adicione no construtor
  });

  @override
  Widget build(BuildContext context) {
    // Cor da prioridade
    Color priorityColor;
    switch (task.priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red.shade700;
        break;
      case 'medium':
        priorityColor = Colors.orange.shade700;
        break;
      case 'low':
        priorityColor = Colors.blue.shade700;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return GestureDetector(
      // Usamos GestureDetector para detectar toque duplo
      onDoubleTap: onEdit, // Toque duplo abre a edição
      onLongPress: onDelete,
      onTap: onSetActive, // Define como tarefa ativa ao tocar
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.grey.withOpacity(0.1)
              : Colors.white, // Visual de ativo
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // Checkbox de conclusão (RF-1.5)
            Checkbox(
              value: task.isCompleted,
              onChanged: (val) => onToggleComplete(),
              activeColor: task.isCompleted
                  ? Colors.grey
                  : Theme.of(context).colorScheme.secondary,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  // Detalhes (Priority & Description/Category)
                  Row(
                    children: [
                      // Prioridade (RF-1.4)
                      if (!task.isCompleted)
                        Container(
                          margin: const EdgeInsets.only(right: 8.0, top: 2.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.priority.toUpperCase(),
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      // Descrição/Categoria
                      Text(
                        task.description.isNotEmpty
                            ? task.description
                            : task.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: task.isCompleted
                              ? Colors.grey
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ícone de edição
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Color(0xFF181818)),
              onPressed: onEdit,
              splashRadius: 24.0,
            ),

            // Indicador de Pomodoro habilitado (RF-1.4)
            if (task.hasPomodoro && !task.isCompleted)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Icon(
                  Icons.timer,
                  size: 20,
                  color: Color(0xFF181818),
                ),
              ),

            // Indicador de Tarefa Ativa
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: const Icon(
                  Icons.circle,
                  size: 8,
                  color: Color(0xFF181818),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

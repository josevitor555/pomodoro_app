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

  // 3. MUDANÇA: Substitui o Checkbox por um controle circular
  Widget _buildCircularCheckbox(BuildContext context) {
    return InkWell(
      onTap: onToggleComplete,
      borderRadius: BorderRadius.circular(15), // Arredondamento do InkWell
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: task.isCompleted
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey.shade400,
            width: 2,
          ),
          color: task.isCompleted
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
        ),
        child: task.isCompleted
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: GestureDetector(
        onDoubleTap: onEdit,
        onLongPress: onDelete,
        onTap: onSetActive,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          // 2. MUDANÇA: Estilização arredondada e sombra (minimalista)
          decoration: BoxDecoration(
            color: Colors.white, // Fundo branco para se destacar do FAFAFA
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05), // Sombra leve
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: <Widget>[
              // 3. MUDANÇA: Usa o novo widget circular
              _buildCircularCheckbox(context),

              Expanded(
                child: Column(
                  // ... (resto da coluna de texto)
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
                        fontWeight: FontWeight.w500, // Levemente mais leve
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    // Detalhes (Priority & Description/Category)
                    // ... (resto do código de detalhes)
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

              // Novo ícone para edição, removido o toque duplo para UX.
              if (!task.isCompleted)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                    onPressed: onEdit,
                  ),
                ),

              // Indicador de Pomodoro habilitado (RF-1.4)
              if (task.hasPomodoro && !task.isCompleted)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.timer,
                      size: 20,
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),

              // Indicador de Tarefa Ativa (Removido para simplificar o visual)
              // if (isActive)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.secondary),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

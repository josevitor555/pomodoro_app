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
                : Theme.of(context).colorScheme.outline,
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

    // Formatação da data de criação
    final formattedDate =
        '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}';

    return Padding(
      // Aumentar o espaçamento vertical entre os itens
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onDoubleTap: onEdit,
        onLongPress: onDelete,
        onTap: onSetActive,
        child: Container(
          padding: const EdgeInsets.all(16.0), // Aumentar o padding interno
          // 2. MUDANÇA: Estilização com bordas arredondadas completas e sombra (minimalista)
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface, // Usar cor do tema
            borderRadius: BorderRadius.circular(
              20,
            ), // Bordas mais arredondadas (100% full)
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
                  : Theme.of(context).colorScheme.outline, // Usar cor do tema
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
                        color: task.isCompleted
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    // Detalhes (Priority & Description/Category & Date)
                    // ... (resto do código de detalhes)
                    // Detalhes (Priority & Description/Category & Date)
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
                                ? Theme.of(context).colorScheme.outline
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    // Data de criação
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Criado em: $formattedDate',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Novo ícone para edição, removido o toque duplo para UX.
              if (!task.isCompleted)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: onEdit,
                  ),
                ),

              // Indicador de Pomodoro habilitado (RF-1.4)
              if (task.hasPomodoro && !task.isCompleted)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.timer,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
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

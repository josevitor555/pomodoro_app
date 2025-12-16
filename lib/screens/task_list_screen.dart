// lib/screens/task_list_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/task_form_modal.dart';
import 'pomodoro_screen.dart'; // Para navegação/tab

// RF-2.5: Variável de estado para a tarefa atualmente ativa.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Estado principal do aplicativo, gerenciado por setState()
  final List<Task> _tasks = [
    // Dados de exemplo para iniciar
    Task(
      title: 'Design System Review',
      description: 'Create variables for dark mode',
      priority: 'High',
      createdAt: DateTime(2025, 12, 10), // Data de exemplo
    ),
    Task(
      title: 'Weekly Standup',
      description: 'Prepare slide deck',
      priority: 'Medium',
      hasPomodoro: false,
      createdAt: DateTime(2025, 12, 12), // Data de exemplo
    ),
    Task(
      title: 'Call Mom',
      category: 'Personal',
      isCompleted: true,
      hasPomodoro: false,
      createdAt: DateTime(2025, 12, 14), // Data de exemplo
    ),
    Task(
      title: 'Email Client Feedback',
      priority: 'Low',
      createdAt: DateTime(2025, 12, 15), // Data de exemplo
    ),
    Task(
      title: 'Grocery Shopping',
      description: 'Milk, Eggs, Bread',
      priority: 'Low',
      hasPomodoro: false,
      createdAt: DateTime(2025, 12, 16), // Data de exemplo
    ),
  ];

  Task? _activeTask; // Tarefa selecionada para o Foco/Pomodoro

  int _currentIndex = 0; // Índice para a BottomNavigationBar

  // --- Funções de Manipulação de Estado da Tarefa (RF-1.3, RF-1.5) ---

  void _addTask(Task newTask) {
    // RF-1.3: Adição ao Estado via setState()
    setState(() {
      _tasks.add(newTask);
      _tasks.sort((a, b) => a.isCompleted ? 1 : -1); // Simples ordenação
    });
  }

  void _toggleTaskCompletion(Task task) {
    // RF-1.5: Conclusão/Alternância de Estado via setState()
    setState(() {
      task.isCompleted = !task.isCompleted;
      _tasks.sort((a, b) => a.isCompleted ? 1 : -1);
    });
  }

  void _deleteTask(Task task) {
    // RF-1.5: Remoção do Estado via setState()
    setState(() {
      _tasks.remove(task);
      // Garante que a tarefa ativa seja desativada se for excluída
      if (_activeTask == task) {
        _activeTask = null;
      }
    });
  }

  void _setActiveTask(Task? task) {
    // RF-2.5: Define a tarefa ativa para o Pomodoro via setState()
    setState(() {
      // Alternar a seleção, se clicar na mesma tarefa, desativa.
      _activeTask = (_activeTask == task) ? null : task;
    });
  }

  // --- UI/Navegação ---

  void _openAddTaskModal() {
    // RF-1.1: Abertura do Formulário (Modal)
    showModalBottomSheet<Task?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TaskFormModal(); // Usa o Widget de Formulário
      },
    ).then((newTask) {
      if (newTask != null) {
        _addTask(newTask); // Adiciona se a tarefa for válida
      }
    });
  }

  // Função para abrir o modal e tratar a edição
  void _editTask(Task taskToEdit) {
    showModalBottomSheet<Task?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Passa a tarefa a ser editada para o modal
        return TaskFormModal(taskToEdit: taskToEdit);
      },
    ).then((updatedTask) {
      if (updatedTask != null) {
        // Como o Dart passa objetos por referência (e Task é uma classe),
        // a instância original da lista já foi modificada dentro do modal.
        // Contudo, chamamos setState() para garantir que a UI se atualize (RF-1.6).
        setState(() {
          // A tarefa na lista (_tasks) já está atualizada, mas forçamos a rebuild.
        });
      }
    });
  }

  // Conteúdo para a Tab de Lista de Tarefas
  Widget _buildTaskList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'My Tasks',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        Expanded(
          child: ListView.builder(
            // MUDANÇA: Use ListView.builder em vez de ListView.separated
            itemCount: _tasks.length,
            // MUDANÇA: Remover o separatorBuilder
            // separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return TaskTile(
                task: task,
                isActive: _activeTask == task,
                onToggleComplete: () => _toggleTaskCompletion(task),
                onDelete: () => _deleteTask(task),
                onSetActive: () => _setActiveTask(task),
                onEdit: () => _editTask(task), // Chamada para a nova função
              );
            },
          ),
        ),
      ],
    );
  }

  // Conteúdo para as abas (Simplificado, apenas 2 por agora)
  List<Widget> get _widgetOptions => <Widget>[
    Container(), // Placeholder para a lista, que será construída no build
    PomodoroScreen(activeTask: _activeTask), // Usa o Pomodoro Screen
    const Center(child: Text('Stats')),
    const Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Atualiza o PomodoroScreen com a tarefa ativa sempre que o estado muda.
    _widgetOptions[1] = PomodoroScreen(activeTask: _activeTask);

    return Scaffold(
      appBar: AppBar(
        // Título é manipulado no corpo (para um visual mais iOS-like)
        title: const Text(''),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.sort,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                // Adicionar funcionalidade de ordenação
              },
            ),
          ),
        ],
      ),
      // O corpo principal exibe a lista ou a tela Pomodoro
      body: _currentIndex == 0
          ? _buildTaskList()
          : _widgetOptions.elementAt(_currentIndex),

      // Botão de adição RF-1.1
      floatingActionButton: _currentIndex == 0
          ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _openAddTaskModal,
              ),
            )
          : null,

      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Permite mais de 3 itens
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bar_chart,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.outline,
        onTap: _onItemTapped,
      ),
    );
  }
}

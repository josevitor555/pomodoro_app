// lib/widgets/task_form_modal.dart

import 'package:flutter/material.dart';
import '../models/task.dart';

// RF-1.2: Campos de Entrada
class TaskFormModal extends StatefulWidget {
  // A tarefa é opcional. Se for nula, é uma nova tarefa. Se não, é uma edição.
  final Task? taskToEdit;

  const TaskFormModal({super.key, this.taskToEdit}); // Construtor atualizado

  @override
  State<TaskFormModal> createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  final _formKey = GlobalKey<FormState>();

  // Estado local do formulário (RF-1.2)
  String _title = '';
  String _description = '';
  String _priority = 'Medium';
  String _category = 'Inbox';
  bool _hasPomodoro = true;
  int _focusDurationMinutes = 25;

  // Opções para Dropdowns/Seleção
  final List<String> _priorities = ['High', 'Medium', 'Low'];
  final List<String> _categories = ['Inbox', 'Work', 'Personal', 'Study'];

  @override
  void initState() {
    super.initState();
    // Se estiver editando, inicializa o estado do formulário com os dados da tarefa.
    if (widget.taskToEdit != null) {
      _title = widget.taskToEdit!.title;
      _description = widget.taskToEdit!.description;
      _priority = widget.taskToEdit!.priority;
      _category = widget.taskToEdit!.category;
      _hasPomodoro = widget.taskToEdit!.hasPomodoro;
      _focusDurationMinutes = widget.taskToEdit!.focusDurationMinutes;
    }
  }

  // Submissão do formulário (RF-1.3)
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Se estiver editando, podemos retornar a tarefa original modificada.
      // Se for nova, retornamos uma nova instância (como antes).
      Task resultTask =
          widget.taskToEdit ??
          Task(title: _title); // Cria um placeholder ou usa a original

      // Atualiza os atributos da tarefa (seja nova ou a ser editada)
      resultTask.title = _title;
      resultTask.description = _description;
      resultTask.priority = _priority;
      resultTask.category = _category;
      resultTask.hasPomodoro = _hasPomodoro;
      resultTask.focusDurationMinutes = _hasPomodoro
          ? _focusDurationMinutes
          : 0;

      // Retorna a tarefa atualizada/criada.
      Navigator.of(context).pop(resultTask);
    }
  }

  // Campo de entrada de número para a duração
  Widget _buildFocusDurationField() {
    return TextFormField(
      initialValue: _focusDurationMinutes.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Focus Duration (minutes)',
        suffixText: 'min',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a duration.';
        }
        if (int.tryParse(value) == null || int.parse(value) < 1) {
          return 'Enter a valid number of minutes.';
        }
        return null;
      },
      onSaved: (value) {
        _focusDurationMinutes = int.parse(value!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Título do Modal
    final modalTitle = widget.taskToEdit != null ? 'Edit Task' : 'New Task';

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          // Garante que o teclado não cubra o formulário
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Cabeçalho do Modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    modalTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 16),

              // Campo Title
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  hintText: 'What needs to be done?',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),

              // Campo Description
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  hintText: 'Add notes...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                minLines: 1,
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, thickness: 1),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'DETAILS',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              // Priority e Category (Dropdowns/Seleção)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: _priorities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _priority = newValue!;
                        });
                      },
                      onSaved: (value) => _priority = value!,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue!;
                        });
                      },
                      onSaved: (value) => _category = value!,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, thickness: 1),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'POMODORO',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              // Habilitar Pomodoro (Switch/Checkbox)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Pomodoro', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _hasPomodoro,
                    onChanged: (bool value) {
                      setState(() {
                        _hasPomodoro = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),

              // Duração de Foco Condicional (RF-1.2 - Campo condicional)
              if (_hasPomodoro) ...[
                const SizedBox(height: 10),
                _buildFocusDurationField(),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

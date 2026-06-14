import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {

    tasks =
    await StorageService.loadTasks();

    setState(() {});
  }

  Future<void> saveTasks() async {
    await StorageService.saveTasks(tasks);
  }

  void addTask(String title) {

    setState(() {

      tasks.add(
        Task(title: title),
      );
    });

    saveTasks();
  }

  void deleteTask(int index) {

    setState(() {
      tasks.removeAt(index);
    });

    saveTasks();
  }

  void toggleTask(int index) {

    setState(() {

      tasks[index].isCompleted =
      !tasks[index].isCompleted;
    });

    saveTasks();
  }

  void showAddTaskDialog() {

    TextEditingController controller =
    TextEditingController();

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title:
          const Text("Add Task"),

          content: TextField(
            controller: controller,

            decoration:
            const InputDecoration(
              hintText:
              "Enter Task",
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                );
              },

              child:
              const Text("Cancel"),
            ),

            ElevatedButton(

              onPressed: () {

                if (controller
                    .text
                    .trim()
                    .isNotEmpty) {

                  addTask(
                    controller.text,
                  );

                  Navigator.pop(
                    context,
                  );
                }
              },

              child:
              const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Tasks Yet",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 80),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks[index],
                  onChanged: (_) {
                    toggleTask(index);
                  },
                  onDelete: () {
                    deleteTask(index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddTaskDialog,
        label:  Text("Add Task"),
        icon:  Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
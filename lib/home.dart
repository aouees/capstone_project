import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles.dart';

class Task {
  String title;
  bool done;
  Task(this.title, this.done);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  String _username = '';
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? storedTasks = _prefs!.getStringList('tasks');
    final String? storedUsername = _prefs!.getString('username');
    setState(() {
      _username = storedUsername ?? '';
      _tasks = storedTasks?.map((e) {
            final parts = e.split('|');
            return Task(parts[0], parts.length > 1 && parts[1] == '1');
          }).toList() ?? [];
    });
  }

  Future<void> _saveTasks() async {
    final List<String> store =
        _tasks.map((t) => '${t.title}|${t.done ? '1' : '0'}').toList();
    await _prefs?.setStringList('tasks', store);
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _tasks.add(Task(text, false));
                });
                _saveTasks();
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index].done = !_tasks[index].done;
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> toDo = _tasks.where((t) => !t.done).toList();
    final List<Task> done = _tasks.where((t) => t.done).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: AppStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, $_username!', style: AppStyles.headerTextStyle),
            const SizedBox(height: 8),
            const Text('Use the + button to create some habits!'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Text('To Do', style: AppStyles.headerTextStyle),
                  ...toDo.map((task) => Card(
                        child: ListTile(
                          title: Text(task.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            onPressed: () => _toggleDone(_tasks.indexOf(task)),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  Text('Done', style: AppStyles.headerTextStyle),
                  ...done.map((task) => Card(
                        child: ListTile(
                          title: Text(task.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_box),
                            onPressed: () => _toggleDone(_tasks.indexOf(task)),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


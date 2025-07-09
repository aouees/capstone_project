import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles.dart';
import 'detail.dart';
import 'helpers/task_storage.dart';
import 'models/task.dart';
import 'navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  String _username = '';
  String _email = '';
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    final List<Task> storedTasks = await TaskStorage.getTasks();
    final String? storedUsername = _prefs!.getString('username');
    final String? storedEmail = _prefs!.getString('email');
    setState(() {
      _username = storedUsername ?? '';
      _email = storedEmail ?? '';
      _tasks = storedTasks;
    });
  }

  Future<void> _saveTasks() async {
    await TaskStorage.saveTasks(_tasks);
  }

  void _showAddDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(hintText: 'Enter habit name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(hintText: 'Enter description'),
            ),
          ],
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
              final String text = titleController.text.trim();
              final String desc = descriptionController.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _tasks.add(Task(text, desc, false));
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> toDo = _tasks.where((t) => !t.done).toList();
    final List<Task> done = _tasks.where((t) => t.done).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.countries);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_username),
              accountEmail: Text(_email),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Information'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.editUserInfo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account settings not implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications not implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Habit Tracker App')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(task: task),
                            ),
                          ),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(task: task),
                            ),
                          ),
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


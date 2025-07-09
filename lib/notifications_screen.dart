import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/task_storage.dart';
import 'models/task.dart';
import 'styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedTasks = [];
  List<String> selectedTimes = [];
  List<String> allTasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Task> tasks = await TaskStorage.getTasks();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      selectedTasks = prefs.getStringList('notificationTasks') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
      allTasks = tasks.map((t) => t.title).toList();
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationTasks', selectedTasks);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  void _sendTestNotification() {
    if (html.Notification.permission != 'granted') {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification('Task Reminder',
              body: "It's time to work on your tasks!");
        }
      });
    } else {
      html.Notification('Task Reminder',
          body: "It's time to work on your tasks!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: AppStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveNotificationSettings();
              },
            ),
            const Divider(),
            const Text(
              'Select Tasks for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: allTasks.map((task) {
                return FilterChip(
                  label: Text(task),
                  selected: selectedTasks.contains(task),
                  selectedColor: AppStyles.primaryColor.withOpacity(0.3),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTasks.add(task);
                      } else {
                        selectedTasks.remove(task);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Times for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                return FilterChip(
                  label: Text(time),
                  selected: selectedTimes.contains(time),
                  selectedColor: AppStyles.primaryColor.withOpacity(0.3),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimes.add(time);
                      } else {
                        selectedTimes.remove(time);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _sendTestNotification,
              style: AppStyles.buttonStyle,
              child: const Text('Send Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}

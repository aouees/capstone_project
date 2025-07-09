import 'package:flutter/material.dart';

import 'models/task.dart';
import 'styles.dart';

class DetailScreen extends StatelessWidget {
  final Task task;
  const DetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: AppStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: AppStyles.headerTextStyle),
            const SizedBox(height: 8),
            Text(task.description),
          ],
        ),
      ),
    );
  }
}

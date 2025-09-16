import 'package:flutter/material.dart';

import '../../../core/domain/entities.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key, required this.clientCase});

  static const routePath = '/track';

  final ClientCase clientCase;

  @override
  Widget build(BuildContext context) {
    final updates = clientCase.updates;
    return Scaffold(
      appBar: AppBar(title: const Text('Case Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned Lawyer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(clientCase.assignedLawyerId ?? 'Not assigned'),
            const SizedBox(height: 16),
            Text('Progress', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: updates.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final u = updates[index];
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(u.message),
                    subtitle: Text(u.time.toLocal().toString()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Document'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Message Lawyer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

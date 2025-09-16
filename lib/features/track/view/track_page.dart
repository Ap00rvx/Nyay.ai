import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities.dart';
import '../../../core/domain/case_category.dart';
import '../../../core/data/mock_case_repository.dart';
import '../cubit/track_cubit.dart';

class TrackPage extends StatelessWidget {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackCubit(MockCaseRepository())..load(),
      child: const _TrackView(),
    );
  }
}

class _TrackView extends StatelessWidget {
  const _TrackView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCubit, TrackState>(
      builder: (context, state) {
        return switch (state.status) {
          TrackStatus.loading || TrackStatus.initial => const Center(
            child: CircularProgressIndicator(),
          ),
          TrackStatus.failure => Center(
            child: Text(state.error ?? 'Failed to load cases'),
          ),
          TrackStatus.success => _CaseList(cases: state.cases),
        };
      },
    );
  }
}

class _CaseList extends StatelessWidget {
  const _CaseList({required this.cases});
  final List<ClientCase> cases;

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return _EmptyState(
        onStart: () {
          // Could navigate to New Case tab by updating parent IndexedStack via a callback.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No cases yet. Create a new case.')),
          );
        },
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cases.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final c = cases[index];
        final latest = c.updates.isNotEmpty ? c.updates.last : null;
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // In a full app, navigate to case detail; for now show a bottom sheet.
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (ctx) => _CaseDetailSheet(clientCase: c),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(child: Text(c.id.substring(2))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _Chip(
                              label: c.predictedCategory?.label ?? 'General',
                            ),
                            _Chip(label: c.location),
                            _Chip(label: '₹${c.budget}'),
                            _Chip(
                              label: 'Lawyer: ${c.assignedLawyerId ?? 'TBD'}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (latest != null)
                          Row(
                            children: [
                              const Icon(Icons.update, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  latest.message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CaseDetailSheet extends StatelessWidget {
  const _CaseDetailSheet({required this.clientCase});
  final ClientCase clientCase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Case ${clientCase.id}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(clientCase.description),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _Chip(label: clientCase.predictedCategory?.label ?? 'General'),
              _Chip(label: clientCase.location),
              _Chip(label: '₹${clientCase.budget}'),
              _Chip(label: 'Lawyer: ${clientCase.assignedLawyerId ?? 'TBD'}'),
            ],
          ),
          const SizedBox(height: 12),
          Text('Updates', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          for (final u in clientCase.updates)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(u.message),
              subtitle: Text(u.time.toLocal().toString()),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Document'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined),
                label: const Text('Message Lawyer'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text('No active cases', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Start a new case to begin tracking progress.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Start New Case'),
          ),
        ],
      ),
    );
  }
}

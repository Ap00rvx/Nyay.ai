import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/entities.dart';
import '../../../core/data/mock_lawyer_repository.dart';
import '../../tracking/view/tracking_page.dart';
import '../cubit/matching_cubit.dart';

class MatchingPage extends StatelessWidget {
  const MatchingPage({super.key, required this.clientCase});

  final ClientCase clientCase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchingCubit(MockLawyerRepository())..rank(clientCase),
      child: BlocBuilder<MatchingCubit, MatchingState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Recommended Lawyers')),
            body: switch (state.status) {
              MatchingStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              MatchingStatus.success => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (ctx, i) {
                  final (lawyer, score) = state.results[i];
                  return _LawyerCard(
                    lawyer: lawyer,
                    score: score,
                    onSelect: () {
                      final selected = clientCase.copyWith(
                        assignedLawyerId: lawyer.id,
                        updates: [
                          ...clientCase.updates,
                          CaseUpdate(
                            DateTime.now(),
                            'Lawyer ${lawyer.name} assigned to the case.',
                          ),
                        ],
                      );
                      context.push(TrackingPage.routePath, extra: selected);
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: state.results.length,
              ),
              _ => const Center(child: Text('No results')),
            },
          );
        },
      ),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  const _LawyerCard({
    required this.lawyer,
    required this.score,
    required this.onSelect,
  });
  final Lawyer lawyer;
  final double score;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    lawyer.name.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lawyer.name, style: theme.textTheme.titleMedium),
                      Text(
                        '${lawyer.years} yrs • ${lawyer.location} • ⭐ ${lawyer.rating.toStringAsFixed(1)}',
                      ),
                    ],
                  ),
                ),
                Text(
                  'Score ${(score).toStringAsFixed(1)}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: lawyer.expertise
                  .map((e) => Chip(label: Text(e.name.toUpperCase())))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(lawyer.about, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Fee: ₹${lawyer.fee.toStringAsFixed(0)}'),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onSelect,
                  icon: const Icon(Icons.check),
                  label: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

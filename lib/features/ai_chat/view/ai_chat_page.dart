import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../cubit/ai_chat_cubit.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return BlocProvider(
      create: (_) => AiChatCubit(),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<AiChatCubit, AiChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return _EmptyHelp(controller: controller);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final m = state.messages[index];
                      final isUser = m.role == ChatRole.user;
                      final align = isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start;
                      final bubbleColor = isUser
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant;
                      final textColor = isUser
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface;
                      return Column(
                        crossAxisAlignment: align,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              m.text,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Insert file',
                      onPressed: () => _pickFile(context),
                      icon: const Icon(Icons.attach_file),
                    ),
                    IconButton(
                      tooltip: 'Voice input',
                      onPressed: () => _openMicSheet(context, controller),
                      icon: const Icon(Icons.mic_none),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Ask anything…',
                        ),
                        onSubmitted: (_) => _send(context, controller),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _send(context, controller),
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(BuildContext context, TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return;
    context.read<AiChatCubit>().sendMessage(text);
    c.clear();
  }

  Future<void> _pickFile(BuildContext context) async {
    final res = await FilePicker.platform.pickFiles(withData: false);
    if (res != null && res.files.isNotEmpty) {
      final name = res.files.first.name;
      context.read<AiChatCubit>().sendMessage(
        'Attached file: "$name". Please summarize and classify this case.',
      );
    }
  }

  void _openMicSheet(BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        bool listening = true;
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    listening ? Icons.mic : Icons.mic_off,
                    size: 48,
                    color: Theme.of(ctx).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(listening ? 'Listening…' : 'Stopped'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() => listening = !listening),
                        icon: Icon(listening ? Icons.pause : Icons.play_arrow),
                        label: Text(listening ? 'Pause' : 'Resume'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          // Mock transcribed text
                        },
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyHelp extends StatelessWidget {
  const _EmptyHelp({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = <({IconData icon, String title, String prompt})>[
      (
        icon: Icons.description_outlined,
        title: 'Summarize a document',
        prompt: 'Summarize this legal document and extract key points.',
      ),
      (
        icon: Icons.category_outlined,
        title: 'Classify my case',
        prompt: 'Classify this case into criminal, civil, family, or property.',
      ),
      (
        icon: Icons.trending_up_outlined,
        title: 'Estimate budget',
        prompt: 'Estimate a reasonable budget for filing and initial hearings.',
      ),
      (
        icon: Icons.location_on_outlined,
        title: 'Find local lawyers',
        prompt: 'Find top-rated property lawyers in Delhi within ₹2000 fee.',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('What I can do', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final s in suggestions)
                _SuggestionCard(
                  icon: s.icon,
                  title: s.title,
                  onTap: () {
                    controller.text = s.prompt;
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.icon, required this.title, this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        width: 190,
        height: 90,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(title, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../cubit/case_cubit.dart';

class CaseIntakePage extends StatefulWidget {
  const CaseIntakePage({super.key});

  @override
  State<CaseIntakePage> createState() => _CaseIntakePageState();
}

class _CaseIntakePageState extends State<CaseIntakePage> {
  final _descController = TextEditingController();
  bool _useUpload = true; // toggle between upload and manual
  bool _processing = false;
  String? _suggested;
  PlatformFile? _file;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaseCubit(),
      child: BlocBuilder<CaseCubit, CaseState>(
        builder: (context, state) {
          final cubit = context.read<CaseCubit>();
          return Scaffold(
            
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Toggle
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Upload Document'),
                        icon: Icon(Icons.upload_file),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Describe Manually'),
                        icon: Icon(Icons.edit_note),
                      ),
                    ],
                    selected: {_useUpload},
                    onSelectionChanged: (s) =>
                        setState(() => _useUpload = s.first),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _useUpload
                        ? _buildUpload(context, cubit, state)
                        : _buildManual(context, cubit, state),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              cubit.updateBudget(double.tryParse(v) ?? 0),
                          decoration: const InputDecoration(
                            labelText: 'Budget (INR)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: cubit.updateLocation,
                          decoration: const InputDecoration(
                            labelText: 'City/Location',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: state.description.isEmpty
                              ? null
                              : () {
                                  cubit.classify();
                                  context.push(
                                    AppRouter.homeRoute,
                                    extra: cubit.toEntity(),
                                  );
                                },
                          icon: const Icon(Icons.search),
                          label: const Text('Find Lawyers'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildManual(BuildContext context, CaseCubit cubit, CaseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Case Description', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          minLines: 6,
          maxLines: 10,
          onChanged: cubit.updateDescription,
          decoration: const InputDecoration(
            hintText:
                'Briefly describe your case... (no personal data required)',
          ),
        ),
      ],
    );
  }

  Widget _buildUpload(BuildContext context, CaseCubit cubit, CaseState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Upload a document (PDF, DOC, Image)',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _processing
                    ? null
                    : () async {
                        final res = await FilePicker.platform.pickFiles(
                          type: FileType.any,
                          withData: true,
                        );
                        if (res != null && res.files.isNotEmpty) {
                          setState(() {
                            _file = res.files.first;
                            _processing = true;
                            _suggested = null;
                          });
                          // Mock OCR/extraction delay and suggestion
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            _processing = false;
                            _suggested =
                                'Auto-detected summary from "${_file!.name}":\n'
                                'Dispute regarding ${_file!.extension ?? 'document'} suggesting a possible civil/property matter. '
                                'The client seeks resolution and potential representation.';
                            _descController.text = _suggested!;
                          });
                          cubit.updateDescription(_descController.text);
                        }
                      },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _file != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _processing
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _file == null
                                    ? 'Tap to upload file'
                                    : 'File selected',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (_file != null)
              Expanded(
                child: Text(
                  _file!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _processing
              ? _ProcessingCard()
              : _SuggestionCard(
                  text: _suggested ?? 'No text detected yet.',
                  onUseAndFind: _suggested == null
                      ? null
                      : () {
                          // directly use and go to matching
                          final cubit = context.read<CaseCubit>();
                          cubit.updateDescription(_suggested!);
                          cubit.classify();
                          context.push(
                            AppRouter.homeRoute,
                            extra: cubit.toEntity(),
                          );
                        },
                  onUseAndEdit: _suggested == null
                      ? null
                      : () {
                          setState(() => _useUpload = false);
                        },
                ),
          crossFadeState: (_processing || _suggested != null)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class _ProcessingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(child: Text('Analyzing document with AI…')),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.text,
    this.onUseAndFind,
    this.onUseAndEdit,
  });
  final String text;
  final VoidCallback? onUseAndFind;
  final VoidCallback? onUseAndEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(text),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.icon(
                onPressed: onUseAndFind,
                icon: const Icon(Icons.check),
                label: const Text('Use & Find'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onUseAndEdit,
                icon: const Icon(Icons.edit),
                label: const Text('Use & Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

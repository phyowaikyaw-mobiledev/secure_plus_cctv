import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../bloc/ticket_cubit.dart';

class MaintenanceTicketFormScreen extends StatefulWidget {
  const MaintenanceTicketFormScreen({super.key});

  @override
  State<MaintenanceTicketFormScreen> createState() =>
      _MaintenanceTicketFormScreenState();
}

class _MaintenanceTicketFormScreenState
    extends State<MaintenanceTicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issueTypeCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String _urgency = 'normal';
  XFile? _attachment;

  @override
  void dispose() {
    _issueTypeCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _attachment = image);
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final cubit = context.read<TicketCubit>();
    await cubit.submit(
      issueType: _issueTypeCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      urgency: _urgency,
      attachment: _attachment,
    );
    final state = cubit.state;
    if (state.status == TicketStatus.success && mounted) {
      final summary = _buildShareSummary();
      await _showSuccessDialog(context, summary);
    }
  }

  String _buildShareSummary() {
    return '''
Secure Plus – New Maintenance Ticket

Issue: ${_issueTypeCtrl.text}
Urgency: $_urgency
Description:
${_descriptionCtrl.text}
''';
  }

  Future<void> _showSuccessDialog(
    BuildContext context,
    String summary,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ticket Created'),
          content: const Text(
            'Your maintenance ticket has been submitted. Secure Plus will follow up soon.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Share.share(summary);
              },
              child: const Text('Share Ticket'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TicketCubit(),
      child: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state.status == TicketStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return SecureScaffold(
            appBar: AppBar(
              title: const Text('Maintenance Ticket'),
              actions: const [LanguageButton()],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _issueTypeCtrl,
                      label: 'Issue type (No video, no power, etc.)',
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Required'
                              : null,
                    ),
                    _buildTextField(
                      controller: _descriptionCtrl,
                      label: 'Description',
                      maxLines: 4,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Required'
                              : null,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Urgency:'),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _urgency,
                          items: const [
                            DropdownMenuItem(
                              value: 'low',
                              child: Text('Low'),
                            ),
                            DropdownMenuItem(
                              value: 'normal',
                              child: Text('Normal'),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Text('Urgent'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _urgency = value);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _attachment == null
                                ? 'No photo attached'
                                : 'Photo attached',
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo),
                          label: const Text('Attach Photo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Submit Ticket',
                      icon: Icons.send,
                      isBusy: state.status == TicketStatus.submitting,
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}


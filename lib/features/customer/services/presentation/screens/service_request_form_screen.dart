import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../bloc/service_request_cubit.dart';

class ServiceRequestFormScreen extends StatefulWidget {
  const ServiceRequestFormScreen({super.key});

  @override
  State<ServiceRequestFormScreen> createState() =>
      _ServiceRequestFormScreenState();
}

class _ServiceRequestFormScreenState
    extends State<ServiceRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _townshipCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _premiseTypeCtrl = TextEditingController();
  final _cameraCountCtrl = TextEditingController();
  final _indoorOutdoorCtrl = TextEditingController();
  final _preferredDateTimeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  XFile? _attachment;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _townshipCtrl.dispose();
    _addressCtrl.dispose();
    _locationCtrl.dispose();
    _premiseTypeCtrl.dispose();
    _cameraCountCtrl.dispose();
    _indoorOutdoorCtrl.dispose();
    _preferredDateTimeCtrl.dispose();
    _notesCtrl.dispose();
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
    final cubit = context.read<ServiceRequestCubit>();
    await cubit.submit(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      township: _townshipCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      locationLink: _locationCtrl.text.trim(),
      premiseType: _premiseTypeCtrl.text.trim(),
      cameraCount: int.tryParse(_cameraCountCtrl.text.trim()) ?? 0,
      indoorOutdoor: _indoorOutdoorCtrl.text.trim(),
      remoteView: true,
      audioRequired: true,
      preferredDateTime: _preferredDateTimeCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      attachment: _attachment,
    );

    final state = cubit.state;
    if (state.status == ServiceRequestStatus.success && mounted) {
      final summary = _buildShareSummary();
      await _showSuccessDialog(context, summary);
    }
  }

  String _buildShareSummary() {
    return '''
Secure Plus – New Service Request

Name: ${_nameCtrl.text}
Phone: ${_phoneCtrl.text}
Township: ${_townshipCtrl.text}
Address: ${_addressCtrl.text}
Location: ${_locationCtrl.text}
Premise type: ${_premiseTypeCtrl.text}
Camera count: ${_cameraCountCtrl.text}
Indoor/Outdoor: ${_indoorOutdoorCtrl.text}
Preferred date/time: ${_preferredDateTimeCtrl.text}
Notes: ${_notesCtrl.text}
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
          title: const Text('Request Submitted'),
          content: const Text(
            'Thank you. Secure Plus will contact you shortly to confirm your installation.',
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
              child: const Text('Share Request'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceRequestCubit(),
      child: BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state.status == ServiceRequestStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return SecureScaffold(
            appBar: AppBar(
              title: const Text('Request CCTV Installation'),
              actions: const [LanguageButton()],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameCtrl,
                      label: 'Name',
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Required'
                              : null,
                    ),
                    _buildTextField(
                      controller: _phoneCtrl,
                      label: 'Phone',
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Required'
                              : null,
                    ),
                    _buildTextField(
                      controller: _townshipCtrl,
                      label: 'Township',
                    ),
                    _buildTextField(
                      controller: _addressCtrl,
                      label: 'Address',
                      maxLines: 2,
                    ),
                    _buildTextField(
                      controller: _locationCtrl,
                      label: 'Location link (Google Maps)',
                    ),
                    _buildTextField(
                      controller: _premiseTypeCtrl,
                      label: 'Premise type (Home, Shop, Factory...)',
                    ),
                    _buildTextField(
                      controller: _cameraCountCtrl,
                      label: 'Estimated camera count',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _indoorOutdoorCtrl,
                      label: 'Indoor / Outdoor layout',
                    ),
                    _buildTextField(
                      controller: _preferredDateTimeCtrl,
                      label: 'Preferred installation date & time',
                    ),
                    _buildTextField(
                      controller: _notesCtrl,
                      label: 'Additional notes',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
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
                      label: 'Submit Request',
                      icon: Icons.send,
                      isBusy:
                          state.status == ServiceRequestStatus.submitting,
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
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}


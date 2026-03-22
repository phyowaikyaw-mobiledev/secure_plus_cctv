import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../projects/data/models/project_model.dart';
import '../../../../projects/data/repositories/project_repository.dart';

class ProjectEditScreen extends StatefulWidget {
  const ProjectEditScreen({super.key, this.projectId});

  final String? projectId;

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _mapLinkCtrl = TextEditingController();

  final ProjectRepository _repository = ProjectRepository();
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _newImages = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _locationCtrl.dispose();
    _mapLinkCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (images.isEmpty) return;

      setState(() {
        final existing = _newImages.map((e) => e.path).toSet();
        for (final img in images) {
          if (!existing.contains(img.path)) {
            _newImages.add(img);
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picker failed: $e')),
      );
    }
  }

  void _removeImageAt(int index) {
    setState(() => _newImages.removeAt(index));
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();

      if (widget.projectId == null) {
        final project = Project(
          id: '', // repo creates doc id
          title: _titleCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          mapLink: _mapLinkCtrl.text.trim(),
          createdAt: now,
          imageUrls: const [],
        );

        await _repository.addProject(
          project: project,
          images: _newImages, // List<XFile>
        );
      } else {
        final project = Project(
          id: widget.projectId!,
          title: _titleCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          mapLink: _mapLinkCtrl.text.trim(),
          createdAt: now,
          imageUrls: const [],
        );

        await _repository.updateProject(
          project: project,
          newImages: _newImages, // List<XFile>
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save project: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.projectId != null;

    return SecureScaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'Add Project'),
        actions: const [LanguageButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                controller: _titleCtrl,
                label: 'Title',
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              _buildField(
                controller: _descriptionCtrl,
                label: 'Description',
                maxLines: 3,
              ),
              _buildField(
                controller: _locationCtrl,
                label: 'Location',
              ),
              _buildField(
                controller: _mapLinkCtrl,
                label: 'Google Maps link',
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      _newImages.isEmpty
                          ? 'No images selected'
                          : '${_newImages.length} image(s) selected',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _isSaving ? null : _pickImages,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Pick Images'),
                  ),
                ],
              ),

              if (_newImages.isNotEmpty) ...[
                const SizedBox(height: 10),
                _ImagesPreviewGrid(
                  images: _newImages,
                  onRemove: _removeImageAt,
                ),
              ],

              const SizedBox(height: 24),

              PrimaryButton(
                label: isEditing ? 'Save Changes' : 'Create Project',
                icon: Icons.save_outlined,
                isBusy: _isSaving,
                onPressed: _save,
              ),

              const SizedBox(height: 8),
              Text(
                'Note: Images should upload via Cloudinary and only URLs are saved in Firestore.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
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
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _ImagesPreviewGrid extends StatelessWidget {
  const _ImagesPreviewGrid({
    required this.images,
    required this.onRemove,
  });

  final List<XFile> images;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final x = images[index];
        final file = File(x.path);

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ Local preview
              Image.file(
                file,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Colors.white10,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.white70),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () => onRemove(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

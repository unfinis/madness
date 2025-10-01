import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Dialog for picking and inserting images
class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String? _imageName;
  final TextEditingController _altTextController = TextEditingController();

  @override
  void dispose() {
    _altTextController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageData = bytes;
        _imageName = image.name;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageData = bytes;
        _imageName = image.name;
      });
    }
  }

  void _handleInsert() {
    if (_imageData == null) return;

    final imageId = const Uuid().v4();

    // Create a data URL for the image
    final base64Image = base64Encode(_imageData!);
    final mimeType = _imageName?.endsWith('.png') == true
        ? 'image/png'
        : 'image/jpeg';
    final imageUrl = 'data:$mimeType;base64,$base64Image';

    Navigator.of(context).pop({
      'id': imageId,
      'url': imageUrl,
      'alt': _altTextController.text,
      'data': _imageData,
      'filename': _imageName,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Insert Image'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_imageData != null) ...[
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Image.memory(_imageData!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _altTextController,
                decoration: const InputDecoration(
                  labelText: 'Alt Text (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Describe the image',
                ),
              ),
            ] else ...[
              Card(
                child: InkWell(
                  onTap: _pickImageFromGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose from Gallery',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: InkWell(
                  onTap: _pickImageFromCamera,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take Photo',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (_imageData != null)
          FilledButton(
            onPressed: _handleInsert,
            child: const Text('Insert'),
          ),
      ],
    );
  }
}

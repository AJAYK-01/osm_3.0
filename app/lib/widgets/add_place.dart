import 'dart:io';

import 'package:app/models/models.dart';
import 'package:app/services/ipfs_service.dart';
import 'package:app/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPlace extends StatefulWidget {
  final double latitude, longitude;
  const AddPlace({super.key, required this.latitude, required this.longitude});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<FileImage> _images = [];
  // final List<String> _imagePaths = [];

  void _addImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        // Use Image.network for web compatibility
        // _imagePaths.add(image.path);
        _images.add(FileImage(File(image.path)));
      });
    }
  }

  Future<void> _submitPlace() async {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latitude: ${widget.latitude}, Longitude: ${widget.longitude}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _images.length) {
                    return IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addImage,
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Image.network(_imagePaths[index]),
                        child: Image(image: _images[index]));
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _submitPlace();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

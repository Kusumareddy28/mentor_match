import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

class PictureScreen extends StatefulWidget {
  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;

  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) return;
    setState(() {
      _isUploading = true;
    });
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() async {
      String downloadURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection('pictures').add({
        'url': downloadURL,
        'caption': _captionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isUploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) Image.file(_image!),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  hintText: 'Enter a caption...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (_isUploading) CircularProgressIndicator(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (_isUploading || _image == null) ? null : uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

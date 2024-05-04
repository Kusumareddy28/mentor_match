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
    // Use ImageSource.camera to use the camera
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: 'Enter a caption...'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!_isUploading) {
                  pickImage();
                }
              },
              child: Text('Take Picture'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!_isUploading && _image != null) {
                  uploadImage();
                }
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

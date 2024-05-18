// Kusuma Reddyvari - kreddyvari
// Zeba Samiya - zsamiya
// picture_screen.dart

// This Flutter file defines a PictureScreen widget that allows users to select an image from their gallery, upload it to Firebase Storage, and record the image details in Firestore with a caption. 
//The UI includes buttons for picking and uploading images, an image display area, a text field for captions, and a progress indicator for uploads. 
//Error handling is implemented to manage scenarios where no image is selected or uploading is in progress.

import 'dart:io'; 
import 'package:flutter/material.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:path/path.dart' as Path; 

// StatefulWidget for handling dynamic content, specifically image and upload management.
class PictureScreen extends StatefulWidget {
  @override
  _PictureScreenState createState() => _PictureScreenState();
}

// State class for PictureScreen containing the logic and UI elements.
class _PictureScreenState extends State<PictureScreen> {
  File? _image; // Variable to hold the selected image file.
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance for picking images.
  final TextEditingController _captionController = TextEditingController(); // Controller for caption input.
  bool _isUploading = false; // State variable to track the uploading status.

  // Asynchronous method to pick an image from the user's gallery.
  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Picking the image.

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Set the image if selected.
      } else {
        print('No image selected.'); // Console log if no image is selected.
      }
    });
  }

  // Asynchronous method to upload the selected image to Firebase Storage and store its details in Firestore.
  Future uploadImage() async {
    if (_image == null) return; // Exit if no image is selected.
    setState(() {
      _isUploading = true; // Start the upload process.
    });
    String fileName = Path.basename(_image!.path); // Extracting file name from path.
    Reference storageReference =
        FirebaseStorage.instance.ref().child('uploads/$fileName'); // Create a reference in Firebase Storage.
    UploadTask uploadTask = storageReference.putFile(_image!); // Create the upload task.
    await uploadTask.whenComplete(() async {
      String downloadURL = await storageReference.getDownloadURL(); // Retrieve the download URL after upload.
      await FirebaseFirestore.instance.collection('pictures').add({
        'url': downloadURL, // URL of the uploaded image.
        'caption': _captionController.text, // Caption entered by the user.
        'timestamp': FieldValue.serverTimestamp(), // Server timestamp for when the image is uploaded.
      });
      setState(() {
        _isUploading = false; // End the upload process.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'), // AppBar title.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the body.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically.
          children: <Widget>[
            if (_image != null) Image.file(_image!), // Display the selected image.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _captionController, // Text field for entering a caption.
                decoration: InputDecoration(
                  hintText: 'Enter a caption...', // Hint text for the text field.
                  border: OutlineInputBorder(), // Border for the text field.
                ),
              ),
            ),
            if (_isUploading) CircularProgressIndicator(), // Show loading indicator during upload.
            SizedBox(height: 20), // Vertical spacing.
            ElevatedButton(
              onPressed: _isUploading ? null : pickImage, // Button to pick image, disabled during upload.
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10), // Vertical spacing.
            ElevatedButton(
              onPressed: (_isUploading || _image == null) ? null : uploadImage, // Button to upload image, disabled during upload or if no image is selected.
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

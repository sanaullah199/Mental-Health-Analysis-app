// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class FilePickerService {
//   final ImagePicker _picker = ImagePicker();

//   /// Pick image from gallery with built-in compression
//   Future<File?> pickImageFromGallery({int quality = 70}) async {
//     final pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: quality, // compression (0–100)
//     );
//     return pickedFile != null ? File(pickedFile.path) : null;
//   }

//   /// Pick image from camera with built-in compression
//   Future<File?> pickImageFromCamera({int quality = 70}) async {
//     final pickedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: quality, // compression (0–100)
//     );
//     return pickedFile != null ? File(pickedFile.path) : null;
//   }
// }

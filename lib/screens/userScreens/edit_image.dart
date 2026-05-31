// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:himrishtey/screens/userScreens/upload_profile_photo.dart';
// import 'package:himrishtey/utils/common.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageEditorPage extends StatefulWidget {
//   const ImageEditorPage({super.key});

//   @override
//   State<ImageEditorPage> createState() => _ImageEditorPageState();
// }

// class _ImageEditorPageState extends State<ImageEditorPage> {
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//   String? _base64Image;

//   /// Function to pick an image
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery, maxHeight: 500, imageQuality: 95);
//     if (pickedFile != null) {
//       final File imageFile = File(pickedFile.path);
//       await _cropImage(imageFile);
//     }
//   }

//   /// Function to crop the selected image
//   Future<void> _cropImage(File imageFile) async {
//     final CroppedFile? croppedImage = await ImageCropper().cropImage(
//       sourcePath: imageFile.path,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: primaryColor,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(
//           title: 'Crop Image',
//         ),
//       ],
//     );

//     if (croppedImage != null) {
//       setState(() {
//         _selectedImage = File(croppedImage.path);
//         _base64Image = base64Encode(_selectedImage!.readAsBytesSync());
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   UploadProfilePhoto(XFile(croppedImage.path), true)),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Editor')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (_selectedImage != null)
//               Image.file(
//                 _selectedImage!,
//                 height: 200,
//                 width: 200,
//                 fit: BoxFit.cover,
//               )
//             else
//               const Placeholder(
//                 fallbackHeight: 200,
//                 fallbackWidth: 200,
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Select and Edit Image'),
//             ),
//             if (_base64Image != null) ...[
//               const SizedBox(height: 20),
//               const Text('Base64 Output:',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _base64Image!,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

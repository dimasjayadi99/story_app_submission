import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  Future<File?> pickImageFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    try {
      if (image == null) {
        return null;
      }
      final tempImage = File(image.path);

      return tempImage;
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<File?> imagePickerFromCamera(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    try {
      if (image == null) {
        return null;
      }
      final tempImage = File(image.path);
      return tempImage;
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }
}

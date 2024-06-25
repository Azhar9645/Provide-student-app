import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStudentProvider extends ChangeNotifier {
  String? profileimg;
  XFile? image;

  void setImage(XFile? img) {
    image = img;
    profileimg = img?.path;
    notifyListeners();
  }

  void clearImage() {
    image = null;
    profileimg = null;
    notifyListeners();
  }
}

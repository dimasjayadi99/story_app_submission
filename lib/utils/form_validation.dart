import 'package:submission_story_app/common/app_const.dart';

class FormValidation {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConst.emailBlank;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppConst.emailInValid;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConst.passwordBlank;
    } else if (value.length < 8) {
      return AppConst.passwordInValid;
    }
    return null;
  }
}

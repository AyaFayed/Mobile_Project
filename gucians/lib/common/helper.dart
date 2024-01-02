import 'package:gucians/common/constants.dart';

bool isStaff(String email) {
  try {
    String emailSecondHalf = email.split('@')[1];
    return emailSecondHalf == staffEmailSecondHalf;
  } catch (e) {
    return false;
  }
}


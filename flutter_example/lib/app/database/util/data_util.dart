import 'dart:math';

import '../../constants.dart';
import '../../repository/note_data_repository.dart';

class DataUtil {
  static String generateCustomUniqueId() {
    final Random rnd = Random();
    String result = '';
    for (var i = 0; i < 10; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }
}

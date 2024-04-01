import 'package:get/get.dart';

import '../../controller/note_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NoteController(),
    );
  }
}

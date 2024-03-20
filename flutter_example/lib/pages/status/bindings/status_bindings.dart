import 'package:get/get.dart';

import '../../controller/note_controller.dart';

class StatusBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      // () => StatusController(),
      () => NoteController(),
    );
  }
}

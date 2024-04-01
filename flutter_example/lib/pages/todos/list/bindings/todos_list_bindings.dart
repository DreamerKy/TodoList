import 'package:get/get.dart';
import '../../../controller/note_controller.dart';

class TodosListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NoteController(),
    );
  }
}

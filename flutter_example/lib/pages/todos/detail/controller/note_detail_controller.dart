import 'package:get/get.dart';
import 'package:vanilla_example/base/controller/base_common_controller.dart';
import '../../../../app/constants.dart';
import '../../../../app/repository/note_data_repository.dart';
import '../../../../app/router/router_config.dart';
import '../../../../entity/note_item_enity.dart';

class NoteDetailController extends BaseCommonController {
  NoteDataRepository noteDataRepository = NoteDataRepository();
  @override
  void initData() {
    // TODO: implement initData
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  deleteMenuFunc(Rx<NoteItemEntity> rxItemEntity) {
    noteDataRepository.deleteData(rxItemEntity.value.key);
    rxItemEntity.update((val) {});
  }

  onCheckChanged(bool? isChecked, Rx<NoteItemEntity> rxItemEntity) {
    print("isChecked=$isChecked");
    rxItemEntity.update((itemEntity) {
      itemEntity?.checked = isChecked ?? false;
    });
    noteDataRepository.updateData(rxItemEntity);
  }

  editNote(Rx<NoteItemEntity> rxItemEntity) {
    Get.toNamed(RoutesConfig.addnote, arguments: {
      keyTitle: rxItemEntity.value.title,
      keySubTitle: rxItemEntity.value.subTitle,
      keyCheck: rxItemEntity.value.checked,
      keyIsEdit: valueIsEdit,
    })?.then((value) {
      print('value=$value');
      rxItemEntity.update((itemEntity) {
        itemEntity?.subTitle = value[keySubTitle];
        itemEntity?.title = value[keyTitle];
      });
    });
  }
}

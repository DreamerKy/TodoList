import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vanilla_example/app/constants.dart';
import '../../../../../base/controller/base_common_controller.dart';
import '../../../../../entity/note_item_enity.dart';
import '../../../../app/database/util/data_util.dart';
import '../../../../app/repository/note_data_repository.dart';
import '../../../../app/router/navigator.dart';
import '../../../../app/util/snackbar_util.dart';

class AddNoteController extends BaseCommonController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  FocusNode titleNodeText = FocusNode();
  FocusNode contentNodeText = FocusNode();
  String isEditAble = '';
  NoteDataRepository noteDataRepository = NoteDataRepository();
  @override
  void initData() {}

  setEditMode(String isEdit) {
    isEditAble = isEdit;
  }

  motifyOrSave() {
    titleNodeText.unfocus();
    contentNodeText.unfocus();
    String title = titleController.text.replaceAll(RegExp(r"\s+\b|\b\s"), '');
    String subTitle =
        contentController.text.replaceAll(RegExp(r"\s+\b|\b\s"), '');
    if (title.isEmpty) {
      SnackBarUtil.showSnackBar(
        '温馨提示',
        '请输入事件标题',
      );
      return;
    }
    if (subTitle.isEmpty) {
      SnackBarUtil.showSnackBar('温馨提示', '请输入事件标题');
      return;
    }
    String saveTime = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, " ", HH, ":", nn, ":", ss]);
    String uniqueId = DataUtil.generateCustomUniqueId();
    Rx<NoteItemEntity> itemEntity = NoteItemEntity().obs;
    itemEntity.value.id = uniqueId;
    itemEntity.value.title = title;
    itemEntity.value.subTitle = subTitle;
    itemEntity.value.checked = false;
    itemEntity.value.saveTime = saveTime;
    if (isEditAble == "YES") {
      ///编辑模式不记录统计
      noteDataRepository.updateData(itemEntity);
      NavigatorUtils.goBack(Get.context!, result: {
        keyTitle: itemEntity.value.title,
        keySubTitle: itemEntity.value.subTitle,
      });
    } else {
      noteDataRepository.insertData(itemEntity);
      NavigatorUtils.goBack(Get.context!);
    }
  }

  @override
  void onDestroy() {}
  @override
  void dispose() {
    titleController.dispose();
    titleController.dispose();
    super.dispose();
  }
}

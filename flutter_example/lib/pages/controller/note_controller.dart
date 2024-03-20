// ignore_for_file: invalid_use_of_protected_member

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants.dart';
import '../../app/database/util/data_util.dart';
import '../../app/repository/note_data_repository.dart';
import '../../app/router/navigator.dart';
import '../../app/router/router_config.dart';
import '../../app/util/snackbar_util.dart';
import '../../base/controller/base_common_controller.dart';
import '../../entity/note_item_enity.dart';

class NoteController extends BaseCommonController {
  PageController pageController = PageController();
  NoteDataRepository noteDataRepository = NoteDataRepository();
  RxInt currentIndex = 0.obs;
  RxList<Rx<NoteItemEntity>> rxNoteItems = RxList<Rx<NoteItemEntity>>([]);
  RxString rxFilterOneStatus = '1'.obs;
  RxString rxFilterTwoStatus = '1'.obs;

  RxInt rxActiveNumber = 0.obs;
  RxInt rxFinishNumber = 0.obs;

  ///add
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  FocusNode titleNodeText = FocusNode();
  FocusNode contentNodeText = FocusNode();
  String isEditAble = '';

  @override
  void initData() {
    // TODO: implement initData
    getCalCount();
  }

  queryListByFilterStatus(
      String filterOneStatus, String filterTwoStatus) async {
    rxNoteItems.value = await noteDataRepository.queryListByFilterStatus(
            filterOneStatus, filterTwoStatus) ??
        [];
    getCalCount();
  }

  backResultFunc(dynamic result, Rx<NoteItemEntity> rxItemEntity,
      RxList<Rx<NoteItemEntity>> allNoteItems) {
    if (result[keyIsDel] == valueIsDel) {
      allNoteItems
          .removeWhere((element) => element.value.id == rxItemEntity.value.id);
    } else {
      rxItemEntity.update((itemEntity) {
        if (result != null) {
          itemEntity?.title = result[keyTitle];
          itemEntity?.subTitle = result[keySubTitle];
          itemEntity?.checked = result[keyCheck];
        }
      });
    }
    getCalCount();
  }

  menuValueOneChanged(dynamic value) {
    rxFilterOneStatus.value = value;
    print("值改变了：${rxFilterOneStatus.value}");
    queryListByFilterStatus(rxFilterOneStatus.value, rxFilterTwoStatus.value);
    getCalCount();
  }

  menuValueTwoChanged(dynamic value) {
    rxFilterTwoStatus.value = value;
    print("值改变了：${rxFilterTwoStatus.value}");
    queryListByFilterStatus(rxFilterOneStatus.value, rxFilterTwoStatus.value);
    getCalCount();
  }

  void toggleItemChecked(bool? isChecked, Rx<NoteItemEntity> rxItemEntity) {
    print('isChecked =$isChecked');
    rxItemEntity.update((itemEntity) {
      itemEntity?.checked = isChecked ?? false;
    });
    noteDataRepository.updateData(rxItemEntity);
    print('rxNoteItems toggleItemChecked=$rxNoteItems');
    getCalCount();
  }

  void getCalCount() async {
    var markedCheckCount = await noteDataRepository.calCountByCondition(true);
    var markedUnCheckCount =
        await noteDataRepository.calCountByCondition(false);
    print(
        'markedCheckCount=$markedCheckCount,markedUnCheckCount=$markedUnCheckCount');
    rxFinishNumber.value = markedCheckCount;
    rxActiveNumber.value = markedUnCheckCount;
  }

  deleteMenuFunc(Rx<NoteItemEntity> rxItemEntity) {
    if (rxItemEntity.value.key != '') {
      noteDataRepository.deleteData(rxItemEntity.value.key);
    }
    NavigatorUtils.goBack(Get.context!, result: {
      keyTitle: rxItemEntity.value.title,
      keySubTitle: rxItemEntity.value.subTitle,
      keyCheck: rxItemEntity.value.checked,
      keyIsDel: valueIsDel,
    });
    getCalCount();
  }

  editNote(Rx<NoteItemEntity> rxItemEntity) {
    NavigatorUtils.pushByName(
      RoutesConfig.addnote,
      arguments: {
        keyTitle: rxItemEntity.value.title,
        keySubTitle: rxItemEntity.value.subTitle,
        keyCheck: rxItemEntity.value.checked,
        keyIsEdit: valueIsEdit,
      },
      resultFunc: (result) {
        rxItemEntity.update((itemEntity) {
          if (result != null) {
            itemEntity?.title = result[keyTitle];
            itemEntity?.subTitle = result[keySubTitle];
            getCalCount();
          }
        });
      },
    );
  }

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
    getCalCount();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
}

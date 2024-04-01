import 'package:get/get_rx/src/rx_types/rx_types.dart';

abstract class BaseRepository<T> {
  Future<RxList<Rx<T>>> fetchData(String url);

  RxList<Rx<T>> parseResponse(dynamic data);

  void handleError(error);

  Future<List<Rx<T>>> getAllData();

  void insertData(Rx<T> data);

  void updateData(Rx<T> data);

  void updateMultipleData(RxList<Rx<T>> datas);

  void deleteData(dynamic key);

  void deleteAllData();
}

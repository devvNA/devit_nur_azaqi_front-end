import 'package:get/get.dart';

import 'list_barang_controller.dart';

class ListBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListBarangController>(
      () => ListBarangController(),
    );
  }
}

import 'package:get/get.dart';

import 'add_barang_controller.dart';

class AddBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBarangController>(
      () => AddBarangController(),
    );
  }
}

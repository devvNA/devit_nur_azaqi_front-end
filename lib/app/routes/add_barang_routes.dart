import 'package:get/get.dart';

import '../modules/add_barang/add_barang_binding.dart';
import '../modules/add_barang/add_barang_page.dart';

class AddBarangRoutes {
  AddBarangRoutes._();

  static const addBarang = '/add-barang';

  static final routes = [
    GetPage(
      name: addBarang,
      page: () => const AddBarangPage(),
      binding: AddBarangBinding(),
    ),
  ];
}

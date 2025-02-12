import 'package:get/get.dart';

import '../modules/list_barang/list_barang_binding.dart';
import '../modules/list_barang/list_barang_page.dart';

class ListBarangRoutes {
  ListBarangRoutes._();

  static const listBarang = '/list-barang';

  static final routes = [
    GetPage(
      name: listBarang,
      page: () => const ListBarangPage(),
      binding: ListBarangBinding(),
    ),
  ];
}

import 'list_barang_routes.dart';
import 'add_barang_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/list-barang';

  static final routes = [
    ...ListBarangRoutes.routes,
		...AddBarangRoutes.routes,
  ];
}

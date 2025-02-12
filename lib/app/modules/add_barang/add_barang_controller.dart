import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:management_app/app/core/helpers/database_helper.dart';
import 'package:management_app/app/data/extensions/snackbar_ext.dart';
import 'package:management_app/app/data/models/category_model.dart';
import 'package:management_app/app/data/models/product_model.dart';
import 'package:management_app/app/modules/list_barang/list_barang_controller.dart';

class AddBarangController extends GetxController {
  final products = <Product>[].obs;
  final categories = <Category>[].obs;
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final categoryController = TextEditingController();
  final groupController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final isFilled = false.obs;

  // Ambil data jika Sudah Punya Produk
  Product? product = Get.arguments;
  bool get isEditMode => product != null;

  @override
  void onInit() async {
    super.onInit();
    await fetchCategories();
    if (isEditMode) {
      log(product!.toMap().toString());
      productNameController.text = product!.namaBarang;
      categoryController.text = product!.kategoriId.toString();
      groupController.text = product!.kelompokBarang;
      stockController.text = product!.stok.toString();
      priceController.text = product!.harga.toString();
    }
  }

  Future<void> fetchCategories() async {
    final data = await DatabaseHelper.getAllCategories();
    categories.value = data;
    for (var category in data) {
      log(category.toMap().toString());
    }
  }

  void checkIsFilled() {
    if (productNameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        groupController.text.isEmpty ||
        stockController.text.isEmpty ||
        priceController.text.isEmpty) {
      isFilled.value = false;
    } else {
      isFilled.value = true;
    }
  }

  Future<void> addProduct(Product product) async {
    await DatabaseHelper.insertBarang(product);
    products.add(product);
    Get.find<ListBarangController>().fetchProducts();
    Get.back();
    Get.context!.showSnackBar("Berhasil menambahkan barang");
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper.updateBarang(product);

    Get.find<ListBarangController>().fetchProducts();
    Get.back();
    Get.back();
    Get.context!.showSnackBar("Berhasil mengubah barang");
  }

  Future<void> onSubmit({required Product product}) async {
    if (isEditMode) {
      await updateProduct(product);
    } else {
      await addProduct(product);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    productNameController.dispose();
    categoryController.dispose();
    groupController.dispose();
    stockController.dispose();
    priceController.dispose();
  }
}

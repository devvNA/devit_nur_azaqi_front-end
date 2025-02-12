import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:management_app/app/core/helpers/database_helper.dart';
import 'package:management_app/app/data/extensions/snackbar_ext.dart';
import 'package:management_app/app/data/models/category_model.dart';
import 'package:management_app/app/data/models/product_model.dart';

class ListBarangController extends GetxController {
  final isLoading = false.obs;
  final searchTextEditingController = TextEditingController();
  final products = <Product>[].obs;
  final categories = <Category>[].obs;
  final isEditMode = false.obs;
  final RxSet<int> selectedItems = <int>{}.obs;
  final searchQuery = ''.obs;
  final searchProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
    _initializeSearch();
  }

  void _initializeSearch() {
    searchTextEditingController.addListener(() {
      searchQuery.value = searchTextEditingController.text;
      _filterProducts();
    });

    ever(products, (_) => _filterProducts());
  }

  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      searchProducts.value = products;
      return;
    }

    final query = searchQuery.value.toLowerCase();
    searchProducts.value = products.where((product) {
      return product.namaBarang.toLowerCase().contains(query) ||
          product.kelompokBarang.toLowerCase().contains(query) ||
          getCategoryName(product.kategoriId).toLowerCase().contains(query);
    }).toList();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final data = await DatabaseHelper.getAllBarang();
    products.value = data;
    isLoading.value = false;
    for (var product in products) {
      log('product: ${product.toMap()}');
    }
  }

  String getCategoryName(int? categoryId) {
    if (categoryId == null) return 'Tidak ada kategori';

    if (categories.isEmpty) {
      fetchCategories();
      return 'Memuat kategori...';
    }

    final category = categories.firstWhereOrNull((c) => c.id == categoryId);
    return category?.namaKategori ?? 'Kategori tidak ditemukan';
  }

  Future<void> fetchCategories() async {
    try {
      final result = await DatabaseHelper.getAllCategories();
      categories.assignAll(result);
    } catch (e) {
      log('Error loading categories: $e');
    }
  }

  Future<void> onRefresh() async {
    products.clear();
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.deleteBarang(id);
    products.removeWhere((product) => product.id == id);
    Get.back();
    onRefresh();
    Get.context!.showSnackBar("Berhasil menghapus barang");
  }

  Future<void> deleteBulkProducts() async {
    if (selectedItems.isEmpty) {
      Get.context!
          .showSnackBar("Pilih barang yang ingin dihapus", isError: true);
      return;
    }
    await DatabaseHelper.deleteBulkBarang(selectedItems.toList());
    products.removeWhere((product) => selectedItems.contains(product.id));
    selectedItems.clear();
    Get.back();
    Get.context!.showSnackBar("Berhasil menghapus barang");
  }

  @override
  void onClose() {
    super.onClose();
    searchTextEditingController.dispose();
  }
}

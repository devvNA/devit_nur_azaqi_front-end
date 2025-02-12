import 'dart:developer';

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:management_app/app/data/extensions/currency_ext.dart';
import 'package:management_app/app/data/models/product_model.dart';
import 'package:management_app/app/routes/add_barang_routes.dart';

import 'list_barang_controller.dart';

class ListBarangPage extends GetView<ListBarangController> {
  const ListBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListBarangController>(
      builder: (_) => Scaffold(
        body: Obx(() => _buildBody()),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 12.0),
            _buildHeader(),
            _buildProductList(),
            _buildRefreshHint(),
          ],
        ),
        if (controller.isLoading.value) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: AnimationSearchBar(
          backIconColor: Colors.black,
          centerTitle: 'List Stok Barang',
          centerTitleStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000080),
          ),
          onChanged: (text) => log(text),
          searchTextEditingController: controller.searchTextEditingController,
          horizontalPadding: 16,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() =>
              Text('${controller.searchProducts.length} Data ditampilkan')),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      onPressed: () {
        controller.isEditMode.toggle();
        controller.selectedItems.clear();
        controller.update();
      },
      style: TextButton.styleFrom(foregroundColor: Colors.blue),
      child: Text(
        controller.isEditMode.value ? 'Kembali' : 'Edit Data',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: RefreshIndicator(
          color: Colors.indigo,
          onRefresh: () async => controller.onRefresh(),
          child: Obx(() => SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: List.generate(
                    controller.searchProducts.length,
                    (index) =>
                        _buildProductItem(controller.searchProducts[index]),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildProductItem(Product item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF000080).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: controller.isEditMode.value
              ? _buildCheckbox(item)
              : Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF000080),
                ),
        ),
        onTap: () => _showProductDetail(item),
        title: Text(
          item.namaBarang,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Stok: ${item.stok}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Text(
          item.harga.currencyFormatRp,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF000080),
          ),
        ),
      ),
    );
  }

  Widget? _buildCheckbox(Product item) {
    if (!controller.isEditMode.value) return null;

    return Checkbox(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      activeColor: Colors.indigo,
      value: controller.selectedItems.contains(item.id),
      onChanged: (bool? selected) {
        if (selected == true) {
          controller.selectedItems.add(item.id!);
        } else {
          controller.selectedItems.remove(item.id);
        }
      },
    );
  }

  Widget _buildRefreshHint() {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_circle_down,
            size: 22.0,
            color: Colors.grey[700],
          ),
          SizedBox(width: 4.0),
          Text(
            "Tarik untuk me-refresh data",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.indigo),
    );
  }

  Widget _buildFloatingActionButton() {
    if (controller.isEditMode.value) {
      return _buildEditModeActions();
    }
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AddBarangRoutes.addBarang),
      label: Text(
        'Tambah Barang',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      icon: Icon(Icons.add),
      backgroundColor: Color(0xFF000080),
      elevation: 4,
    );
  }

  Widget _buildEditModeActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      height: 100.0,
      child: Row(
        children: [
          _buildSelectAllCheckbox(),
          Text(
            "Pilih Semua",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildSelectAllCheckbox() {
    return Obx(() => Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          activeColor: Colors.indigo,
          value: controller.searchProducts.isNotEmpty &&
              controller.selectedItems.length ==
                  controller.searchProducts.length,
          onChanged: controller.searchProducts.isEmpty
              ? null
              : (bool? selected) {
                  if (selected == true) {
                    controller.selectedItems.clear();
                    controller.selectedItems.addAll(controller.searchProducts
                        .map((product) => product.id!)
                        .toList());
                  } else {
                    controller.selectedItems.clear();
                  }
                },
        ));
  }

  Widget _buildDeleteButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Colors.red,
        side: BorderSide(
          color: Colors.grey[350]!,
        ),
      ),
      onPressed: () {
        controller.deleteBulkProducts();
      },
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Hapus Barang",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showProductDetail(Product item) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: Get.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDetailHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductHeader(item),
                      SizedBox(height: 24),
                      _buildDetailSection(item),
                      SizedBox(height: 24),
                      _buildStockSection(item),
                      SizedBox(height: 24),
                      _buildPriceSection(item),
                    ],
                  ),
                ),
              ),
            ),
            _buildDetailActions(item),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Detail Produk',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000080),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader(Product item) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF000080).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF000080),
            size: 30,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.namaBarang,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                controller.getCategoryName(item.kategoriId),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(Product item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informasi Produk'),
        SizedBox(height: 16),
        _buildInfoCard([
          _buildInfoItem('Kelompok Barang', item.kelompokBarang),
          _buildInfoItem(
              'Kategori', controller.getCategoryName(item.kategoriId)),
        ]),
      ],
    );
  }

  Widget _buildStockSection(Product item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informasi Stok'),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF000080).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.inventory_outlined,
                color: Color(0xFF000080),
                size: 24,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stok Tersedia',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${item.stok} unit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000080),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Product item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informasi Harga'),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: Colors.green[700],
                size: 24,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga Unit',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item.harga.currencyFormatRp,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActions(Product item) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.back();
                controller.deleteProduct(item.id!);
              },
              icon: Icon(Icons.delete_outline),
              label: Text('Hapus'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.back();
                Get.toNamed(AddBarangRoutes.addBarang, arguments: item);
              },
              icon: Icon(Icons.edit),
              label: Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF000080),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

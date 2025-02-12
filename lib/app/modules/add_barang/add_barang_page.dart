import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:management_app/app/core/helpers/thousand_separator.dart';
import 'package:management_app/app/core/helpers/validator.dart';
import 'package:management_app/app/core/widgets/custom_dropdown.dart';
import 'package:management_app/app/core/widgets/custom_textform.dart';
import 'package:management_app/app/data/models/product_model.dart';

import 'add_barang_controller.dart';

class AddBarangPage extends GetView<AddBarangController> {
  const AddBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.indigo),
        title: const Text(
          'Tambah Barang',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.indigo.shade50],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Nama Barang*"),
                CustomTextForm(
                  controller: controller.productNameController,
                  label: 'Masukkan nama barang',
                  validator: (p0) =>
                      Validator.required(p0, fieldName: '⚠️ Nama Barang'),
                  onChanged: (_) => controller.checkIsFilled(),
                  
                ),
                const SizedBox(height: 16.0),
                _buildSectionTitle("Kategori*"),
                Obx(() {
                  return CustomDropDown(
                    label: "Pilih kategori",
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text("Pilih kategori"),
                      ),
                      ...controller.categories
                          .map((category) => DropdownMenuItem(
                                value: category.id.toString(),
                                child: Text(category.namaKategori),
                              )),
                    ],
                    value: controller.categoryController.text.isEmpty
                        ? null
                        : controller.categoryController.text,
                    onChanged: (value) {
                      controller.categoryController.text =
                          value?.toString() ?? '';
                      controller.checkIsFilled();
                    },
                    validator: (p0) =>
                        Validator.required(p0, fieldName: '⚠️ Kategori'),
                  );
                }),
                const SizedBox(height: 10.0),
                Text("Kelompok Barang*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 4.0),
                CustomTextForm(
                  controller: controller.groupController,
                  onChanged: (_) {
                    controller.checkIsFilled();
                  },
                  label: '',
                  validator: (p0) {
                    return Validator.required(p0,
                        fieldName: '⚠️ Kelompok Barang');
                  },
                ),
                const SizedBox(height: 10.0),
                Text("Stok*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 4.0),
                CustomTextForm(
                  controller: controller.stockController,
                  label: '',
                  onChanged: (_) {
                    controller.checkIsFilled();
                  },
                  validator: (p0) {
                    return Validator.required(p0, fieldName: '⚠️ Stok');
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 10.0),
                Text("Harga*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 4.0),
                CustomTextForm(
                  controller: controller.priceController,
                  label: '',
                  onChanged: (_) {
                    controller.checkIsFilled();
                  },
                  prefixText: 'Rp ',
                  validator: (p0) {
                    return Validator.required(p0, fieldName: '⚠️ Harga');
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return ElevatedButton(
            onPressed: controller.isFilled.value
                ? () {
                    if (controller.formKey.currentState!.validate()) {
                      final price =
                          ThousandsSeparatorInputFormatter.getUnformattedValue(
                              controller.priceController.text);
                      controller.onSubmit(
                        product: Product(
                          id: controller.isEditMode
                              ? controller.product!.id
                              : null,
                          namaBarang: controller.productNameController.text,
                          kategoriId:
                              int.parse(controller.categoryController.text),
                          kelompokBarang: controller.groupController.text,
                          stok: int.parse(controller.stockController.text),
                          harga: int.parse(price),
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
            ),
            child: Text(
              controller.isEditMode ? 'Update Barang' : 'Tambah Barang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.indigo.shade700,
        ),
      ),
    );
  }
}

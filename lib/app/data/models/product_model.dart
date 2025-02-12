class Product {
  int? id;
  String namaBarang;
  int kategoriId;
  int stok;
  String kelompokBarang;
  int harga;
  bool isSelected; // for bulk delete

  Product({
    this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.stok,
    required this.kelompokBarang,
    required this.harga,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      namaBarang: map['nama_barang'],
      kategoriId: map['kategori_id'],
      stok: map['stok'],
      kelompokBarang: map['kelompok_barang'],
      harga: map['harga'],
    );
  }
}

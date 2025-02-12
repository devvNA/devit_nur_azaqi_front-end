class Category {
  int? id;
  String namaKategori;

  Category({
    this.id,
    required this.namaKategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      namaKategori: map['nama_kategori'],
    );
  }
}

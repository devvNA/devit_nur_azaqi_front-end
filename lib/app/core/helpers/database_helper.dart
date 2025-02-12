import 'package:management_app/app/data/models/category_model.dart';
import 'package:management_app/app/data/models/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'siscom_database.db'),
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE barang(id INTEGER PRIMARY KEY AUTOINCREMENT, nama_barang TEXT, kategori_id INTEGER, stok INTEGER, kelompok_barang TEXT, harga INTEGER)''',
        );
        db.execute(
          '''CREATE TABLE kategori(id INTEGER PRIMARY KEY AUTOINCREMENT, nama_kategori TEXT)''',
        );
        // Isi kategori default
        db.insert('kategori', {'nama_kategori': 'Elektronik'});
        db.insert('kategori', {'nama_kategori': 'Pakaian'});
        db.insert('kategori', {'nama_kategori': 'Makanan'});
        db.insert('kategori', {'nama_kategori': 'Minuman'});
        db.insert('kategori', {'nama_kategori': 'Perabotan Rumah'});
        db.insert('kategori', {'nama_kategori': 'Alat Tulis'});
        db.insert('kategori', {'nama_kategori': 'Kosmetik'});
        db.insert('kategori', {'nama_kategori': 'Otomotif'});
        db.insert('kategori', {'nama_kategori': 'Olahraga'});
        db.insert('kategori', {'nama_kategori': 'Mainan'});
      },
      version: 1,
    );
  }

  static Future<void> generateDummyData() async {
    final db = await _database();

    // Cek apakah data barang sudah ada
    final List<Map<String, dynamic>> existingData = await db.query('barang');
    if (existingData.isEmpty) {
      await db.insert('barang', {
        'nama_barang': 'Laptop Asus',
        'kategori_id': 1,
        'stok': 15,
        'kelompok_barang': 'Laptop',
        'harga': 8500000
      });
      await db.insert('barang', {
        'nama_barang': 'Mouse Gaming',
        'kategori_id': 1,
        'stok': 25,
        'kelompok_barang': 'Aksesoris',
        'harga': 350000
      });
      await db.insert('barang', {
        'nama_barang': 'Kemeja Putih',
        'kategori_id': 2,
        'stok': 50,
        'kelompok_barang': 'Kemeja',
        'harga': 150000
      });
      await db.insert('barang', {
        'nama_barang': 'Celana Jeans',
        'kategori_id': 2,
        'stok': 30,
        'kelompok_barang': 'Celana',
        'harga': 250000
      });
      await db.insert('barang', {
        'nama_barang': 'Mie Instan',
        'kategori_id': 3,
        'stok': 100,
        'kelompok_barang': 'Mie',
        'harga': 3500
      });
    }
  }

  static Future<List<Product>> getAllBarang() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query('barang');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  static Future<List<Category>> getAllCategories() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query('kategori');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  static Future<void> insertBarang(Product product) async {
    final db = await _database();
    await db.insert('barang', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateBarang(Product product) async {
    final db = await _database();
    await db.update('barang', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  static Future<void> deleteBarang(int id) async {
    final db = await _database();
    await db.delete('barang', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteBulkBarang(List<int> ids) async {
    final db = await _database();
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete('barang', where: 'id IN ($placeholders)', whereArgs: ids);
  }
}

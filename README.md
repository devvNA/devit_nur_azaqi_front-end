# Management App

Aplikasi manajemen inventori barang menggunakan Flutter dengan state management GetX dan database lokal SQL.

## Fitur Utama

- Database lokal SQL dengan 2 tabel:
  - Tabel Barang (id, nama_barang, kategori_id, stok, kelompok_barang, harga)
  - Tabel Kategori (id, nama_kategori)
- Tampilan list barang menampilkan nama, stok, dan harga
- Detail barang menggunakan bottomsheet
- Form tambah barang dengan:
  - Input nama barang (text)
  - Pilihan kategori (dropdown dari tabel kategori)
  - Input stok (angka)
  - Pilihan kelompok barang (dropdown statis)
  - Input harga (format Rupiah)
- Fitur edit barang
- Fitur hapus barang (single & bulk delete dengan checkbox)

## Teknologi yang Digunakan

- Flutter
- GetX State Management
- SQLite Database
- Material Design

## Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terinstall
2. Clone repository ini
3. Jalankan perintah `flutter pub get`
4. Jalankan aplikasi dengan `flutter run`

## Screenshots

[Screenshot aplikasi akan ditambahkan di sini]

## Design Reference

Design mengacu pada [Figma Design](https://www.figma.com/file/9b474WRsS3TxLlECRMLeLv/%F0%9F%8E%AF-Mobile-Test?type=design&node-id=2-54877&mode=design&t=FwaLBU2f5a4RtGfI-0) dengan beberapa penyesuaian untuk pengalaman pengguna yang lebih baik.

## Struktur Proyek

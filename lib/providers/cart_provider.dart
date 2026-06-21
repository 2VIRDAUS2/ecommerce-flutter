import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produk.dart';

class CartProvider extends ChangeNotifier {
  Map<String, Produk> _items = {};

  Map<String, Produk> get items => _items;

  double get totalHarga {
    double total = 0.0;
    _items.forEach((key, produk) {
      total += produk.harga;
    });
    return total;
  }

  // 1. Fungsi Memuat Data (Dipanggil saat aplikasi pertama dibuka)
  Future<void> muatKeranjangLokal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataLokal = prefs.getString('data_keranjang');
    
    if (dataLokal != null) {
      // Mengubah string JSON kembali menjadi Map<String, dynamic>
      final Map<String, dynamic> decodedData = jsonDecode(dataLokal);
      
      // Memetakan kembali ke dalam memori Provider
      _items = decodedData.map(
        (key, value) => MapEntry(key, Produk.fromLocalJson(value)),
      );
      notifyListeners();
    }
  }

  // 2. Fungsi Menyimpan Data (Dipanggil secara internal)
  Future<void> _simpanKeLokal() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengubah Map objek menjadi string JSON
    final String dataString = jsonEncode(
      _items.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('data_keranjang', dataString);
  }

  // 3. Fungsi Tambah Barang
  void tambahKeKeranjang(Produk produk) {
    if (!_items.containsKey(produk.id)) {
      _items.putIfAbsent(produk.id, () => produk);
      _simpanKeLokal(); // Simpan ke storage secara background
      notifyListeners();
    }
  }

  // 4. Fungsi Hapus Barang
  void hapusDariKeranjang(String id) {
    _items.remove(id);
    _simpanKeLokal(); // Perbarui storage secara background
    notifyListeners();
  }

  // 5. Fungsi Checkout (Simulasi Pembayaran)
  void checkout() {
    _items.clear(); // Mengosongkan data di memori (RAM)
    _simpanKeLokal(); // Menimpa data di storage internal menjadi kosong
    notifyListeners(); // Memaksa layar keranjang untuk menggambar ulang
  }
}
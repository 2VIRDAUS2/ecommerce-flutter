import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ProdukProvider extends ChangeNotifier {
  List<Produk> _items = [];
  bool _isLoading = false;

  List<Produk> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> tarikDataProduk() async {
    _isLoading = true;
    notifyListeners(); // Memicu UI memunculkan loading

    final url = Uri.parse('https://fakestoreapi.com/products');
    
    try {
      final respon = await http.get(url);
      if (respon.statusCode == 200) {
        final List<dynamic> dataMentah = jsonDecode(respon.body);
        // Mapping JSON array menjadi List of Produk
        _items = dataMentah.map((json) => Produk.fromJson(json)).toList();
      }
    } catch (e) {
      print('Terjadi kesalahan jaringan: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Memicu UI mematikan loading dan merender daftar
    }
  }
}
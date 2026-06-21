import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/produk_provider.dart';
import 'screens/katalog_screen.dart';

void main() {
  runApp(
    MultiProvider(
      // ...
      providers: [
        // Tambahkan ..muatKeranjangLokal() di sini
        ChangeNotifierProvider(create: (context) => CartProvider()..muatKeranjangLokal()),
        ChangeNotifierProvider(create: (context) => ProdukProvider()..tarikDataProduk()),
      ],
// ...
      child: const TokoApp(),
    ),
  );
}

class TokoApp extends StatelessWidget {
  const TokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Informatika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Menjadikan KatalogScreen sebagai halaman utama aplikasi
      home: KatalogScreen(), 
    );
  }
}
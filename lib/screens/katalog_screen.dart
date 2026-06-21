import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/produk_provider.dart';
import 'cart_screen.dart';

class KatalogScreen extends StatelessWidget {
  const KatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca status Provider produk
    final produkProvider = context.watch<ProdukProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Informatika'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          )
        ],
      ),
      // Percabangan Logika UI
      body: produkProvider.isLoading
          ? const Center(child: CircularProgressIndicator()) // Jika loading
          : produkProvider.items.isEmpty
              ? const Center(child: Text('Gagal menarik data dari server.'))
              : ListView.builder(
                  itemCount: produkProvider.items.length,
                  itemBuilder: (context, index) {
                    final produk = produkProvider.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        // Menggunakan Image.network untuk merender gambar dari URL API
                        leading: Image.network(
                          produk.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          produk.nama,
                          maxLines: 2, // Membatasi judul agar tidak merusak layout
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Rp ${produk.harga.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            context.read<CartProvider>().tambahKeKeranjang(produk);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Masuk keranjang!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text('Beli'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca data keranjang secara real-time
    final cart = context.watch<CartProvider>();
    // Mengubah Map dari Provider menjadi List agar bisa dibaca oleh ListView
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Keranjang Anda masih kosong.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Bagian 1: Daftar Produk di Keranjang
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final produk = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          leading: Image.network(
                          produk.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          // Pertahanan tambahan: jika gambar gagal dimuat dari internet
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                          title: Text(produk.nama),
                          subtitle: Text('Rp ${produk.harga}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Memanggil fungsi hapus dari otak Provider
                              context.read<CartProvider>().hapusDariKeranjang(produk.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bagian 2: Ringkasan Total Harga
                // Bagian 2: Ringkasan Total Harga dan Tombol Checkout
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column( // Mengubah Row menjadi Column agar tombol bisa ditaruh di bawahnya
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp ${cart.totalHarga.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Jarak pemisah
                        SizedBox(
                          width: double.infinity, // Membuat tombol memenuhi lebar layar
                          child: ElevatedButton(
                            // Logika: Jika keranjang kosong, tombol nonaktif (null)
                            onPressed: cartItems.isEmpty
                                ? null
                                : () {
                                    // 1. Eksekusi pembersihan data
                                    context.read<CartProvider>().checkout();
                                    
                                    // 2. Tampilkan notifikasi visual
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pembayaran Berhasil! Pesanan diproses.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    
                                    // 3. Keluarkan pengguna dari halaman keranjang kembali ke katalog
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Checkout Sekarang',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
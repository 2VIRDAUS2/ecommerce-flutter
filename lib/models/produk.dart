class Produk {
  final String id;
  final String nama;
  final double harga;
  final String imageUrl;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.imageUrl,
  });

  // Factory methode untuk ekstraksi data dari JSON API
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      // Jika id null, berikan nilai '0'
      id: json['id']?.toString() ?? '0',
      // Jika title null, berikan teks pengganti
      nama: json['title'] ?? 'Produk Tanpa Nama',
      // Validasi matematis: pastikan price tidak null sebelum dikali 15000
      harga: json['price'] != null ? (json['price'] as num).toDouble() * 15000 : 0.0,
      // Jika gambar gagal dimuat/null, berikan gambar abu-abu dari placeholder
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }

  // Fungsi untuk mengekstrak data dari memori lokal (tanpa perkalian kurs)
  factory Produk.fromLocalJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id']?.toString() ?? '0',
      nama: json['nama'] ?? 'Produk Tanpa Nama',
      harga: json['harga'] != null ? (json['harga'] as num).toDouble() : 0.0,
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }

  // Fungsi untuk mengonversi objek menjadi format yang bisa disimpan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'imageUrl': imageUrl,
    };
  }
}
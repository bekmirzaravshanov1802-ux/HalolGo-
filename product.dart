class Product {
  final int id;
  final String name;
  final int price;
  final String? image;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.category = 'Barchasi',
  });
}

// Vaqtinchalik katalog. Keyingi bosqichda admin boshqaradigan katalogga
// server API orqali ulaymiz.
const demoProducts = <Product>[
  Product(id: 1, name: 'Mol go‘shti', price: 85000, category: 'Go‘sht'),
  Product(id: 2, name: 'Tovuq go‘shti', price: 42000, category: 'Go‘sht'),
  Product(id: 3, name: 'Guruch', price: 18000, category: 'Oziq-ovqat'),
  Product(id: 4, name: 'Sut', price: 12000, category: 'Sut mahsulotlari'),
];

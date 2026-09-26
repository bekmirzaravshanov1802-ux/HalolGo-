import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final cart = <Product, int>{};

  String money(int n) => '${n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} so‘m';

  void add(Product p) {
    setState(() => cart[p] = (cart[p] ?? 0) + 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.name} savatga qo‘shildi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _catalog(),
      _cart(),
      _orders(),
      _profile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HalolGo', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (tab == 0)
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Bosh sahifa'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Savat'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Buyurtmalar'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _catalog() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Assalomu alaykum, ${widget.user['name'] ?? ''}!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        const Text('Mahsulotlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...demoProducts.map((p) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(p.name.substring(0, 1))),
            title: Text(p.name),
            subtitle: Text(p.category),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(money(p.price), style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => add(p),
                  icon: const Icon(Icons.add_shopping_cart),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _cart() {
    if (cart.isEmpty) {
      return const Center(child: Text('Savat hozircha bo‘sh'));
    }
    int total = 0;
    for (final e in cart.entries) total += e.key.price * e.value;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Savat', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ...cart.entries.map((e) => ListTile(
          title: Text(e.key.name),
          subtitle: Text('${e.value} dona'),
          trailing: Text(money(e.key.price * e.value)),
        )),
        const Divider(),
        Text('Jami: ${money(total)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keyingi bosqich: manzil va buyurtma berish')),
          ),
          icon: const Icon(Icons.shopping_bag),
          label: const Text('Buyurtma berish'),
        ),
      ],
    );
  }

  Widget _orders() {
    return FutureBuilder<List<dynamic>>(
      future: Api.orders(widget.user['id'] as int),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) return Center(child: Text('Xato: ${snap.error}'));
        final data = snap.data ?? [];
        if (data.isEmpty) return const Center(child: Text('Buyurtmalar yo‘q'));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: data.map((o) => Card(
            child: ListTile(
              title: Text(o['oid'].toString()),
              subtitle: Text(o['status'].toString()),
              trailing: Text('${o['total'] ?? 0} so‘m'),
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _profile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 42)),
        const SizedBox(height: 12),
        Center(child: Text(widget.user['name'] ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 4),
        Center(child: Text(widget.user['phone'] ?? '')),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Bonus'),
          trailing: Text('${widget.user['bal'] ?? 0} so‘m'),
        ),
        const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Manzillar')),
        const ListTile(leading: Icon(Icons.chat_outlined), title: Text('Yordam / Chat')),
      ],
    );
  }
}

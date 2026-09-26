import 'package:flutter/material.dart';
import '../services/api.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool registerMode = false;
  bool loading = false;

  Future<void> submit() async {
    if (phone.text.trim().isEmpty || password.text.isEmpty ||
        (registerMode && name.text.trim().length < 2)) {
      _show('Ma’lumotlarni to‘liq kiriting');
      return;
    }
    setState(() => loading = true);
    try {
      final user = registerMode
          ? await Api.register(name.text.trim(), phone.text.trim(), password.text)
          : await Api.login(phone.text.trim(), password.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      _show(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.shopping_bag_rounded, size: 72, color: Colors.green),
                const SizedBox(height: 12),
                const Text('HalolGo',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(registerMode ? 'Yangi hisob yarating' : 'Xush kelibsiz'),
                const SizedBox(height: 28),
                if (registerMode) ...[
                  TextField(controller: name, decoration: const InputDecoration(
                    labelText: 'Ism va familiya', prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 14),
                ],
                TextField(controller: phone, keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefon (+998...)', prefixIcon: Icon(Icons.phone))),
                const SizedBox(height: 14),
                TextField(controller: password, obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Parol', prefixIcon: Icon(Icons.lock))),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: loading ? null : submit,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(registerMode ? 'Ro‘yxatdan o‘tish' : 'Kirish'),
                  ),
                ),
                TextButton(
                  onPressed: loading ? null : () =>
                      setState(() => registerMode = !registerMode),
                  child: Text(registerMode
                      ? 'Menda allaqachon hisob bor'
                      : 'Yangi hisob yaratish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

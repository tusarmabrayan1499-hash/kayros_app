import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactoSoporteScreen extends StatelessWidget {
  const ContactoSoporteScreen({super.key});

  Future<void> _openUri(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo abrir el enlace.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto y soporte')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('¿Necesitas ayuda?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _openUri(context, Uri.parse('https://wa.me/573001112233?text=Hola%20Kayros,%20necesito%20soporte')),
              icon: const Icon(Icons.chat),
              label: const Text('Contactar por WhatsApp'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _openUri(context, Uri.parse('https://tawk.to/')),
              icon: const Icon(Icons.support_agent),
              label: const Text('Abrir chat en línea'),
            ),
          ],
        ),
      ),
    );
  }
}

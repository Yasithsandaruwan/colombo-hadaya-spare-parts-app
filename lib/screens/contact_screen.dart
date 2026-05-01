import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/order_service.dart';
import '../widgets/footer_strip.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = OrderService.shopContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Delivery Shops"),
      ),

      body: contacts.isEmpty
          ? const Center(
              child: Text(
                "No shop contacts available",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final shop = contacts.keys.elementAt(index);
                final phone = contacts[shop]!;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.store,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.phone,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          final cleanedPhone =
                              phone.replaceAll(RegExp(r'[^0-9+]'), '');
                          final uri = Uri(scheme: 'tel', path: cleanedPhone);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                            return;
                          }

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Unable to open dialer"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const FooterStrip(),
    );
  }
}
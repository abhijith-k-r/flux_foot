import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  Widget heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget content(String text) {
    return Text(text, style: const TextStyle(fontSize: 15, height: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading('Privacy Policy'),
            content('Last Updated: July 2026'),

            heading('1. Information We Collect'),
            content(
              'We may collect personal information including your full name, email address, phone number, shipping address, account details, purchased products, transaction details, order history, device information, operating system, app version, and usage analytics.',
            ),

            heading('2. How We Use Your Information'),
            content(
              'We use your information to create and manage accounts, process orders and payments, provide customer support, deliver products, improve user experience, and send important notifications related to orders and accounts.',
            ),

            heading('3. Information Sharing'),
            content(
              'We do not sell or rent your personal information. Information may be shared with sellers for order fulfillment, delivery partners for shipping, payment service providers for payment processing, and authorities when legally required.',
            ),

            heading('4. Data Security'),
            content(
              'We implement appropriate technical and organizational measures to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no online system can guarantee complete security.',
            ),

            heading('5. Cookies and Analytics'),
            content(
              'The application may use analytics tools and similar technologies to understand usage patterns and improve services.',
            ),

            heading('6. User Rights'),
            content(
              'Users may view their account information, update personal details, request account deletion where applicable, and contact support regarding privacy concerns.',
            ),

            heading('7. Children\'s Privacy'),
            content(
              'FluxFoot is not intended for children under the age required by local laws. We do not knowingly collect personal information from children.',
            ),

            heading('8. Third-Party Services'),
            content(
              'The application may contain links to third-party websites or services. We are not responsible for the privacy practices of external services.',
            ),

            heading('9. Changes to This Privacy Policy'),
            content(
              'We may update this Privacy Policy periodically. Any changes will be posted within the application.',
            ),

            heading('10. Contact Us'),
            content(
              'For privacy-related questions or requests, please contact us through the Help Center available in the application.',
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
  
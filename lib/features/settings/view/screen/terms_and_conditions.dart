import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

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
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading('Terms & Conditions'),
            content('Last Updated: July 2026'),

            heading('1. Acceptance of Terms'),
            content(
              'By creating an account, browsing products, or placing orders through FluxFoot, you acknowledge that you have read, understood, and agreed to these Terms & Conditions.',
            ),

            heading('2. User Accounts'),
            content(
              'Users are responsible for maintaining the confidentiality of their account credentials. You agree to provide accurate and complete information and keep your account information updated.',
            ),

            heading('3. Products and Orders'),
            content(
              'FluxFoot provides football-related merchandise, including jerseys, boots, accessories, and other football products offered by authorized sellers. Product descriptions, images, and pricing may change without notice.',
            ),

            heading('4. Payments'),
            content(
              'All payments must be completed through approved payment methods available within the application. Orders will only be processed after successful payment confirmation.',
            ),

            heading('5. Shipping and Delivery'),
            content(
              'Delivery times may vary depending on location and product availability. FluxFoot is not responsible for delays caused by shipping partners or circumstances beyond our control.',
            ),

            heading('6. Returns and Refunds'),
            content(
              'Users may request returns or refunds according to the seller\'s return policy. Returned products must be unused, undamaged, and in their original packaging.',
            ),

            heading('7. User Conduct'),
            content(
              'Users agree not to use the application for unlawful purposes, attempt unauthorized access, post harmful content, or engage in fraudulent purchasing activities. Violations may result in account suspension or termination.',
            ),

            heading('8. Intellectual Property'),
            content(
              'All logos, trademarks, designs, content, and application features belong to FluxFoot or their respective owners and may not be copied, modified, or distributed without permission.',
            ),

            heading('9. Limitation of Liability'),
            content(
              'FluxFoot shall not be liable for indirect, incidental, special, or consequential damages arising from the use of the application, products, or services.',
            ),

            heading('10. Changes to Terms'),
            content(
              'We reserve the right to update these Terms & Conditions at any time. Continued use of the application after changes constitutes acceptance of the updated terms.',
            ),

            heading('11. Contact Us'),
            content(
              'If you have any questions regarding these Terms & Conditions, please contact us through the Help Center available in the application.',
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

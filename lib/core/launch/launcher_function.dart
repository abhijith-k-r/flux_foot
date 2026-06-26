import 'package:url_launcher/url_launcher.dart';

/// WhatsApp
Future<void> openWhatsApp() async {
  final Uri url = Uri.parse('https://wa.me/+91 8547758264');

  await launchUrl(url, mode: LaunchMode.externalApplication);
}

/// Telegram
Future<void> openTelegram() async {
  final Uri url = Uri.parse('https://t.me/@abhijith_rono_7');

  await launchUrl(url, mode: LaunchMode.externalApplication);
}

/// Instagram
Future<void> openInstagram() async {
  final Uri url = Uri.parse('https://www.instagram.com/abhijith___k_r/');

  await launchUrl(url, mode: LaunchMode.externalApplication);
}

/// Email
Future<void> openEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'abhijithrono007@gmail.com',
    queryParameters: {'subject': 'Support Request'},
  );

  await launchUrl(emailUri);
}

/// Phone Call
Future<void> makePhoneCall() async {
  final Uri phoneUri = Uri(scheme: 'tel', path: '+91 8547758264');

  await launchUrl(phoneUri);
}

/// SMS Message
Future<void> sendSMS() async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: '+91 8547758264',
    queryParameters: {'body': 'Hello, I need support.'},
  );

  await launchUrl(smsUri);
}

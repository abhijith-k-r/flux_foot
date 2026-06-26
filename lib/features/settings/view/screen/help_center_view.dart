import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/launch/launcher_function.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/features/account/views/widgets/account_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Text('Help Center'),
      ),
      body: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 10,),
          AccountContent(
            size: size,
            title: 'WhatsApp',
            subtitle: '',
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            ontap: openWhatsApp,
          ),

          AccountContent(
            size: size,
            title: 'Telegram',
            subtitle: '',
            icon: FaIcon(FontAwesomeIcons.telegram),
            ontap: openTelegram,
          ),

          AccountContent(
            size: size,
            title: 'Instagram',
            subtitle: '',
            icon: FaIcon(FontAwesomeIcons.instagram),
            ontap: openInstagram,
          ),

          AccountContent(
            size: size,
            title: 'Email',
            subtitle: '',
            icon: const Icon(Icons.email),
            ontap: openEmail,
          ),

          AccountContent(
            size: size,
            title: 'Call Us',
            subtitle: '',
            icon: const Icon(Icons.phone),
            ontap: makePhoneCall,
          ),

          AccountContent(
            size: size,
            title: 'Message Us',
            subtitle: '',
            icon: const Icon(Icons.message),
            ontap: sendSMS,
          ),
        ],
      ),
    );
  }
}

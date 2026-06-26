import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/features/account/views/widgets/account_widgets.dart';
import 'package:fluxfoot_user/features/account/views/widgets/profilescreen_logoutbutton.dart';
import 'package:fluxfoot_user/features/settings/view/screen/help_center_view.dart';
import 'package:fluxfoot_user/features/settings/view/screen/privacy_policy.dart';
import 'package:fluxfoot_user/features/settings/view/screen/terms_and_conditions.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Text('Settings  '),
      ),
      body: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 10),

          AccountContent(
            size: size,
            title: 'Help Center',
            subtitle: 'Contact support',
            icon: CupertinoIcons.question_circle,
            ontap: () => fadePush(context, HelpCenterView()),
          ),
          AccountContent(
            size: size,
            title: 'Terms & Conditions',
            subtitle: ' App usage rules',
            icon: CupertinoIcons.doc_text,
            ontap: () => fadePush(context, TermsAndConditions()),
          ),
          AccountContent(
            size: size,
            title: 'Privacy Policy',
            subtitle: 'Data protection',
            icon: CupertinoIcons.lock_shield,
            ontap: () => fadePush(context, PrivacyPolicy()),
          ),
          Spacer(),
          builldLogOtButton(size),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

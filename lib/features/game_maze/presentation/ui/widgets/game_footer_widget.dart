import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../shared/theme/app_colors.dart';

class GameFooterWidget extends StatelessWidget {
  const GameFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://twitter.com/soletreme"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Image.asset(
            "assets/images/twitter.png",
            height: 32,
            color: Colors.white.withAlpha(255 * 0.4.toInt()),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "soletre.me - ricarth lima @ 2026",
          style: TextStyle(
            fontFamily: "Lora",
            color: AppColors.darkBackground,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

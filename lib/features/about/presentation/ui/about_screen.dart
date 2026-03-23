import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/theme/app_colors.dart';
import '../core/about_text.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        const CircleAvatar(
          minRadius: 16,
          maxRadius: 64,
          backgroundImage: AssetImage('assets/images/ricarth.png'),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 16),
        MarkdownBody(
          data: aboutMarkdownText,
          selectable: true,
          fitContent: false,
          styleSheet: MarkdownStyleSheet(
            textAlign: WrapAlignment.center,
            h1Align: WrapAlignment.center,
            h2Align: WrapAlignment.center,
            p: const TextStyle(
              fontFamily: 'Lora',
              color: Colors.white,
              fontSize: 14,
            ),
            h1: const TextStyle(
              color: AppColors.glow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            h2: const TextStyle(
              color: AppColors.glow,
              fontFamily: 'Lora',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            horizontalRuleDecoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.glow.withOpacity(0.5)),
              ),
            ),
            a: const TextStyle(
              color: AppColors.main,
              decoration: TextDecoration.underline,
            ),
          ),
          onTapLink: (text, href, title) {
            if (href == '/privacy') {
              // Se o context vier do Dialog, usamos popAndPushNamed para fechar o dialog e abrir a tela
              Navigator.popAndPushNamed(context, "/privacy");
            } else if (href != null) {
              launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
            }
          },
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://twitter.com/soletreme"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Image.asset("assets/images/twitter-white.png", height: 32),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

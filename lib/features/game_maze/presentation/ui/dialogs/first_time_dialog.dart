import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../shared/theme/app_colors.dart';

void showFirstTimeDialog(BuildContext context) {
  showDialog(
    barrierColor: const Color.fromARGB(150, 0, 0, 0),
    context: context,
    builder: (context) => const _FirstTimeDialogWidget(),
  );
}

class _FirstTimeDialogWidget extends StatelessWidget {
  const _FirstTimeDialogWidget();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor:
          Colors.transparent, // Deixamos o Container colorir e fazer a borda
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glow, width: 8),
          color: AppColors.background,
        ),
        width: min(600, MediaQuery.of(context).size.width * 0.9),
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Faz o dialog ficar do tamanho exato do conteúdo
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              const Text(
                "Ligue letras adjacentes para formar uma palavra.",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lora',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Image.asset('assets/images/tutorial.gif', scale: 1.25),
              const SizedBox(height: 8),
              const Text(
                "Vença ao achar pelo menos uma palavra de cada tamanho.",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lora',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(
                height: 32,
              ), // Adicionei height para dar respiro automático
              const Text(
                "Desafios novos todos os dias às 5:00!",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lora',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glow,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: const Text(
        "COMO JOGAR?",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return InkWell(
      onTap: () {
        launchUrl(
          Uri.parse(
            "https://play.google.com/store/apps/details?id=lima.ricarth.flutter_aglomera",
          ),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Quer mais desafios por dia?",
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              "assets/images/google-play-badge.png",
              height: 48,
              isAntiAlias: true,
            ),
          ],
        ),
      ),
    );
  }
}

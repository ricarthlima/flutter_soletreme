import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../../../../core/initial_bindings.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../stores/game_store.dart';
import '../game_screen.dart';

void showWinDialog(BuildContext context) {
  showDialog(
    barrierColor: const Color.fromARGB(150, 0, 0, 0),
    context: context,
    builder: (context) => const WinDialogWidget(),
  );
}

class WinDialogWidget extends StatelessWidget {
  const WinDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    final now = DateTime.now();
    final nextMaze = DateTime(now.year, now.month, now.day + 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glow, width: 4),
          color: AppColors.darkBackground,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        width: min(MediaQuery.of(context).size.width * 0.975, 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildStatsTable(store),
              const SizedBox(height: 24),
              const Text(
                "Próximo desafio em:",
                style: TextStyle(color: AppColors.glow),
              ),
              _buildCountdown(context, nextMaze),
              const SizedBox(height: 24),
              _buildShareButton(context, store.generateShareText()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: const Text(
        "VITÓRIA",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildStatsTable(GameStore store) {
    return Table(
      children: [
        const TableRow(
          children: [
            Text(
              "Total de\nVitórias",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.glow, fontSize: 10),
            ),
            Text(
              "Total de\nPalavras",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.glow, fontSize: 10),
            ),
            Text(
              "Sequência\nVitórias",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.glow, fontSize: 10),
            ),
            Text(
              "Maior\nPalavra",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.glow, fontSize: 10),
            ),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 8),
            SizedBox(height: 8),
            SizedBox(height: 8),
            SizedBox(height: 8),
          ],
        ),
        TableRow(
          children: [
            Text(
              store.totalVictories.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              store.totalWordsAllTime.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              store.winStreak.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "${store.biggestWordAllTime}\n(${store.biggestWordAllTime.length})",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdown(BuildContext context, DateTime nextMaze) {
    return CountdownTimer(
      textStyle: const TextStyle(color: Colors.white, fontSize: 24),
      endTime: nextMaze.millisecondsSinceEpoch,
      endWidget: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
          );
        },
        child: const Text("Clique para jogar!"),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context, String copyText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.main,
        foregroundColor: Colors.black,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: copyText));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Copiado! Joga no Twitter! :D")),
        );
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, size: 18),
          SizedBox(width: 8),
          Text("Compartilhar"),
        ],
      ),
    );
  }
}

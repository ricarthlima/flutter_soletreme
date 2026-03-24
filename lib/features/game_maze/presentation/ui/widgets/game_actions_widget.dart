import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/initial_bindings.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../stores/game_store.dart';
import '../dialogs/win_dialog.dart';

class GameActionsWidget extends StatelessWidget {
  const GameActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    return Observer(
      builder: (_) {
        final totalWords = store.currentGame?.listWordsFound.length ?? 0;
        final isWinned = store.isWinned;

        return Column(
          spacing: 16,
          children: [
            IconButton(
              onPressed: store.clearCurrentPlay,
              icon: const Icon(Icons.delete, color: AppColors.border),
            ),
            InkWell(
              onTap: isWinned
                  ? () {
                      showWinDialog(context);
                    }
                  : null,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: !isWinned ? AppColors.glow : AppColors.main,
                    width: 2,
                  ),
                  color: AppColors.darkBackground,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$totalWords palavras",
                      style: TextStyle(
                        fontSize: 13,
                        color: !isWinned ? Colors.white : AppColors.main,
                      ),
                    ),
                    if (isWinned) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.share, color: AppColors.main, size: 18),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

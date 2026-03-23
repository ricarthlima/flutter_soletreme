import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/initial_bindings.dart';
import '../../../../shared/theme/app_colors.dart';
import '../stores/game_store.dart';

// Importe os seus novos widgets fatiados
import 'components/custom_app_bar.dart';
import 'dialogs/first_time_dialog.dart';
import 'dialogs/win_dialog.dart';
import 'widgets/game_grid_widget.dart';
import 'widgets/current_word_widget.dart';
import 'widgets/game_actions_widget.dart';
import 'widgets/results_table_widget.dart';
import 'widgets/game_footer_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameStore store = DI.instance<GameStore>();
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    super.initState();

    store.loadInitialData().then((_) {
      _checkDialogs();
    });

    // Reaction: Fica ouvindo o `isWinned` computado. Se virar true no meio da partida, abre o modal.
    _disposers = [
      reaction((_) => store.isWinned, (bool won) {
        if (won && mounted) {
          showWinDialog(context);
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var d in _disposers) {
      d();
    }
    super.dispose();
  }

  void _checkDialogs() {
    if (!mounted) return;

    if (!store.prefsEntity.isShowedFirstTimeMessage) {
      showFirstTimeDialog(context);
      store.setFirstTimeMessageShowed();
    }

    if (store.isWinned) {
      showWinDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // O Observer aqui fora só serve para escutar a mudança do isLoaded
    // e alternar entre a tela de carregamento e o jogo em si.
    return Observer(
      builder: (_) {
        // Tela de Loading
        if (!store.isLoaded) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    store.loadingText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        // Tela do Jogo
        return Scaffold(
          appBar: const CustomAppBar(),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                width: min(700, MediaQuery.of(context).size.width * 0.95),
                child: const Column(
                  children: [
                    SizedBox(height: 16),
                    GameGridWidget(),
                    SizedBox(height: 16),
                    CurrentWordWidget(),
                    GameActionsWidget(),
                    ResultsTableWidget(),
                    SizedBox(height: 16),
                    GameFooterWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

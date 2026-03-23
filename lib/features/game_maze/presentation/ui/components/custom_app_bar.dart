import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/initial_bindings.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../stores/game_store.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    return AppBar(
      title: const Text("soletre.me"),
      centerTitle: true,
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      toolbarHeight: 48,
      leading: IconButton(
        icon: const Icon(Icons.help, size: 16),
        onPressed: () {
          // TODO: showFirstTimeDialog(context);
        },
      ),
      actions: [
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse("https://twitter.com/soletreme"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset("assets/twitter-white.png"),
          ),
        ),
        Observer(
          builder: (_) => IconButton(
            onPressed: store.toggleSound,
            icon: Icon(
              store.prefsEntity.isSoundActive
                  ? Icons.music_note_sharp
                  : Icons.music_off,
              size: 16,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            //TODO: showAboutSoletremeDialog(context);
          },
          icon: const Icon(Icons.info, size: 16),
        ),
      ],
    );
  }
}

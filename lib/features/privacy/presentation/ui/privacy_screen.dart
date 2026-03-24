import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/theme/app_colors.dart';

const String _privacyTextPT = """
## Termos de Privacidade e Condições de Uso

O **soletre.me** tem o compromisso de respeitar a sua privacidade e garantir a segurança dos seus dados. 

Não realizamos a coleta de informações pessoais, não utilizamos cookies de rastreamento (*tracking*) e não compartilhamos dados com terceiros. As únicas informações registradas em nossos servidores são as palavras submetidas durante as partidas, armazenadas de forma estritamente anônima, com o único propósito de gerar as estatísticas globais e diárias do jogo.

Este é um jogo de caráter educativo, seguro e recomendado para pessoas de todas as idades. Caso identifique alguma irregularidade, falha ou tenha dúvidas, por favor, entre em contato através do e-mail: [ricarth.lima@gmail.com](mailto:ricarth.lima@gmail.com).
""";

const String _privacyTextEN = """
## Privacy Policy and Terms of Use

The **soletre.me** game is committed to respecting your privacy and ensuring the security of your data.

We do not collect any personal information, we do not use tracking cookies, and we do not share data with third parties. The only information recorded on our servers are the words submitted during gameplay, stored on a strictly anonymous basis, for the sole purpose of generating global and daily game statistics.

This is an educational game, safe and recommended for all ages. If you find any irregularities, encounter issues, or have any questions, please contact us via email: [ricarth.lima@gmail.com](mailto:ricarth.lima@gmail.com).
""";

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            // Volta para a tela inicial
            Navigator.pushReplacementNamed(context, "/");
          },
        ),
        title: const Text("soletre.me - Privacidade"),
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 48,
            runSpacing: 48,
            children: [
              _buildMarkdownBlock(context, _privacyTextPT),
              _buildMarkdownBlock(context, _privacyTextEN),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownBlock(BuildContext context, String markdownData) {
    return SizedBox(
      width: 500, // Limita a largura para leitura confortável
      child: MarkdownBody(
        data: markdownData,
        selectable: true,
        fitContent: false,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            fontFamily: 'Lora',
            color: Colors.white,
            fontSize: 16,
            height: 1.5, // Dá um respiro entre as linhas
          ),
          h2: const TextStyle(
            color: AppColors.glow,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          strong: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.main,
          ),
          a: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}

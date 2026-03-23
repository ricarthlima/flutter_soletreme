import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/audio/domain/repositories/audio_repository.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/maze_entity.dart';
import '../../domain/entities/player_prefs_entity.dart';
import '../../domain/repositories/maze_api_repository.dart';
import '../../domain/repositories/player_prefs_repository.dart';

part 'game_store.g.dart';

class GameStore = _GameStoreBase with _$GameStore;

abstract class _GameStoreBase with Store {
  final PlayerPrefsRepository _prefsRepo;
  final AudioRepository _audioRepo;
  final MazeApiRepository _mazeApiRepo;

  _GameStoreBase({
    required PlayerPrefsRepository prefsRepo,
    required AudioRepository audioRepo,
    required MazeApiRepository mazeApiRepo,
  }) : _prefsRepo = prefsRepo,
       _audioRepo = audioRepo,
       _mazeApiRepo = mazeApiRepo;

  // OBSERVABLES

  @observable
  bool isLoaded = false;

  @observable
  String loadingText = "Carregando...";

  @observable
  PlayerPrefsEntity prefsEntity = PlayerPrefsEntity();

  @observable
  GameEntity? currentGame;

  @observable
  String currentWord = '';

  @observable
  int lastClicked = -999;

  @observable
  bool isShowingFound = false;

  ObservableList<bool> gridClicked = ObservableList<bool>();
  ObservableList<int> listClickSequence = ObservableList<int>();

  List<String> listWordsNormalized = [];
  List<String> listWordsWellWrote = [];

  // COMPUTED

  /// Transforma a lista plana de palavras salvas no formato que a UI precisa separar por tamanho
  @computed
  Map<String, List<String>> get categorizedFounds {
    final Map<String, List<String>> map = {
      "3": [],
      "4": [],
      "5": [],
      "6": [],
      "7": [],
      "+": [],
    };

    if (currentGame == null) return map;

    for (String word in currentGame!.listWordsFound) {
      final int len = word.length;
      if (len == 3) {
        map["3"]!.add(word);
      } else if (len == 4) {
        map["4"]!.add(word);
      } else if (len == 5) {
        map["5"]!.add(word);
      } else if (len == 6) {
        map["6"]!.add(word);
      } else if (len == 7) {
        map["7"]!.add(word);
      } else {
        map["+"]!.add(word);
      }
    }
    return map;
  }

  /// Verifica se o jogador já venceu o jogo atual
  @computed
  bool get isWinned {
    final cat = categorizedFounds;
    return cat["3"]!.isNotEmpty &&
        cat["4"]!.isNotEmpty &&
        cat["5"]!.isNotEmpty &&
        cat["6"]!.isNotEmpty &&
        cat["7"]!.isNotEmpty;
  }

  @computed
  List<GameEntity> get wonGames {
    return prefsEntity.listGamesPlayed.where((game) {
      bool has3 = false, has4 = false, has5 = false, has6 = false, has7 = false;
      for (var w in game.listWordsFound) {
        if (w.length == 3) has3 = true;
        if (w.length == 4) has4 = true;
        if (w.length == 5) has5 = true;
        if (w.length == 6) has6 = true;
        if (w.length >= 7) has7 = true;
      }
      return has3 && has4 && has5 && has6 && has7;
    }).toList();
  }

  /// Total de Vitórias na vida da jogadora
  @computed
  int get totalVictories => wonGames.length;

  /// Soma de todas as palavras encontradas em todos os jogos
  @computed
  int get totalWordsAllTime {
    return prefsEntity.listGamesPlayed.fold(
      0,
      (sum, game) => sum + game.listWordsFound.length,
    );
  }

  /// Varre todo o histórico para achar a palavra mais longa já feita
  @computed
  String get biggestWordAllTime {
    String biggest = "";
    for (var game in prefsEntity.listGamesPlayed) {
      for (var word in game.listWordsFound) {
        if (word.length > biggest.length) biggest = word;
      }
    }
    return biggest;
  }

  /// Calcula a sequência ininterrupta de dias com vitória baseada no ID numérico do Maze
  @computed
  int get winStreak {
    if (wonGames.isEmpty) return 0;

    // A exata mesma data base que você usa no seu MazeApiService
    final DateTime startDate = DateTime(2026, 3, 23);

    // Converte os IDs numéricos de volta para datas reais
    final List<DateTime> dates = wonGames.map((g) {
      final int mazeId = int.parse(g.maze.id);
      return startDate.add(Duration(days: mazeId - 1));
    }).toList();

    // Ordena da mais recente para a mais antiga
    dates.sort((a, b) => b.compareTo(a));

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      // Como a startDate já tem a hora zerada (00:00:00),
      // somar dias nela garante que current e previous já estejam zerados!
      final DateTime current = dates[i];
      final DateTime previous = dates[i + 1];

      final int diffInDays = current.difference(previous).inDays;

      if (diffInDays == 1) {
        streak++; // Jogou em dias seguidos
      } else if (diffInDays == 0) {
        continue; // Jogou a mesma fase no mesmo dia (ignora para a contagem)
      } else {
        break; // Buraco de mais de 1 dia, quebrou a sequência
      }
    }
    return streak;
  }

  // ACTIONS

  /// Carrega as informações iniciais
  @action
  Future<void> loadInitialData() async {
    isLoaded = false;

    loadingText = "Lendo informações locais...";

    // 1. Carrega as preferências pelo Repositório injetado
    prefsEntity = await _prefsRepo.load();

    // 2. Carrega o dicionário
    await _loadWords();

    // 3. Verifica qual é o labirinto de hoje e carrega o cache
    await _loadOrCreateTodayGame();

    isLoaded = true;
  }

  @action
  Future<void> _loadWords() async {
    loadingText = "Carregando palavras...";
    final String csv = await rootBundle.loadString('assets/data/words.csv');
    for (String line in csv.split('\n')) {
      final List<String> col = line.trim().split(',');
      if (col.length >= 2) {
        listWordsNormalized.add(col[1].toLowerCase());
        listWordsWellWrote.add(col[0].toLowerCase());
      }
    }
  }

  @action
  Future<void> _loadOrCreateTodayGame() async {
    loadingText = "Baixando tabuleiro do dia...";

    try {
      // 1. Busca o labirinto real do dia na nossa API estática
      final MazeEntity todayMaze = await _mazeApiRepo.fetchTodayMaze();

      // 2. Procura na lista local se a pessoa já começou a jogar o labirinto de hoje
      final int index = prefsEntity.listGamesPlayed.indexWhere(
        (g) => g.id == todayMaze.id,
      );

      if (index != -1) {
        // Já começou hoje, só recupera o progresso de onde parou
        currentGame = prefsEntity.listGamesPlayed[index];
      } else {
        // Primeiro acesso do dia, cria um jogo
        currentGame = GameEntity(
          id: todayMaze.id,
          maze: todayMaze,
          listWordsFound: [],
        );

        final updatedList = List<GameEntity>.from(prefsEntity.listGamesPlayed)
          ..add(currentGame!);
        prefsEntity = prefsEntity.copyWith(listGamesPlayed: updatedList);

        // Salva no cache local
        await _prefsRepo.save(prefsEntity);
      }

      // 3. Limpa a seleção e monta o grid na tela com o tamanho exato do labirinto
      gridClicked.clear();
      todayMaze.maze.split('').forEach((_) => gridClicked.add(false));
    } catch (e) {
      loadingText = "Sem conexão. Verifique a internet e tente novamente.";
    }
  }

  @action
  void addChar({required String char, required int index}) {
    // Lógica de validação de clique nos vizinhos
    final int gridWidth = 8;
    final List<int> positions = [
      lastClicked,
      lastClicked + 1,
      lastClicked - 1,
      lastClicked - gridWidth,
      lastClicked + gridWidth,
      lastClicked - gridWidth - 1,
      lastClicked - gridWidth + 1,
      lastClicked + gridWidth - 1,
      lastClicked + gridWidth + 1,
    ];

    bool canClick = false;
    if (listClickSequence.isNotEmpty && listClickSequence.last == index) {
      canClick = true;
    } else if (positions.contains(index) && !gridClicked[index]) {
      canClick = true;
    } else if (lastClicked == -999) {
      canClick = true;
    }

    if (canClick) {
      if (prefsEntity.isSoundActive) {
        _audioRepo.playTouch();
      }

      if (gridClicked[index]) {
        currentWord = currentWord.substring(0, currentWord.length - 1);
        listClickSequence.removeLast();
        lastClicked = listClickSequence.isNotEmpty
            ? listClickSequence.last
            : -999;
      } else {
        currentWord += char;
        listClickSequence.add(index);
        lastClicked = index;
      }
      gridClicked[index] = !gridClicked[index];
      if (!gridClicked.contains(true)) lastClicked = -999;

      _checkWord();
    }
  }

  @action
  void _checkWord() {
    final String wordToCheck = currentWord.toLowerCase();

    if (listWordsNormalized.contains(wordToCheck)) {
      if (!currentGame!.listWordsFound.contains(wordToCheck)) {
        // 1. Atualiza o GameEntity (Imutável)
        final updatedWords = List<String>.from(currentGame!.listWordsFound)
          ..add(wordToCheck);
        currentGame = currentGame!.copyWith(listWordsFound: updatedWords);

        // 2. Atualiza a lista geral de jogos (Imutável)
        final updatedGames = prefsEntity.listGamesPlayed.map((g) {
          return g.id == currentGame!.id ? currentGame! : g;
        }).toList();

        prefsEntity = prefsEntity.copyWith(listGamesPlayed: updatedGames);

        // 3. Salva em cache imediatamente
        _prefsRepo.save(prefsEntity);

        isShowingFound = true;

        final wasWinnedBefore = isWinned;

        if (prefsEntity.isSoundActive) {
          if (!wasWinnedBefore && isWinned) {
            _audioRepo.playWin();
          } else {
            _audioRepo.playSuccess();
          }
        }

        Future.delayed(const Duration(milliseconds: 750)).then((_) {
          clearCurrentPlay();
        });
      }
    }
  }

  @action
  void clearCurrentPlay() {
    currentWord = "";
    for (int i = 0; i < gridClicked.length; i++) {
      gridClicked[i] = false;
    }
    lastClicked = -999;
    listClickSequence.clear();
    isShowingFound = false;
  }

  @action
  void toggleSound() {
    prefsEntity = prefsEntity.copyWith(
      isSoundActive: !prefsEntity.isSoundActive,
    );
    _prefsRepo.save(prefsEntity);
  }

  @action
  void setFirstTimeMessageShowed() {
    prefsEntity = prefsEntity.copyWith(isShowedFirstTimeMessage: true);
    _prefsRepo.save(prefsEntity);
  }

  @action
  String generateShareText() {
    if (currentGame == null) return "";

    final int totalFounds = currentGame!.listWordsFound.length;
    final String mazeId = currentGame!.maze.id;

    // Aqui você chama a sua função helper passando as palavras que ela encontrou hoje
    // String emojis = listToEmoji(currentGame!.listWordsFound, listWordsWellWrote);

    String copyText =
        "venci no soletre.me #$mazeId | 🔤 $totalFounds | ❤️‍🔥 $winStreak";

    // copyText += "\n$emojis";
    copyText += "\n#soletreme";

    return copyText;
  }
}

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/maze_entity.dart';
import '../../domain/entities/player_prefs_entity.dart';
import '../../domain/repositories/player_prefs_repository.dart';

part 'game_store.g.dart'; ////

class GameStore = _GameStoreBase with _$GameStore;

abstract class _GameStoreBase with Store {
  final PlayerPrefsRepository _prefsRepo;

  _GameStoreBase({required PlayerPrefsRepository prefsRepo})
    : _prefsRepo = prefsRepo;

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

  // COMPUTEDS

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
        listWordsWellWrote.add(
          col[0].toLowerCase(),
        ); // Opcional: pode usar pra formatar bonitinho depois
      }
    }
  }

  @action
  Future<void> _loadOrCreateTodayGame() async {
    loadingText = "Baixando tabuleiro...";

    // TODO: Buscar da API o Maze de hoje
    // Remover esse de exemplo
    final MazeEntity todayMaze = MazeEntity(
      id: "123",
      maze: "lrarrirnabuvidoaocigaafsatbmotoaagbeerig",
      date: DateTime.now(),
    );

    // Procura na lista de jogos salvos se já jogamos o de hoje
    final int index = prefsEntity.listGamesPlayed.indexWhere(
      (g) => g.id == todayMaze.id,
    );

    if (index != -1) {
      // Já existe, carrega o progresso!
      currentGame = prefsEntity.listGamesPlayed[index];
    } else {
      // É a primeira vez jogando hoje. Cria um novo GameEntity zerado.
      currentGame = GameEntity(
        id: todayMaze.id,
        maze: todayMaze,
        listWordsFound: [],
      );

      // Salva o novo jogo na lista de preferências
      final updatedList = List<GameEntity>.from(prefsEntity.listGamesPlayed)
        ..add(currentGame!);
      prefsEntity = prefsEntity.copyWith(listGamesPlayed: updatedList);
      await _prefsRepo.save(prefsEntity);
    }

    // Prepara o grid de cliques
    gridClicked.clear();
    todayMaze.maze.split('').forEach((_) => gridClicked.add(false));
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

        // TODO: Lógica de som aqui

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
}

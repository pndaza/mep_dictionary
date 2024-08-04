import 'package:flutter/foundation.dart';

import '../model/definition.dart';
import '../repository/definition_repo.dart';
import '../screen/home/widgets/search_bar.dart';
import '../services/favourites_service.dart';
import '../utils/mm_string_normalizer.dart';

enum DefinitionDisplayMode { all, favourite }

// enum DefinitionState { loading, loaded }

sealed class HomeState {}

class Loading extends HomeState {}

class Loaded extends HomeState {
  final List<Definition> definitions;
  Loaded(this.definitions);
}

class Empty extends HomeState {}

class HomeViewController {
  HomeViewController({
    required this.repository,
    required this.favouritesService,
  }) {
    _init();
  }

  final DefinitionRepository repository;
  final FavouritesService favouritesService;

  bool _isAllCached = false;

  final ValueNotifier<HomeState> _state = ValueNotifier<HomeState>(Loading());
  ValueListenable<HomeState> get state => _state;

  final ValueNotifier<DefinitionDisplayMode> _displayMode =
      ValueNotifier<DefinitionDisplayMode>(DefinitionDisplayMode.all);
  ValueListenable<DefinitionDisplayMode> get displayMode => _displayMode;

  final List<Definition> _allDefinitions = [];

  FilterMode _filterMode = FilterMode.anywhere;
  String? _filterWord;
  String? get filterWord => _filterWord;

  void _init() {
    // fetchs all definitions and caches
    final stopwatch = Stopwatch()..start();

    repository.fetchAll().then((definitions) {
      _allDefinitions.addAll(definitions);
      _isAllCached = true;
      _state.value = Loaded(definitions);
      stopwatch.stop();
      debugPrint('Execution time: ${stopwatch.elapsed}');
    });
  }

  void onFilterWordChanged(String filteredWord) {
    _filterWord = filteredWord; // cache
    final currentDisplayMode = _displayMode.value;

    if (!_isAllCached) return;
    if (filteredWord.isEmpty &&
        currentDisplayMode == DefinitionDisplayMode.all) {
      _state.value = Loaded(_allDefinitions);
      return;
    }
    if (filteredWord.isEmpty &&
        currentDisplayMode == DefinitionDisplayMode.favourite) {
      final definitions = _FavouriteHelper.getFavourites(
          _allDefinitions, favouritesService.favourites);
      if (definitions.isEmpty) {
        _state.value = Empty();
      } else {
        _state.value = Loaded(definitions);
      }
      return;
    }

    List<Definition> filterdDefinitions = [];
    final source = currentDisplayMode == DefinitionDisplayMode.all
        ? _allDefinitions
        : _FavouriteHelper.getFavourites(
            _allDefinitions, favouritesService.favourites);
    if (_FilterHelper.isEnglishWord(filteredWord)) {
      filterdDefinitions =
          _FilterHelper.filterOnEnglish(source, filteredWord, _filterMode);
    } else {
      filterdDefinitions =
          _FilterHelper.filterOnOther(source, filteredWord, _filterMode);
    }

    if (filterdDefinitions.isEmpty) {
      _state.value = Empty();
    } else {
      _state.value = Loaded(filterdDefinitions);
    }
  }

  void onFilterModeChanged(FilterMode filterMode) {
    // update filterWord state
    _filterMode = filterMode; // cache
  }

  void onDisplayModeChanged() {
    // _state.value = Loading();
    final currentDisplayMode = _displayMode.value;
    if (currentDisplayMode == DefinitionDisplayMode.all) {
      _displayMode.value = DefinitionDisplayMode.favourite;
      final favourites = _FavouriteHelper.getFavourites(
          _allDefinitions, favouritesService.favourites);
      if (favourites.isEmpty) {
        _state.value = Empty();
      } else {
        _state.value = Loaded(_FavouriteHelper.getFavourites(
            _allDefinitions, favouritesService.favourites));
      }
    } else {
      _displayMode.value = DefinitionDisplayMode.all;
      _state.value = Loaded(_allDefinitions);
    }
  }

  void onFavouriteListChange() {
    if (_displayMode.value == DefinitionDisplayMode.favourite) {
      _state.value = Loaded(_FavouriteHelper.getFavourites(
          _allDefinitions, favouritesService.favourites));
    }
  }
}

class _FilterHelper {
  _FilterHelper._();
  static bool isEnglishWord(String word) => RegExp(r'[a-zA-Z]').hasMatch(word);

  static List<Definition> filterOnEnglish(List<Definition> definitions,
      String filteredWord, FilterMode filteredMode) {
    final filteredWordLC = filteredWord.toLowerCase();
    return definitions
        .where(
          (definition) => filteredMode == FilterMode.start
              ? definition.english.toLowerCase().startsWith(filteredWordLC)
              : definition.english.toLowerCase().contains(filteredWordLC),
        )
        .toList();
  }

  static List<Definition> filterOnOther(List<Definition> definitions,
      String filteredWord, FilterMode filteredMode) {
    final filteredWordNL = MMStringNormalizer.normalize(filteredWord);
    return definitions
        .where(
          (definition) => filteredMode == FilterMode.start
              ? definition.myanmar.startsWith(filteredWordNL) ||
                  definition.pali.replaceAll('.', '').startsWith(filteredWordNL)
              : definition.myanmar.contains(filteredWordNL) ||
                  definition.pali.replaceAll('.', '').contains(filteredWordNL),
        )
        .toList();
  }
}

class _FavouriteHelper {
  _FavouriteHelper._();
  static List<Definition> getFavourites(
      List<Definition> definitions, List<int> favourites) {
    return definitions
        .where((definition) => favourites.contains(definition.id))
        .toList();
  }
}

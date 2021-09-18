import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favourite_controller.dart';
import '../screen/home/widgets/search_bar.dart';
import '../model/definition.dart';
import '../services/database_provider.dart';
import '../repository/definition_repo.dart';
import '../utils/mm_string_normalizer.dart';

enum DisplayMode { all, favourite }
enum DefinitionState { loading, loaded }

final _filteredWordProvider = StateProvider<String>((_) => '');
final _filteredModeProvider =
    StateProvider<FilterMode>((_) => FilterMode.Anywhere);
final _displayModeProvider = StateProvider<DisplayMode>((_) => DisplayMode.all);

final _definitionRepoProvider =
    Provider((_) => DefinitionDatabaseRepository(DatabaseProvider()));
// hold all definitions
final _allDefinitionsProvider =
    StateProvider<List<Definition>>((_) => <Definition>[]);
//
final definitionsProvider = Provider<List<Definition>>((ref) {
  final filteredWord = ref.watch(_filteredWordProvider).state;
  final filteredMode = ref.watch(_filteredModeProvider).state;
  final displayMode = ref.watch(_displayModeProvider).state;
  final definitions = ref.watch(_allDefinitionsProvider).state;
  final favourites = ref.watch(favouritesProvider);

  if (displayMode == DisplayMode.favourite) {
    return _FavouriteHelper.getFavourites(definitions, favourites);
  }

  if (filteredWord.isEmpty) {
    return definitions;
  }

  if (_FilterHelper._isEnglishWord(filteredWord)) {
    return _FilterHelper._filterOnEnglish(
        definitions, filteredWord, filteredMode);
  } else {
    return _FilterHelper._filterOnOther(
        definitions, filteredWord, filteredMode);
  }
});

final homeViewControllerProvider =
    StateNotifierProvider<HomeViewController, DefinitionState>(
        (ref) => HomeViewController(ref.read));

class HomeViewController extends StateController<DefinitionState> {
  HomeViewController(this.read) : super(DefinitionState.loading) {
    _init();
  }
  final Reader read;

  DisplayMode get displayMode => read(_displayModeProvider).state;

  void _init() async {
    final repo = read(_definitionRepoProvider);
    // fetch all definions from database and save to definitions
    read(_allDefinitionsProvider).state = await repo.fetchAllDefinitions();
    state = DefinitionState.loaded;
  }

  void onTextChanged(String text) {
    // update filterWord state
    read(_filteredWordProvider).state = text;
  }

  void onModeChanged(FilterMode searchMode) {
    // update filterWord state
    read(_filteredModeProvider).state = searchMode;
  }

  String get textToHighlight => read(_filteredWordProvider).state;

  void onToggleDisplayMode() {
    final currentMode = read(_displayModeProvider).state;
    if (currentMode == DisplayMode.all) {
      read(_displayModeProvider).state = DisplayMode.favourite;
    } else {
      read(_displayModeProvider).state = DisplayMode.all;
    }
  }
}

class _FilterHelper {
  _FilterHelper._();
  static bool _isEnglishWord(String word) => RegExp(r'[a-zA-Z]').hasMatch(word);

  static List<Definition> _filterOnEnglish(List<Definition> definitions,
      String filteredWord, FilterMode filteredMode) {
    return definitions
        .where((definition) => filteredMode == FilterMode.Start
            ? definition.english.toLowerCase().startsWith(filteredWord)
            : definition.english.toLowerCase().contains(filteredWord))
        .toList();
  }

  static List<Definition> _filterOnOther(List<Definition> definitions,
      String filteredWord, FilterMode filteredMode) {
    filteredWord = MMStringNormalizer.normalize(filteredWord);
    return definitions
        .where((definition) => filteredMode == FilterMode.Start
            ? definition.myanmar.startsWith(filteredWord) ||
                definition.pali.startsWith(filteredWord)
            : definition.myanmar.contains(filteredWord) ||
                definition.pali.contains(filteredWord))
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

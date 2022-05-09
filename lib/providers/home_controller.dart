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
    StateProvider<FilterMode>((_) => FilterMode.anywhere);
final displayModeProvider =
    StateNotifierProvider<DisplayModeController, DisplayMode>(
        (ref) => DisplayModeController(ref.read));

final _definitionRepoProvider =
    Provider((_) => DefinitionDatabaseRepository(DatabaseProvider()));
// hold all definitions
final _allDefinitionsProvider =
    StateProvider<List<Definition>>((_) => <Definition>[]);
//
final definitionsProvider = Provider<List<Definition>>((ref) {
  final filteredWord = ref.watch(_filteredWordProvider);
  final filteredMode = ref.watch(_filteredModeProvider);
  final displayMode = ref.watch(displayModeProvider);
  final definitions = ref.watch(_allDefinitionsProvider);
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

class DisplayModeController extends StateNotifier<DisplayMode> {
  DisplayModeController(this.read) : super(DisplayMode.all);
  final Reader read;

  void onToggle() {
    state = state == DisplayMode.all ? DisplayMode.favourite : DisplayMode.all;
  }
}

class HomeViewController extends StateController<DefinitionState> {
  HomeViewController(this.read) : super(DefinitionState.loading) {
    _init();
  }
  final Reader read;

  bool _isAllCached = false;

  void _init() async {
    final repo = read(_definitionRepoProvider);
    // fetchs all definitions and caches
    read(_allDefinitionsProvider.notifier).state = await repo.fetchAll();
    state = DefinitionState.loaded;

    _isAllCached = true;
    // state = DefinitionState.loaded;
  }

  void onTextChanged(String text) {
    if (!_isAllCached) return;
    // update filterWord state
    read(_filteredWordProvider.notifier).state = text;
  }

  void onModeChanged(FilterMode searchMode) {
    // update filterWord state
    read(_filteredModeProvider.notifier).state = searchMode;
  }

  String get textToHighlight => read(_filteredWordProvider);
}

class _FilterHelper {
  _FilterHelper._();
  static bool _isEnglishWord(String word) => RegExp(r'[a-zA-Z]').hasMatch(word);

  static List<Definition> _filterOnEnglish(List<Definition> definitions,
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

  static List<Definition> _filterOnOther(List<Definition> definitions,
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/screen/home/favourite_controller.dart';

import './definition_state.dart';
import './widgets/search_bar.dart';
import '../../model/definition.dart';
import '../../services/database_provider.dart';
import '../../services/repository/definition_repo.dart';
import '../../utils/mm_string_normalizer.dart';

enum DefinitionDisplayMode { all, favourite }

final _filterWordProvider = StateProvider<String>((_) => '');
final _filterModeProvider =
    StateProvider<FilterMode>((_) => FilterMode.Anywhere);
final _definitionRepoProvider =
    Provider((ref) => DefinitionDatabaseRepository(DatabaseProvider()));
final _definitionsProvider = StateProvider<List<Definition>?>((ref) => null);

final homeControllerProvider =
    StateNotifierProvider<HomeController, DefinitionState>(
        (ref) => HomeController(ref.read));

class HomeController extends StateNotifier<DefinitionState> {
  HomeController(this.read) : super(DefinitionState.loading()) {
    _init();
  }
  final Reader read;

  void _init() async {
    final repo = read(_definitionRepoProvider);
    // fetch all definions from database and save to definitions
    read(_definitionsProvider).state = await repo.fetchAllDefinitions();
    state = DefinitionState.data(read(_definitionsProvider).state!);
  }

  void onTextChanged(String text) {
    // switch state to loading state before filtering
    state = DefinitionState.loading();
    // update filterWord state
    read(_filterWordProvider).state = text;
    // do filter
    final filteredDefintions = _doFilter();
    // updade state with filterd definitions
    state = DefinitionState.data(filteredDefintions);
  }

  void onModeChanged(FilterMode searchMode) {
    // switch state to loading state before filtering
    state = DefinitionState.loading();
    // update filterWord state
    read(_filterModeProvider).state = searchMode;
    // do filter
    final filteredDefintions = _doFilter();
    // updade state with filterd definitions
    state = DefinitionState.data(filteredDefintions);
  }

  List<Definition> _doFilter() {
    final definitions = read(_definitionsProvider).state!;
    final filterWord = read(_filterWordProvider).state.trim();
    final filterMode = read(_filterModeProvider).state;
    if (_isEnglishWord(filterWord)) {
      return _filterOnEnglish(definitions, filterWord, filterMode);
    } else {
      return _filterOnOther(definitions, filterWord, filterMode);
    }
  }

  bool _isEnglishWord(String word) => RegExp(r'[a-zA-Z]').hasMatch(word);

  List<Definition> _filterOnEnglish(
      List<Definition> definitions, String filterWord, FilterMode filterMode) {
    return definitions
        .where((definition) => filterMode == FilterMode.Start
            ? definition.english.toLowerCase().startsWith(filterWord)
            : definition.english.toLowerCase().contains(filterWord))
        .toList();
  }

  List<Definition> _filterOnOther(
      List<Definition> definitions, String filterWord, FilterMode filterMode) {
    filterWord = MMStringNormalizer.normalize(filterWord);
    return definitions
        .where((definition) => filterMode == FilterMode.Start
            ? definition.myanmar.startsWith(filterWord) ||
                definition.pali.startsWith(filterWord)
            : definition.myanmar.contains(filterWord) ||
                definition.pali.contains(filterWord))
        .toList();
  }

  String get textToHighlight => read(_filterWordProvider).state;

  DefinitionDisplayMode _definitionDisplayMode = DefinitionDisplayMode.all;
  DefinitionDisplayMode get definitionDisplayMode => _definitionDisplayMode;
  // bool _isFavouriteOnlyMode = false;
  // bool get isFavouriteOnlyMode => _isFavouriteOnlyMode;

  void onDisplayModeChanged() {
    state = DefinitionState.loading();
    // _isFavouriteOnlyMode = !_isFavouriteOnlyMode;
    if (_definitionDisplayMode == DefinitionDisplayMode.all) {
      // fetch favourite list
      _definitionDisplayMode = DefinitionDisplayMode.favourite;
      final favourites = read(favouritesProvider);
      //
      final favouriteDefintions = read(_definitionsProvider)
          .state!
          .where((e) => favourites.contains(e.id))
          .toList();
      //update state
      state = DefinitionState.data(favouriteDefintions);
    } else {
      _definitionDisplayMode = DefinitionDisplayMode.all;
      // update state
      state = DefinitionState.data(read(_definitionsProvider).state!);
    }
  }

  void switchToAllDisplayMode() {
    state = DefinitionState.loading();
    state = DefinitionState.data(read(_definitionsProvider).state!);
  }

  void switchToFavouriteDisplayMode() {
    state = DefinitionState.loading();
    final favourites = read(favouritesProvider);
    //
    final favouriteDefintions = read(_definitionsProvider)
        .state!
        .where((e) => favourites.contains(e.id))
        .toList();
    //update state
    state = DefinitionState.data(favouriteDefintions);
  }
  void onFavouriteListChange() {
    state = DefinitionState.loading();
    final favourites = read(favouritesProvider);
    //
    final favouriteDefintions = read(_definitionsProvider)
        .state!
        .where((e) => favourites.contains(e.id))
        .toList();
    //update state
    state = DefinitionState.data(favouriteDefintions);
  }
}

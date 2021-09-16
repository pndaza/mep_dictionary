import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mep_dictionary/screen/home/favourite_controller.dart';

import './definition_state.dart';
import './widgets/search_bar.dart';
import '../../model/definition.dart';
import '../../services/database_provider.dart';
import '../../services/repository/definition_repo.dart';
import '../../utils/mm_string_normalizer.dart';

final _searchTextProvider = StateProvider<String>((_) => '');
final _searchModeProvider =
    StateProvider<FilterMode>((_) => FilterMode.Anywhere);
final _definitionRepoProvider =
    Provider((ref) => DefinitionDatabaseRepository(DatabaseProvider()));
final _allDefinitionProvider = StateProvider<List<Definition>?>((ref) => null);
final _filterdDefinitionProvider = Provider<List<Definition>?>((ref) {
  final allDefinitions = ref.watch(_allDefinitionProvider).state;
  final filterWord = ref.watch(_searchTextProvider).state.trim();
  final filterMode = ref.watch(_searchModeProvider).state;
  final isEnglishReg = RegExp(r'[a-zA-Z]');

  if (allDefinitions == null) return null;
  if (allDefinitions.isEmpty) return allDefinitions;
  if (filterWord.isEmpty) return allDefinitions;

  // filtering
  if (isEnglishReg.hasMatch(filterWord)) {
    // filter word is english
    var _filterdWord = filterWord.toLowerCase();
    return allDefinitions
        .where((definition) => filterMode == FilterMode.Start
            ? definition.english.toLowerCase().startsWith(_filterdWord)
            : definition.english.toLowerCase().contains(_filterdWord))
        .toList();
  }

// filter word is myanmar or pali
  var _filterdWord = MMStringNormalizer.normalize(filterWord);
  return allDefinitions
      .where((definition) => filterMode == FilterMode.Start
          ? definition.myanmar.startsWith(_filterdWord) ||
              definition.pali.startsWith(_filterdWord)
          : definition.myanmar.contains(_filterdWord) ||
              definition.pali.contains(_filterdWord))
      .toList();
});

final homeControllerProvider =
    StateNotifierProvider<HomeController, DefinitionState>(
        (ref) => HomeController(ref.read));

class HomeController extends StateNotifier<DefinitionState> {
  HomeController(this.read) : super(DefinitionState.loading()) {
    _initState();
  }
  final Reader read;

  void _initState() async {
    final repo = read(_definitionRepoProvider);
    read(_allDefinitionProvider).state = await repo.fetchAllDefinitions();
    state = DefinitionState.data(read(_allDefinitionProvider).state!);
  }

  void onTextChanged(String text) {
    state = DefinitionState.loading();
    read(_searchTextProvider).state = text;
    state = DefinitionState.data(read(_filterdDefinitionProvider)!);
  }

  void onModeChanged(FilterMode searchMode) {
    state = DefinitionState.loading();
    read(_searchModeProvider).state = searchMode;
    state = DefinitionState.data(read(_filterdDefinitionProvider)!);
  }

  String get textToHighlight => read(_searchTextProvider).state;

  void onFavouritesClicked() {
    state = DefinitionState.loading();

    _isFavouriteMode = !_isFavouriteMode;
    if (_isFavouriteMode) {
      final favourites = read(favouritesProvider);
      state = DefinitionState.data(read(_allDefinitionProvider)
          .state!
          .where((e) => favourites.contains(e.id))
          .toList());
    } else {
      state = DefinitionState.data(read(_allDefinitionProvider).state!);
    }
  }

  bool _isFavouriteMode = false;
  bool get isFavouriteMode => _isFavouriteMode;
}

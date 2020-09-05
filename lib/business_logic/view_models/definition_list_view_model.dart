import 'package:flutter/material.dart';
import 'package:mep_dictionary/business_logic/model/definition.dart';
import 'package:mep_dictionary/services/database_provider.dart';
import 'package:mep_dictionary/services/repository/definition_repo.dart';
import 'package:mep_dictionary/utils/mm_string_normalizer.dart';

class DefinitionListViewModel extends ChangeNotifier {
  List<Definition> _allDefinitions = List<Definition>();
  List<DefinitionViewModel> definitions;

  Future<void> fetchAllDefinitions() async {
    if (_allDefinitions.isEmpty) {
      _allDefinitions = await DefinitionDatabaseRepository(DatabaseProvider())
          .fetchAllDefinitions();
    }
    definitions = fromList(_allDefinitions);
    notifyListeners();
  }

  void filterDefinitions(String filterWord, bool searchAtStart) {
    isEnglish(filterWord)
        ? filterOnEnglish(filterWord, searchAtStart)
        : filterOnOther(filterWord, searchAtStart);
  }

  void filterOnEnglish(String filterWord, bool searchAtStart) {
    final filtered = _allDefinitions
        .where((definition) => searchAtStart
            ? definition.eng.toLowerCase().startsWith(filterWord.toLowerCase())
            : definition.eng.toLowerCase().contains(filterWord.toLowerCase()))
        .toList();
    definitions = fromList(filtered, textToHighlight: filterWord);
    notifyListeners();
  }

  void filterOnOther(String filterWord, bool searchAtStart) {
    filterWord = MMStringNormalizer.normalize(filterWord);
    final filtered = _allDefinitions
        .where((definition) => searchAtStart
            ? definition.my.startsWith(filterWord) ||
                definition.pli.startsWith(filterWord)
            : definition.my.contains(filterWord) ||
                definition.pli.contains(filterWord))
        .toList();
    definitions = fromList(filtered, textToHighlight: filterWord);
    notifyListeners();
  }

  bool isEnglish(String filterWord) {
    return RegExp(r'[a-zA-Z]').hasMatch(filterWord);
  }

  List<DefinitionViewModel> fromList(List<Definition> definitions,
      {String textToHighlight = ''}) {
    return definitions
        .map((definition) =>
            DefinitionViewModel(definition, textToHighlight: textToHighlight))
        .toList();
  }
}

class DefinitionViewModel {
  final Definition _definition;
  final String textToHighlight;
  DefinitionViewModel(this._definition, {this.textToHighlight = ''});

  String get myanmar => this._definition.my;
  String get english => this._definition.eng;
  String get pali => this._definition.pli;
  
}

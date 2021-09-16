class Definition {
  int id;
  String myanmar;
  String english;
  String pali;

  Definition(this.id, this.myanmar, this.english, this.pali);

  factory Definition.fromMap(Map<String, dynamic> map) {
    return Definition(map['id'], map['my'], map['eng'], map['pli']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'my': myanmar,
      'eng': english,
      'pli': pali,
    };
  }
}

class DefinitionDao {
  final String tableName = 'definition';
  final String columnID = 'id';
  final String columnMyamar = 'my';
  final String columnEnglish = 'eng';
  final String columnPali = 'pli';

  List<Definition> fromList(List<Map<String, dynamic>> query) {
    return query.map((map) => fromMap(map)).toList();
  }

  Definition fromMap(Map<String, dynamic> map) {
    return Definition(
        map[columnID], map[columnMyamar], map[columnEnglish], map[columnPali]);
  }
}

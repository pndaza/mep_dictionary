class Definition {
  int id;
  String my;
  String eng;
  String pli;

  Definition(this.id, this.my, this.eng, this.pli);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'my': my,
      'eng': eng,
      'pli': pli,
    };
  }

  Definition.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.my = map['my'];
    this.eng = map['eng'];
    this.pli = map['pli'];
  }
}

class DefinitionDao {
  final String tableName = 'definition';
  final String columnID = 'id';
  final String columnMy = 'my';
  final String columnEng = 'eng';
  final String columnPli = 'pli';

  List<Definition> fromList(List<Map<String, dynamic>> query) {
    return query.map((map) => fromMap(map)).toList();
  }

  Definition fromMap(Map<String, dynamic> map) {
    return Definition(
        map[columnID], map[columnMy], map[columnEng], map[columnPli]);
  }
}

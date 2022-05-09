import 'package:flutter/material.dart';

@immutable
class Definition {
  final int id;
  final String myanmar;
  final String english;
  final String pali;
  final int pageNumber;

  const Definition(
    this.id,
    this.myanmar,
    this.english,
    this.pali,
    this.pageNumber,
  );

  factory Definition.fromMap(Map<String, dynamic> map) {
    return Definition(
      map['id'],
      map['my'],
      map['eng'],
      map['pli'],
      map['page_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'my': myanmar,
      'eng': english,
      'pli': pali,
      'page_number': pageNumber,
    };
  }
}

class DefinitionDao {
  final String tableName = 'definition';
  final String columnID = 'id';
  final String columnMyamar = 'my';
  final String columnEnglish = 'eng';
  final String columnPali = 'pli';
  final String columnPageNumber = 'page_number';

  List<Definition> fromList(List<Map<String, dynamic>> query) {
    return query.map((map) => fromMap(map)).toList();
  }

  Definition fromMap(Map<String, dynamic> map) {
    return Definition(
      map[columnID] as int,
      map[columnMyamar],
      map[columnEnglish],
      map[columnPali],
      map[columnPageNumber] as int,
    );
  }
}

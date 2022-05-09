import '/model/definition.dart';
import '../services/database_provider.dart';

abstract class DefinitionRepository {
  late final DatabaseProvider databaseProvider;
  Future<List<Definition>> fetchAll();
  Future<List<Definition>> fetchFirst100();
}

class DefinitionDatabaseRepository implements DefinitionRepository {
  final dao = DefinitionDao();

  @override
  DatabaseProvider databaseProvider;
  DefinitionDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Definition>> fetchAll() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> results = await db.query(dao.tableName,
        columns: [
          dao.columnID,
          dao.columnMyamar,
          dao.columnEnglish,
          dao.columnPali
        ]);
    return dao.fromList(results);
  }

  @override
  Future<List<Definition>> fetchFirst100() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> results = await db.query(
      dao.tableName,
      columns: [
        dao.columnID,
        dao.columnMyamar,
        dao.columnEnglish,
        dao.columnPali
      ],
      limit: 100,
    );
    return dao.fromList(results);
  }
}

import '/model/definition.dart';
import '../services/database_provider.dart';

abstract class DefinitionRepository {
  late final DatabaseProvider databaseProvider;
  Future<List<Definition>> fetchAll();
}

class DefinitionDatabaseRepository implements DefinitionRepository {
  final dao = DefinitionDao();

  @override
  DatabaseProvider databaseProvider;
  DefinitionDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Definition>> fetchAll() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> results = await db.query(
      dao.tableName,
      columns: [
        dao.columnID,
        dao.columnMyamar,
        dao.columnEnglish,
        dao.columnPali,
        dao.columnPageNumber
      ],
      // where: '${dao.columnPageNumber} > ?',
      // whereArgs: [1060],
    );
    return dao.fromList(results);
  }
}

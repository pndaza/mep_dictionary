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
    final List<Definition> definitions = [];
    const int chunkSize = 5000; // Number of rows to fetch at a time
    int offset = 0;
    while (true) {
      final List<Map<String, dynamic>> results = await db.query(dao.tableName,
          columns: [
            dao.columnID,
            dao.columnMyamar,
            dao.columnEnglish,
            dao.columnPali,
            dao.columnPageNumber
          ],
          limit: chunkSize,
          offset: offset
          // where: '${dao.columnPageNumber} > ?',
          // whereArgs: [1060],
          );
      if (results.isEmpty) {
        break; // No more data to fetch
      }
      definitions.addAll(dao.fromList(results));
    offset += chunkSize;
    }

    return definitions;
  }
}

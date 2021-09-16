import '/model/definition.dart';
import '../database_provider.dart';

abstract class DefinitionRepository {
  late final DatabaseProvider databaseProvider;
  Future<List<Definition>> fetchAllDefinitions();
}

class DefinitionDatabaseRepository implements DefinitionRepository {
  final dao = DefinitionDao();
  
  @override
  DatabaseProvider databaseProvider;
  DefinitionDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Definition>> fetchAllDefinitions() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>>results = await db.query(dao.tableName,
        columns: [dao.columnID, dao.columnMyamar, dao.columnEnglish, dao.columnPali]);
    return dao.fromList(results);
  }
}

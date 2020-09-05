import 'package:mep_dictionary/business_logic/model/definition.dart';
import 'package:mep_dictionary/services/database_provider.dart';

abstract class DefinitionRepository {
  DatabaseProvider databaseProvider;
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
    final results = await db.query(dao.tableName,
        columns: [dao.columnMy, dao.columnEng, dao.columnPli]);
    return dao.fromList(results);
  }
}

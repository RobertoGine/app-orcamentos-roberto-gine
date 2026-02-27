import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<void> atualizarOrcamento({
    required int id,
    required double total,
    required double desconto,
    required double km,
    required double custoKm,
    required double almoco,
    required List<Map<String, dynamic>> itens,
  }) async {
    final db = await instance.database;

    await db.update(
      'orcamentos',
      {
        'total': total,
        'desconto': desconto,
        'km': km,
        'custo_km': custoKm,
        'almoco': almoco,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Remove itens antigos
    await db.delete('itens', where: 'orcamento_id = ?', whereArgs: [id]);

    // Insere novos itens
    for (var item in itens) {
      await db.insert('itens', {
        'orcamento_id': id,
        'descricao': item['descricao'],
        'valor': item['valor'],
      });
    }
  }

  Future<void> excluirOrcamento(int id) async {
    final db = await instance.database;

    // Exclui itens vinculados primeiro
    await db.delete('itens', where: 'orcamento_id = ?', whereArgs: [id]);

    // Depois exclui o orçamento
    await db.delete('orcamentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final db = await instance.database;

    return await db.query('orcamentos', orderBy: 'id DESC');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orcamentos.db');
    return _database!;
  }

  Future<List<Map<String, dynamic>>> buscarItensPorOrcamento(
    int orcamentoId,
  ) async {
    final db = await instance.database;

    return await db.query(
      'itens',
      where: 'orcamento_id = ?',
      whereArgs: [orcamentoId],
    );
  }

  Future<Map<String, dynamic>> buscarOrcamentoPorId(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'orcamentos',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.first;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<String> gerarNumeroOrcamento() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT MAX(id) as ultimo_id FROM orcamentos',
    );

    int ultimoId = result.first['ultimo_id'] as int? ?? 0;

    int proximo = ultimoId + 1;

    return "ORC-${proximo.toString().padLeft(4, '0')}";
  }

  Future<int> salvarOrcamento({
    required String numero,
    required String cliente,
    required String data,
    required double total,
    required double desconto,
    required double km,
    required double custoKm,
    required double almoco,
    required List<Map<String, dynamic>> itens,
  }) async {
    final db = await instance.database;

    // Salva orçamento
    final orcamentoId = await db.insert('orcamentos', {
      'numero': numero,
      'cliente': cliente,
      'data': data,
      'total': total,
      'desconto': desconto,
      'km': km,
      'custo_km': custoKm,
      'almoco': almoco,
    });

    // Salva itens vinculados
    for (var item in itens) {
      await db.insert('itens', {
        'orcamento_id': orcamentoId,
        'descricao': item['descricao'],
        'valor': item['valor'],
      });
    }

    return orcamentoId;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orcamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL,
        cliente TEXT NOT NULL,
        data TEXT NOT NULL,
        total REAL NOT NULL,
        desconto REAL NOT NULL,
        km REAL NOT NULL,
        custo_km REAL NOT NULL,
        almoco REAL NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE itens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orcamento_id INTEGER NOT NULL,
      descricao TEXT NOT NULL,
      valor REAL NOT NULL,
      FOREIGN KEY (orcamento_id) REFERENCES orcamentos (id)
    )
  ''');
  }
}

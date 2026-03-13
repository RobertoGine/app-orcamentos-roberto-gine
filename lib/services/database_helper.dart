import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ===============================
  // DATABASE INSTANCE
  // ===============================

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orcamentos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> excluirListaMaterial(int id) async {
    final db = await database;

    await db.delete(
      'listas_material',
      where: 'id = ?',
      whereArgs: [id],
    );

    await db.delete(
      'itens_material',
      where: 'lista_id = ?',
      whereArgs: [id],
    );
  }

  // ===============================
  // CRIAR BANCO
  // ===============================

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
        almoco REAL NOT NULL,
        status TEXT NOT NULL
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

    await db.execute('''
      CREATE TABLE configuracoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_empresa TEXT,
        telefone TEXT,
        email TEXT,
        logo_path TEXT
      )
    ''');
    await db.execute('''
    CREATE TABLE listas_material (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cliente TEXT,
      numero_orcamento TEXT,
      data TEXT,
      observacao TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE itens_material (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lista_id INTEGER,
      descricao TEXT,
      quantidade REAL,
      unidade TEXT
    )
    ''');
  }

  // ===============================
  // ORÇAMENTOS
  // ===============================

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
    required String status,
  }) async {
    final db = await instance.database;

    final orcamentoId = await db.insert('orcamentos', {
      'numero': numero,
      'cliente': cliente,
      'data': data,
      'total': total,
      'desconto': desconto,
      'km': km,
      'custo_km': custoKm,
      'almoco': almoco,
      'status': status,
    });

    for (var item in itens) {
      await db.insert('itens', {
        'orcamento_id': orcamentoId,
        'descricao': item['descricao'],
        'valor': item['valor'],
      });
    }

    return orcamentoId;
  }

  Future<int> criarListaMaterial(
    String cliente,
    String? numeroOrcamento,
    String observacao,
  ) async {
    final db = await database;

    return await db.insert(
      'listas_material',
      {
        'cliente': cliente,
        'numero_orcamento': numeroOrcamento,
        'observacao': observacao,
        'data': DateTime.now().toString(),
      },
    );
  }

  Future<void> inserirItemMaterial(Map<String, dynamic> item) async {
    final db = await database;

    await db.insert('itens_material', item);
  }

  Future<List<Map<String, dynamic>>> buscarListasMaterial() async {
    final db = await database;

    return await db.query(
      'listas_material',
      orderBy: 'data DESC',
    );
  }

  Future<List<Map<String, dynamic>>> buscarItensLista(int listaId) async {
    final db = await database;

    return await db.query(
      'itens_material',
      where: 'lista_id = ?',
      whereArgs: [listaId],
    );
  }

  Future<void> atualizarOrcamento({
    required int id,
    required double total,
    required double desconto,
    required double km,
    required double custoKm,
    required double almoco,
    required List<Map<String, dynamic>> itens,
    required String status,
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
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    await db.delete('itens', where: 'orcamento_id = ?', whereArgs: [id]);

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

    await db.delete('itens', where: 'orcamento_id = ?', whereArgs: [id]);
    await db.delete('orcamentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> listarOrcamentos() async {
    final db = await instance.database;

    return await db.query('orcamentos', orderBy: 'id DESC');
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

  Future<Map<String, dynamic>> buscarListaPorId(int id) async {
    final db = await database;

    final result = await db.query(
      'listas_material',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.first;
  }

  // ===============================
  // NUMERO AUTOMÁTICO
  // ===============================

  Future<String> gerarNumeroOrcamento() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT MAX(id) as ultimo_id FROM orcamentos',
    );

    int ultimoId = result.first['ultimo_id'] as int? ?? 0;

    int proximo = ultimoId + 1;

    return "ORC-${proximo.toString().padLeft(4, '0')}";
  }

  // ===============================
  // CONFIGURAÇÕES
  // ===============================

  Future<void> salvarConfiguracoes({
    required String nomeEmpresa,
    required String telefone,
    required String email,
    required String? logoPath,
  }) async {
    final db = await instance.database;

    await db.delete('configuracoes');

    await db.insert('configuracoes', {
      'nome_empresa': nomeEmpresa,
      'telefone': telefone,
      'email': email,
      'logo_path': logoPath,
    });
  }

  Future<Map<String, dynamic>?> buscarConfiguracoes() async {
    final db = await instance.database;

    final result = await db.query('configuracoes');

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // ===============================
  // DASHBOARD
  // ===============================

  Future<List<Map<String, dynamic>>> buscarOrcamentosDoMes(
    int mes,
    int ano,
  ) async {
    final db = await instance.database;

    return await db.rawQuery(
      '''
      SELECT * FROM orcamentos
      WHERE strftime('%m', substr(data,7,4) || '-' || substr(data,4,2) || '-' || substr(data,1,2)) = ?
      AND strftime('%Y', substr(data,7,4) || '-' || substr(data,4,2) || '-' || substr(data,1,2)) = ?
      ''',
      [mes.toString().padLeft(2, '0'), ano.toString()],
    );
  }

  Future<void> marcarComoFechado(int id) async {
    final db = await instance.database;

    await db.update(
      'orcamentos',
      {'status': 'FECHADO'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> atualizarStatus(int id, String status) async {
    final db = await instance.database;

    await db.update(
      'orcamentos',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<double>> faturamentoMensal() async {
    final db = await database;

    final result = await db.rawQuery('''
  SELECT strftime('%m', data) as mes, SUM(valor) as total
  FROM orcamentos
  WHERE status = 'fechado'
  GROUP BY mes
  ORDER BY mes
  ''');

    return result.map((e) => (e['total'] as num).toDouble()).toList();
  }
}

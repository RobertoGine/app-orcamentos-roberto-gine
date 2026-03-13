import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import 'lista_material_screen.dart';
import 'visualizar_lista_screen.dart';

class HistoricoListaScreen extends StatefulWidget {
  const HistoricoListaScreen({super.key});

  @override
  State<HistoricoListaScreen> createState() => _HistoricoListaScreenState();
}

class _HistoricoListaScreenState extends State<HistoricoListaScreen> {
  List listas = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await DatabaseHelper.instance.buscarListasMaterial();

    setState(() {
      listas = dados;
    });
  }

  void confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Lista"),
          content: const Text(
            "Deseja realmente excluir esta lista de material?",
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text("Excluir"),
              onPressed: () async {
                await DatabaseHelper.instance.excluirListaMaterial(id);

                Navigator.pop(context);

                carregar();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> abrirVisualizacao(lista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VisualizarListaScreen(
          listaId: lista['id'],
          numeroOrcamento: lista['numero_orcamento'],
          cliente: lista['cliente'],
        ),
      ),
    );

    carregar();
  }

  Future<void> abrirEdicao(lista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaMaterialScreen(
          cliente: lista['cliente'],
          numeroOrcamento: lista['numero_orcamento'],
        ),
      ),
    );

    carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Listas"),
      ),
      body: listas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma lista de material encontrada",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: listas.length,
              itemBuilder: (context, index) {
                final lista = listas[index];

                final cliente = lista['cliente'] ?? "Cliente";
                final numero = lista['numero_orcamento'] ?? "";
                final data = lista['data'] ?? "";

                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      cliente,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (numero.isNotEmpty) Text("Orçamento: $numero"),
                        if (data.isNotEmpty) Text("Data: $data"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// VISUALIZAR
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          tooltip: "Visualizar",
                          onPressed: () => abrirVisualizacao(lista),
                        ),

                        /// EDITAR
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: "Editar",
                          onPressed: () => abrirEdicao(lista),
                        ),

                        /// EXCLUIR
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          tooltip: "Excluir",
                          onPressed: () {
                            confirmarExclusao(lista['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

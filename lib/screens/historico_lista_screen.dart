import 'package:flutter/material.dart';

import '../services/database_helper.dart';
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

  void carregar() async {
    final dados = await DatabaseHelper.instance.buscarListasMaterial();

    setState(() {
      listas = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Listas"),
      ),
      body: ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, index) {
          final lista = listas[index];

          return Card(
            child: ListTile(
              title: Text(lista['cliente'] ?? "Cliente"),
              subtitle: Text(lista['numero_orcamento'] ?? ""),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisualizarListaScreen(
                      listaId: lista['id'],
                      numeroOrcamento: lista['numero_orcamento'],
                      cliente: lista['cliente'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

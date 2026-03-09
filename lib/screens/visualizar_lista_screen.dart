import 'package:flutter/material.dart';

import '../models/material_model.dart';
import '../services/database_helper.dart';
import '../services/pdf_lista_material_service.dart';

class VisualizarListaScreen extends StatefulWidget {
  final int listaId;
  final String? numeroOrcamento;
  final String? cliente;

  const VisualizarListaScreen({
    super.key,
    required this.listaId,
    this.numeroOrcamento,
    this.cliente,
  });

  @override
  State<VisualizarListaScreen> createState() => _VisualizarListaScreenState();
}

class _VisualizarListaScreenState extends State<VisualizarListaScreen> {
  List<MaterialItem> itens = [];

  @override
  void initState() {
    super.initState();
    carregarItens();
  }

  void carregarItens() async {
    final dados =
        await DatabaseHelper.instance.buscarItensLista(widget.listaId);

    setState(() {
      itens = dados.map((e) => MaterialItem.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Materiais"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.descricao),
                      subtitle: Text(
                        "${item.quantidade} ${item.unidade}",
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                PdfListaMaterialService.gerarPdf(
                  numeroOrcamento: widget.numeroOrcamento ?? "",
                  cliente: widget.cliente ?? "",
                  itens: itens,
                );
              },
              child: const Text("Gerar PDF"),
            ),
          ],
        ),
      ),
    );
  }
}

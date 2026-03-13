import 'package:flutter/material.dart';

import '../models/material_model.dart';
import '../services/database_helper.dart';
import '../services/pdf_lista_material_service.dart';
import 'lista_material_screen.dart';

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
  String observacao = "";

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  /// CARREGAR LISTA
  void carregarDados() async {
    final lista =
        await DatabaseHelper.instance.buscarListaPorId(widget.listaId);

    final itensBanco =
        await DatabaseHelper.instance.buscarItensLista(widget.listaId);

    setState(() {
      observacao = lista['observacao'] ?? "";

      itens = itensBanco.map((e) => MaterialItem.fromMap(e)).toList();
    });
  }

  /// EXCLUIR LISTA
  void confirmarExclusao() {
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
                await DatabaseHelper.instance
                    .excluirListaMaterial(widget.listaId);

                Navigator.pop(context);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// EDITAR LISTA
  void editarLista() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaMaterialScreen(
          cliente: widget.cliente,
          numeroOrcamento: widget.numeroOrcamento,
        ),
      ),
    );

    carregarDados();
  }

  /// GERAR PDF
  void gerarPdf() {
    PdfListaMaterialService.gerarPdf(
      numeroOrcamento: widget.numeroOrcamento ?? "",
      cliente: widget.cliente ?? "",
      itens: itens,
      observacao: observacao,
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CLIENTE
            if (widget.cliente != null) ...[
              const Text(
                "Cliente",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.cliente!),
              const SizedBox(height: 10),
            ],

            /// ORÇAMENTO
            if (widget.numeroOrcamento != null) ...[
              Text(
                "Orçamento: ${widget.numeroOrcamento}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Divider(),

            const SizedBox(height: 10),

            /// MATERIAIS
            const Text(
              "Materiais",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

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

            /// OBSERVAÇÃO
            if (observacao.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "Observação",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(observacao),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),

      /// BOTÕES FIXOS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar"),
                  onPressed: editarLista,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("PDF"),
                  onPressed: gerarPdf,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Excluir"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: confirmarExclusao,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orcamento_app/screens/historico_lista_screen.dart';
import 'package:orcamento_app/services/database_helper.dart';
import 'package:orcamento_app/services/pdf_lista_material_service.dart';

import '../models/material_model.dart';
import 'visualizar_lista_screen.dart';

class ListaMaterialScreen extends StatefulWidget {
  final String? cliente;
  final String? numeroOrcamento;

  const ListaMaterialScreen({
    super.key,
    this.cliente,
    this.numeroOrcamento,
  });

  @override
  State<ListaMaterialScreen> createState() => _ListaMaterialScreenState();
}

class _ListaMaterialScreenState extends State<ListaMaterialScreen> {
  final clienteController = TextEditingController();
  final observacaoController = TextEditingController();
  final descricaoController = TextEditingController();
  final quantidadeController = TextEditingController();

  String unidade = "Peças";

  List<MaterialItem> itens = [];

  @override
  void initState() {
    super.initState();

    if (widget.cliente != null) {
      clienteController.text = widget.cliente!;
    }
  }

  void adicionarMaterial() {
    if (descricaoController.text.isEmpty || quantidadeController.text.isEmpty) {
      return;
    }

    final item = MaterialItem(
      descricao: descricaoController.text,
      quantidade: double.parse(quantidadeController.text),
      unidade: unidade,
    );

    setState(() {
      itens.add(item);
    });

    descricaoController.clear();
    quantidadeController.clear();
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
    });
  }

  void editarItem(int index) {
    final item = itens[index];

    descricaoController.text = item.descricao;
    quantidadeController.text = item.quantidade.toString();
    unidade = item.unidade;

    setState(() {
      itens.removeAt(index);
    });
  }

  void salvarLista() async {
    final cliente =
        clienteController.text.isEmpty ? "Cliente" : clienteController.text;

    final listaId = await DatabaseHelper.instance.criarListaMaterial(
      cliente,
      widget.numeroOrcamento,
      observacaoController.text,
    );

    for (var item in itens) {
      await DatabaseHelper.instance.inserirItemMaterial({
        'lista_id': listaId,
        'descricao': item.descricao,
        'quantidade': item.quantidade,
        'unidade': item.unidade,
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VisualizarListaScreen(
          listaId: listaId,
          numeroOrcamento: widget.numeroOrcamento,
          cliente: clienteController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Materiais"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Histórico de Listas",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoricoListaScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CLIENTE
              const Text(
                "Cliente",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              TextField(
                controller: clienteController,
                decoration: const InputDecoration(
                  hintText: "Nome do cliente",
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              /// ADICIONAR MATERIAL
              const Text(
                "Adicionar Material",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição do Material",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantidade",
                ),
              ),

              const SizedBox(height: 10),

              DropdownButton<String>(
                value: unidade,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: "Peças",
                    child: Text("Peças"),
                  ),
                  DropdownMenuItem(
                    value: "Metros",
                    child: Text("Metros"),
                  ),
                  DropdownMenuItem(
                    value: "Barras",
                    child: Text("Barras"),
                  ),
                  DropdownMenuItem(
                    value: "Rolos",
                    child: Text("Rolos"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    unidade = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: adicionarMaterial,
                child: const Text("Adicionar Material"),
              ),

              const SizedBox(height: 20),

              const Divider(),

              /// LISTA DE MATERIAIS
              const Text(
                "Materiais adicionados",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.descricao),
                      subtitle: Text(
                        "${item.quantidade} ${item.unidade}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editarItem(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removerItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Divider(),

              /// OBSERVAÇÃO
              const Text(
                "Observação",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: observacaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Ex: comprar disjuntor da marca Steck",
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
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
                child: ElevatedButton(
                  onPressed: salvarLista,
                  child: const Text("Salvar Lista"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (itens.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Adicione materiais antes"),
                        ),
                      );

                      return;
                    }

                    PdfListaMaterialService.gerarPdf(
                      numeroOrcamento: widget.numeroOrcamento ?? "",
                      cliente: clienteController.text,
                      itens: itens,
                      observacao: observacaoController.text,
                    );
                  },
                  child: const Text("Gerar PDF"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

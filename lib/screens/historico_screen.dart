import 'package:flutter/material.dart';

import '../services/database_helper.dart';
import 'itens_screen.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Map<String, dynamic>> orcamentos = [];

  @override
  void initState() {
    super.initState();
    carregarOrcamentos();
  }

  Future<void> carregarOrcamentos() async {
    final lista = await DatabaseHelper.instance.listarOrcamentos();

    setState(() {
      orcamentos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Orçamentos")),
      body: orcamentos.isEmpty
          ? const Center(child: Text("Nenhum orçamento encontrado."))
          : ListView.builder(
              itemCount: orcamentos.length,
              itemBuilder: (context, index) {
                final item = orcamentos[index];

                return ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cliente: ${item['cliente']}"),
                      Text(
                        "Total: R\$ ${item['total'].toStringAsFixed(2).replaceAll('.', ',')}",
                      ),
                      if (item['desconto'] > 0)
                        Text(
                          "Desconto: R\$ ${item['desconto'].toStringAsFixed(2).replaceAll('.', ',')}",
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "R\$ ${item['total'].toStringAsFixed(2).replaceAll('.', ',')}",
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmar = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Excluir Orçamento"),
                              content: const Text(
                                "Tem certeza que deseja excluir este orçamento?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Excluir",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmar == true) {
                            await DatabaseHelper.instance.excluirOrcamento(
                              item['id'],
                            );

                            await carregarOrcamentos();
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItensScreen(
                          nomeCliente: item['cliente'],
                          orcamentoId: item['id'],
                          numeroOrcamento: item['numero'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

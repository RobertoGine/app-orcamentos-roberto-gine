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
  String filtroStatus = "TODOS";
  String busca = "";

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

  Widget _botaoFiltro(String status) {
    final ativo = filtroStatus == status;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ativo ? const Color(0xFF0D47A1) : Colors.grey[300],
          foregroundColor: ativo ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            filtroStatus = status;
          });
        },
        child: Text(status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listaFiltrada = orcamentos.where((orc) {
      final statusMatch =
          filtroStatus == "TODOS" || orc['status'] == filtroStatus;

      final buscaMatch =
          orc['cliente'].toLowerCase().contains(busca.toLowerCase()) ||
          orc['numero'].toLowerCase().contains(busca.toLowerCase());

      return statusMatch && buscaMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Orçamentos")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// BOTÕES DE FILTRO
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _botaoFiltro("TODOS"),
                _botaoFiltro("PENDENTE"),
                _botaoFiltro("FECHADO"),
                _botaoFiltro("CANCELADO"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar cliente ou orçamento...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  busca = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: orcamentos.isEmpty
                ? const Center(child: Text("Nenhum orçamento encontrado."))
                : ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final item = listaFiltrada[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),

                          /// TÍTULO
                          title: Text(
                            "${item['numero']} - ${item['cliente']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          /// SUBTÍTULO
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),

                              Text(
                                "Total: R\$ ${item['total'].toStringAsFixed(2).replaceAll('.', ',')}",
                              ),

                              if (item['desconto'] > 0)
                                Text(
                                  "Desconto: R\$ ${item['desconto'].toStringAsFixed(2).replaceAll('.', ',')}",
                                  style: const TextStyle(color: Colors.red),
                                ),

                              const SizedBox(height: 6),

                              /// STATUS BADGE
                              GestureDetector(
                                onTap: () async {
                                  final novoStatus = await showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      title: const Text("Alterar Status"),
                                      children: [
                                        SimpleDialogOption(
                                          child: const Text("PENDENTE"),
                                          onPressed: () => Navigator.pop(
                                            context,
                                            "PENDENTE",
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          child: const Text("FECHADO"),
                                          onPressed: () =>
                                              Navigator.pop(context, "FECHADO"),
                                        ),
                                        SimpleDialogOption(
                                          child: const Text("CANCELADO"),
                                          onPressed: () => Navigator.pop(
                                            context,
                                            "CANCELADO",
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (novoStatus != null) {
                                    await DatabaseHelper.instance
                                        .atualizarStatus(
                                          item['id'],
                                          novoStatus,
                                        );

                                    await carregarOrcamentos();
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: item['status'] == 'FECHADO'
                                          ? Colors.green
                                          : item['status'] == 'CANCELADO'
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item['status'],
                                      style: TextStyle(
                                        color: item['status'] == 'FECHADO'
                                            ? Colors.green
                                            : item['status'] == 'CANCELADO'
                                            ? Colors.red
                                            : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          /// BOTÕES LATERAIS
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item['status'] == 'PENDENTE')
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  tooltip: "Marcar como fechado",
                                  onPressed: () async {
                                    await DatabaseHelper.instance
                                        .marcarComoFechado(item['id']);

                                    await carregarOrcamentos();
                                  },
                                ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
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
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            "Excluir",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmar == true) {
                                    await DatabaseHelper.instance
                                        .excluirOrcamento(item['id']);

                                    await carregarOrcamentos();
                                  }
                                },
                              ),
                            ],
                          ),

                          /// ABRIR ORÇAMENTO
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orcamento_app/screens/resumo_screen.dart';

import '../services/database_helper.dart';

class Item {
  TextEditingController descricaoController = TextEditingController();
  TextEditingController valorController = TextEditingController();
}

class ItensScreen extends StatefulWidget {
  final String nomeCliente;
  final int? orcamentoId;
  final String? numeroOrcamento;

  const ItensScreen({
    super.key,
    required this.nomeCliente,
    this.orcamentoId,
    this.numeroOrcamento,
  });

  @override
  State<ItensScreen> createState() => _ItensScreenState();
}

class _ItensScreenState extends State<ItensScreen> {
  List<Item> itens = [];
  double total = 0;

  bool mostrarDesconto = false;

  final kmController = TextEditingController();
  final custoKmController = TextEditingController(text: "1.20");
  final almocoController = TextEditingController();
  final descontoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.orcamentoId != null) {
      carregarOrcamentoParaEdicao();
    } else {
      adicionarItem();
    }
  }

  void adicionarItem() {
    setState(() {
      itens.add(Item());
    });
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
      calcularTotal();
    });
  }

  void calcularTotal() {
    double somaItens = 0;

    for (var item in itens) {
      final valor =
          double.tryParse(item.valorController.text.replaceAll(",", ".")) ?? 0;
      somaItens += valor;
    }

    double km = double.tryParse(kmController.text.replaceAll(",", ".")) ?? 0;

    double custoKm =
        double.tryParse(custoKmController.text.replaceAll(",", ".")) ?? 0;

    double almoco =
        double.tryParse(almocoController.text.replaceAll(",", ".")) ?? 0;

    double deslocamento = km * custoKm;

    double totalBruto = somaItens + deslocamento + almoco;

    double descontoPercent =
        double.tryParse(descontoController.text.replaceAll(",", ".")) ?? 0;

    double valorDesconto = totalBruto * (descontoPercent / 100);

    setState(() {
      total = totalBruto - valorDesconto;
    });
  }

  Future<void> carregarOrcamentoParaEdicao() async {
    final dados = await DatabaseHelper.instance.buscarItensPorOrcamento(
      widget.orcamentoId!,
    );

    final orcamento = await DatabaseHelper.instance.buscarOrcamentoPorId(
      widget.orcamentoId!,
    );

    kmController.text = orcamento['km'].toString().replaceAll('.', ',');

    custoKmController.text = orcamento['custo_km'].toString().replaceAll(
      '.',
      ',',
    );

    almocoController.text = orcamento['almoco'].toString().replaceAll('.', ',');

    itens.clear(); // importante para evitar duplicar

    for (var itemBanco in dados) {
      final item = Item();
      item.descricaoController.text = itemBanco['descricao'];
      item.valorController.text = itemBanco['valor'].toString().replaceAll(
        '.',
        ',',
      );

      itens.add(item);
    }

    calcularTotal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Orçamento - ${widget.nomeCliente}")),

      // 👇 CONTEÚDO DA TELA
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LISTA DE ITENS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itens.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: itens[index].descricaoController,
                          decoration: const InputDecoration(
                            labelText: "Descrição do Item",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: itens[index].valorController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          onChanged: (_) => calcularTotal(),
                          decoration: const InputDecoration(labelText: "Valor"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removerItem(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: adicionarItem,
              icon: const Icon(Icons.add),
              label: const Text("Adicionar Item"),
            ),

            const SizedBox(height: 20),

            const Text(
              "🚗 Custos de Deslocamento",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: kmController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => calcularTotal(),
              decoration: const InputDecoration(labelText: "Distância (km)"),
            ),

            TextField(
              controller: custoKmController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => calcularTotal(),
              decoration: const InputDecoration(labelText: "Custo por km"),
            ),

            TextField(
              controller: almocoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => calcularTotal(),
              decoration: const InputDecoration(labelText: "Alimentação"),
            ),

            const SizedBox(height: 15),

            if (!mostrarDesconto)
              TextButton(
                onPressed: () {
                  setState(() {
                    mostrarDesconto = true;
                  });
                },
                child: const Text("Aplicar Desconto"),
              ),

            if (mostrarDesconto)
              Column(
                children: [
                  TextField(
                    controller: descontoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => calcularTotal(),
                    decoration: const InputDecoration(
                      labelText: "Desconto (%)",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        descontoController.clear();
                        mostrarDesconto = false;
                        calcularTotal();
                      });
                    },
                    child: const Text(
                      "Remover Desconto",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 80), // espaço para não ficar escondido
          ],
        ),
      ),

      // 👇 BARRA FIXA PROFISSIONAL
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                child: Text(
                  "R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: const Text("Finalizar", style: TextStyle(fontSize: 16)),
                onPressed: () async {
                  double somaItens = 0;

                  for (var item in itens) {
                    double valor =
                        double.tryParse(
                          item.valorController.text.replaceAll(",", "."),
                        ) ??
                        0;
                    somaItens += valor;
                  }

                  double km =
                      double.tryParse(kmController.text.replaceAll(",", ".")) ??
                      0;

                  double custoKm =
                      double.tryParse(
                        custoKmController.text.replaceAll(",", "."),
                      ) ??
                      0;

                  double almoco =
                      double.tryParse(
                        almocoController.text.replaceAll(",", "."),
                      ) ??
                      0;

                  double deslocamento = km * custoKm;

                  double totalBruto = somaItens + deslocamento + almoco;

                  double descontoPercent =
                      double.tryParse(
                        descontoController.text.replaceAll(",", "."),
                      ) ??
                      0;

                  double valorDesconto = totalBruto * (descontoPercent / 100);

                  double totalFinal = totalBruto - valorDesconto;

                  List<Map<String, dynamic>> listaItens = [];

                  for (var item in itens) {
                    listaItens.add({
                      "descricao": item.descricaoController.text,
                      "valor":
                          double.tryParse(
                            item.valorController.text.replaceAll(",", "."),
                          ) ??
                          0,
                    });
                  }

                  String numeroFinal;

                  if (widget.orcamentoId != null) {
                    // ✏️ MODO EDIÇÃO
                    await DatabaseHelper.instance.atualizarOrcamento(
                      id: widget.orcamentoId!,
                      total: totalFinal,
                      desconto: valorDesconto,
                      km: km,
                      custoKm: custoKm,
                      almoco: almoco,
                      itens: listaItens,
                    );

                    numeroFinal = widget.numeroOrcamento ?? "ORC-EDIT";
                  } else {
                    // 🆕 NOVO ORÇAMENTO
                    numeroFinal = await DatabaseHelper.instance
                        .gerarNumeroOrcamento();

                    final data = DateFormat(
                      'dd/MM/yyyy',
                    ).format(DateTime.now());

                    await DatabaseHelper.instance.salvarOrcamento(
                      numero: numeroFinal,
                      cliente: widget.nomeCliente,
                      data: data,
                      total: totalFinal,
                      desconto: valorDesconto,
                      itens: listaItens,
                      km: km,
                      custoKm: custoKm,
                      almoco: almoco,
                    );
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumoScreen(
                        numeroOrcamento: numeroFinal,
                        nomeCliente: widget.nomeCliente,
                        itens: listaItens
                            .map(
                              (e) => {
                                "descricao": e["descricao"].toString(),
                                "valor": e["valor"].toString(),
                              },
                            )
                            .toList(),
                        totalItens: somaItens,
                        deslocamento: deslocamento,
                        almoco: almoco,
                        desconto: valorDesconto,
                        totalGeral: totalFinal,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../services/database_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double faturamento = 0;
  double descontos = 0;
  int totalOrcamentos = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final now = DateTime.now();

    final dados = await DatabaseHelper.instance.buscarOrcamentosDoMes(
      now.month,
      now.year,
    );

    double total = 0;
    double totalDescontos = 0;

    for (var item in dados) {
      total += item['total'];
      totalDescontos += item['desconto'];
    }

    setState(() {
      faturamento = total;
      descontos = totalDescontos;
      totalOrcamentos = dados.length;
    });
  }

  String formatar(double valor) {
    return valor.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Financeiro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card("Faturamento do Mês", "R\$ ${formatar(faturamento)}"),
            const SizedBox(height: 15),
            _card("Orçamentos Emitidos", totalOrcamentos.toString()),
            const SizedBox(height: 15),
            _card("Descontos Concedidos", "R\$ ${formatar(descontos)}"),
          ],
        ),
      ),
    );
  }

  Widget _card(String titulo, String valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Text(titulo, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }
}

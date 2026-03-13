import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orcamento_app/widgets/grafico_financeiro.dart';

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
  int orcamentosFechados = 0;
  int orcamentosPendentes = 0;

  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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

    int fechados = 0;
    int pendentes = 0;

    for (var item in dados) {
      if (item['status'] == 'FECHADO') {
        total += item['total'];
        fechados++;
      } else {
        pendentes++;
      }

      totalDescontos += item['desconto'];
    }

    setState(() {
      faturamento = total;
      descontos = totalDescontos;

      totalOrcamentos = dados.length;
      orcamentosFechados = fechados;
      orcamentosPendentes = pendentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Financeiro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FATURAMENTO (CARD GRANDE)
              _cardGrande(
                "Faturamento do Mês",
                formatador.format(faturamento),
                Icons.attach_money,
              ),

              const SizedBox(height: 20),

              /// GRID DE INDICADORES
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _cardPequeno(
                    "Orçamentos",
                    totalOrcamentos.toString(),
                    Icons.description,
                  ),
                  _cardPequeno(
                    "Fechados",
                    orcamentosFechados.toString(),
                    Icons.check_circle,
                  ),
                  _cardPequeno(
                    "Pendentes",
                    orcamentosPendentes.toString(),
                    Icons.schedule,
                  ),
                  _cardPequeno(
                    "Descontos",
                    formatador.format(descontos),
                    Icons.percent,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Desempenho Financeiro",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              /// GRÁFICO
              SafeArea(
                child: GraficoFinanceiro(
                  faturamento: faturamento,
                  descontos: descontos,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD GRANDE (FATURAMENTO)
  Widget _cardGrande(String titulo, String valor, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 36,
            color: const Color(0xFF0D47A1),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// CARD PEQUENO
  Widget _cardPequeno(String titulo, String valor, IconData icon) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFF0D47A1),
            ),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(
                valor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoFinanceiro extends StatelessWidget {
  final double faturamento;
  final double descontos;

  const GraficoFinanceiro({
    super.key,
    required this.faturamento,
    required this.descontos,
  });

  String formatarValor(double valor) {
    if (valor >= 1000) {
      return "R\$ ${(valor / 1000).toStringAsFixed(1)}K";
    }
    return "R\$ ${valor.toInt()}";
  }

  @override
  Widget build(BuildContext context) {
    final maiorValor = faturamento > descontos ? faturamento : descontos;

    final double maxY = maiorValor == 0 ? 100.0 : (maiorValor * 1.3);

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: maxY / 5,
          ),
          titlesData: FlTitlesData(
            /// EIXO ESQUERDO
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const Text("0");
                  }

                  return Text(
                    formatarValor(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            /// REMOVE EIXO DIREITO
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            /// TITULOS EMBAIXO
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text("Faturamento"),
                      );

                    case 1:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text("Descontos"),
                      );

                    default:
                      return const Text("");
                  }
                },
              ),
            ),

            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: [
            /// FATURAMENTO
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: faturamento,
                  width: 36,
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF0D47A1),
                ),
              ],
            ),

            /// DESCONTOS
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: descontos,
                  width: 36,
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: faturamento, width: 30)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: descontos, width: 30)],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text("Faturamento");
                  if (value == 1) return const Text("Descontos");
                  return const Text("");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/pdf_service.dart';

String formatarMoedaBR(double valor) {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');
  return formatador.format(valor);
}

//String formatarMoedaBR(double valor) {
//final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');
// return formatador.format(valor);
//}

class ResumoScreen extends StatefulWidget {
  final String numeroOrcamento;
  final String nomeCliente;
  final List<Map<String, String>> itens;

  final double totalItens;
  final double deslocamento;
  final double almoco;
  final double desconto;
  final double totalGeral;

  const ResumoScreen({
    super.key,
    required this.numeroOrcamento,
    required this.nomeCliente,
    required this.itens,
    required this.totalItens,
    required this.deslocamento,
    required this.almoco,
    required this.desconto,
    required this.totalGeral,
  });

  @override
  State<ResumoScreen> createState() => _ResumoScreenState();
}

class _ResumoScreenState extends State<ResumoScreen> {
  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resumo do Orçamento")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orçamento: ${widget.numeroOrcamento}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),

            Text(
              "Cliente: ${widget.nomeCliente}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text("Itens:", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: widget.itens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.itens[index]["descricao"] ?? ""),
                    trailing: Text(
                      formatarMoedaBR(
                        double.parse(widget.itens[index]["valor"] ?? "0.0"),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Itens:"),
                Text(formatarMoedaBR(widget.totalItens)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Deslocamento:"),
                Text(formatarMoedaBR(widget.deslocamento)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Despesas Adicionais:"), //Alimentação
                Text(formatarMoedaBR(widget.almoco)),
              ],
            ),

            if (widget.desconto > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Desconto:"),
                  Text(
                    formatarMoedaBR(widget.desconto),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 15),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Geral:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatarMoedaBR(widget.totalGeral),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: carregando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 2, 177, 2),
                        strokeWidth: 5,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),

              label: Text(
                carregando ? "Gerando PDF..." : "Gerar e Enviar Orçamento",
                style: const TextStyle(
                  color: Color.fromARGB(255, 244, 246, 244),
                  fontSize: 15,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 66, 202),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: carregando
                  ? null
                  : () async {
                      setState(() {
                        carregando = true;
                      });

                      await PdfService.gerarECompartilharPdf(
                        numeroOrcamento: widget.numeroOrcamento,
                        nomeCliente: widget.nomeCliente,
                        itens: widget.itens,
                        totalItens: widget.totalItens,
                        deslocamento: widget.deslocamento,
                        almoco: widget.almoco,
                        desconto: widget.desconto,
                        totalGeral: widget.totalGeral,
                      );

                      setState(() {
                        carregando = false;
                      });
                    },
            ),
          ),
        ),
      ),
    );
  }
}

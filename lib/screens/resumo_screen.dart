import 'package:flutter/material.dart';

import '../services/pdf_service.dart';

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
                      "R\$ ${double.parse(widget.itens[index]["valor"] ?? "0").toStringAsFixed(2).replaceAll('.', ',')}",
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
                Text("R\$ ${widget.totalItens.toStringAsFixed(2)}"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Deslocamento:"),
                Text("R\$ ${widget.deslocamento.toStringAsFixed(2)}"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Alimentação:"),
                Text("R\$ ${widget.almoco.toStringAsFixed(2)}"),
              ],
            ),

            if (widget.desconto > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Desconto:"),
                  Text(
                    "- R\$ ${widget.desconto.toStringAsFixed(2)}",
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
                  "R\$ ${widget.totalGeral.toStringAsFixed(2)}",
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
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),

              label: Text(
                carregando ? "Gerando PDF..." : "Gerar e Enviar Orçamento",
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
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

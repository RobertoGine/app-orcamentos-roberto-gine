import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

String formatarMoeda(double valor) {
  return "R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}";
}

class PdfService {
  static Future<void> gerarECompartilharPdf({
    required String nomeCliente,
    required List<Map<String, String>> itens,
    required double totalItens,
    required double deslocamento,
    required double almoco,
    required double desconto,
    required double totalGeral,
  }) async {
    final pdf = pw.Document();

    final logoBytes = (await rootBundle.load(
      'assets/images/logo.png',
    )).buffer.asUint8List();

    final pinguimBytes = (await rootBundle.load(
      'assets/images/pinguim.png',
    )).buffer.asUint8List();

    final logoImage = pw.MemoryImage(logoBytes);
    final pinguimImage = pw.MemoryImage(pinguimBytes);

    final agora = DateTime.now();
    final numeroOrcamento =
        "${agora.year}${agora.month}${agora.day}${agora.hour}${agora.minute}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              // Marca d'água
              pw.Positioned.fill(
                child: pw.Opacity(
                  opacity: 0.08,
                  child: pw.Center(child: pw.Image(pinguimImage, width: 400)),
                ),
              ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Logo central
                  pw.Center(child: pw.Image(logoImage, width: 180)),

                  pw.SizedBox(height: 20),

                  pw.Text(
                    "ORÇAMENTO Nº $numeroOrcamento",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text("Data: ${agora.day}/${agora.month}/${agora.year}"),

                  pw.SizedBox(height: 15),

                  pw.Text(
                    "Cliente: $nomeCliente",
                    style: pw.TextStyle(fontSize: 14),
                  ),

                  pw.SizedBox(height: 15),

                  pw.Text(
                    "Itens:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),

                  pw.SizedBox(height: 25),
                  pw.Divider(),
                  pw.SizedBox(height: 15),

                  ...itens.map(
                    (item) => pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text(item["descricao"] ?? "")),
                        pw.Text(
                          formatarMoeda(
                            double.tryParse(
                                  (item["valor"] ?? "0").replaceAll(",", "."),
                                ) ??
                                0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  pw.Divider(),

                  pw.SizedBox(height: 10),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Mão de obra:"),
                      pw.Text(formatarMoeda(totalItens)),
                    ],
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Deslocamento:"),
                      pw.Text(formatarMoeda(deslocamento)),
                    ],
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Alimentação:"),
                      pw.Text(formatarMoeda(almoco)),
                    ],
                  ),

                  if (desconto > 0)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Desconto:"),
                        pw.Text(
                          formatarMoeda(desconto),
                          style: pw.TextStyle(color: PdfColors.red),
                        ),
                      ],
                    ),

                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 2),

                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 20),
                    padding: const pw.EdgeInsets.all(14),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#EEF3FB"), // azul bem clarinho
                      border: pw.Border(
                        top: pw.BorderSide(
                          width: 3,
                          color: PdfColor.fromHex("#0D47A1"),
                        ),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "TOTAL GERAL",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#0D47A1"),
                          ),
                        ),
                        pw.Text(
                          formatarMoeda(totalGeral),
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex("#0D47A1"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 30),

                  pw.Text("Contato: (11) 98596-2681 | robertogine@hotmail.com"),
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/orcamento_$numeroOrcamento.pdf");

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);

    final mensagem =
        """
    Olá, $nomeCliente!

    Segue seu orçamento digital referente ao serviço solicitado.

    Valor total: ${formatarMoeda(totalGeral)}

    Qualquer dúvida fico à disposição.

    Roberto Giné
    Elétrica Residencial & Comercial ⚡
    """;

    final url = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(mensagem)}",
    );

    await launchUrl(url);
  }
}

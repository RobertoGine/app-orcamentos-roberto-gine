import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/material_model.dart';
import '../utils/formatters.dart';

class PdfListaMaterialService {
  static Future<void> gerarPdf({
    required String numeroOrcamento,
    required String cliente,
    required List<MaterialItem> itens,
    required String observacao,
  }) async {
    final pdf = pw.Document();

    final prefs = await SharedPreferences.getInstance();

    final nomeEmpresa = prefs.getString('nomeEmpresa') ?? 'Sua Empresa';
    final telefoneEmpresa = prefs.getString('telefone') ?? '';
    final emailEmpresa = prefs.getString('emailEmpresa') ?? '';
    final logoPath = prefs.getString('logoPath');

    pw.MemoryImage? logoImage;
    pw.MemoryImage? logoWatermark;

    if (logoPath != null && logoPath.isNotEmpty) {
      final bytes = await File(logoPath).readAsBytes();

      logoImage = pw.MemoryImage(bytes);
      logoWatermark = pw.MemoryImage(bytes);
    }

    final agora = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              /// MARCA D'ÁGUA
              if (logoWatermark != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.04,
                      child: pw.Container(
                        width: 260,
                        height: 260,
                        child: pw.Image(logoWatermark),
                      ),
                    ),
                  ),
                ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  /// LOGO + EMPRESA
                  pw.Center(
                    child: pw.Column(
                      children: [
                        if (logoImage != null)
                          pw.Container(
                            height: 90,
                            child: pw.Image(
                              logoImage,
                              fit: pw.BoxFit.contain,
                            ),
                          ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          nomeEmpresa,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (telefoneEmpresa.isNotEmpty)
                          pw.Text(
                            Formatters.telefoneBR(telefoneEmpresa),
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 25),

                  /// TÍTULO
                  pw.Text(
                    "LISTA DE MATERIAIS",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 10),

                  /// INFORMAÇÕES
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Orçamento Nº $numeroOrcamento",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Data: ${DateFormat('dd/MM/yyyy').format(agora)}",
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Cliente: $cliente",
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  pw.Divider(),

                  pw.SizedBox(height: 15),

                  /// TABELA DE MATERIAIS
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                    ),
                    child: pw.Table(
                      columnWidths: {
                        0: const pw.FlexColumnWidth(4),
                        1: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        /// CABEÇALHO
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "Material",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "Quantidade",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// ITENS
                        ...itens.map(
                          (item) => pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(item.descricao),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  "${item.quantidade} ${item.unidade}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// OBSERVAÇÃO
                  if (observacao.isNotEmpty) ...[
                    pw.SizedBox(height: 25),
                    pw.Text(
                      "Observação",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      observacao,
                    ),
                  ],

                  pw.SizedBox(height: 40),

                  pw.Divider(),

                  pw.SizedBox(height: 10),

                  /// CONTATO
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Contato",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (telefoneEmpresa.isNotEmpty)
                          pw.Text(
                            Formatters.telefoneBR(telefoneEmpresa),
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        if (emailEmpresa.isNotEmpty)
                          pw.Text(
                            emailEmpresa,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/lista_material_$numeroOrcamento.pdf");

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);
  }
}

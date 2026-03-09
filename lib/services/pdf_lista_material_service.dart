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
  }) async {
    final pdf = pw.Document();

    final prefs = await SharedPreferences.getInstance();

    final nomeEmpresa = prefs.getString('nomeEmpresa') ?? 'Sua Empresa';
    final telefoneEmpresa = prefs.getString('telefone') ?? '';
    final emailEmpresa = prefs.getString('emailEmpresa') ?? '';
    final logoPath = prefs.getString('logoPath');

    pw.MemoryImage? logoImage;

    if (logoPath != null && logoPath.isNotEmpty) {
      final bytes = await File(logoPath).readAsBytes();
      logoImage = pw.MemoryImage(bytes);
    }

    final agora = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// LOGO + EMPRESA
              pw.Center(
                child: pw.Column(
                  children: [
                    if (logoImage != null)
                      pw.Image(
                        logoImage,
                        height: 90,
                      ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      nomeEmpresa,
                      style: pw.TextStyle(fontSize: 16),
                    ),
                    if (telefoneEmpresa.isNotEmpty)
                      pw.Text(
                        Formatters.telefoneBR(telefoneEmpresa),
                        style: pw.TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              /// TITULO
              pw.Text(
                "LISTA DE MATERIAIS",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text("Orçamento Nº $numeroOrcamento"),
              pw.Text("Data: ${DateFormat('dd/MM/yyyy').format(agora)}"),

              pw.SizedBox(height: 10),

              pw.Text(
                "Cliente: $cliente",
                style: pw.TextStyle(fontSize: 14),
              ),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.SizedBox(height: 10),

              /// TABELA
              pw.Table.fromTextArray(
                headers: ["Material", "Quantidade"],
                data: itens.map((item) {
                  return [item.descricao, "${item.quantidade} ${item.unidade}"];
                }).toList(),
              ),

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
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    if (emailEmpresa.isNotEmpty)
                      pw.Text(
                        emailEmpresa,
                        style: pw.TextStyle(fontSize: 10),
                      ),
                  ],
                ),
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

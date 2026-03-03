import 'dart:io';

import 'package:intl/intl.dart';
import 'package:orcamento_app/utils/formatters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String formatarMoedaBR(double valor) {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return formatador.format(valor);
}

String formatarMoeda(double valor) {
  return "R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}";
}

String formatarTelefoneBR(String telefone) {
  if (telefone.length == 11) {
    return "(${telefone.substring(0, 2)}) "
        "${telefone.substring(2, 7)}-"
        "${telefone.substring(7)}";
  } else if (telefone.length == 10) {
    return "(${telefone.substring(0, 2)}) "
        "${telefone.substring(2, 6)}-"
        "${telefone.substring(6)}";
  }
  return telefone;
}

class PdfService {
  static Future<void> gerarECompartilharPdf({
    required String numeroOrcamento,
    required String nomeCliente,
    required List<Map<String, String>> itens,
    required double totalItens,
    required double deslocamento,
    required double almoco,
    required double desconto,
    required double totalGeral,
    String? caminhoLogo,
  }) async {
    final pdf = pw.Document();

    //final logoAppBytes = (await rootBundle.load(
    //  'assets/logo_app.png',
    //)).buffer.asUint8List();

    //final logoAppImage = pw.MemoryImage(logoAppBytes);

    //final logoBytes = (await rootBundle.load(
    //  'assets/images/logo.png',
    //)).buffer.asUint8List();

    //final pinguimBytes = (await rootBundle.load(
    // 'assets/images/pinguim.png',
    //)).buffer.asUint8List();

    final prefs = await SharedPreferences.getInstance();

    //String nomeEmpresa = prefs.getString('nomeEmpresa') ?? '';
    //String telefoneEmpresa = prefs.getString('telefone') ?? '';
    //String emailEmpresa = prefs.getString('emailEmpresa') ?? '';
    String? logoPath = prefs.getString('logoPath');

    final nomeEmpresa = prefs.getString('nomeEmpresa') ?? 'Sua Empresa';
    final telefoneEmpresa = prefs.getString('telefone') ?? '';

    final emailEmpresa = prefs.getString('emailEmpresa') ?? '';

    //final logoImage = pw.MemoryImage(logoBytes);
    //final pinguimImage = pw.MemoryImage(pinguimBytes);

    final agora = DateTime.now();

    pw.MemoryImage? logoImage;

    if (logoPath != null && logoPath.isNotEmpty) {
      final logoBytes = await File(logoPath).readAsBytes();
      logoImage = pw.MemoryImage(logoBytes);
    }

    //final numeroOrcamento =
    //"${agora.year}${agora.month}${agora.day}${agora.hour}${agora.minute}";

    pw.MemoryImage? logoWatermark;

    if (logoPath != null && logoPath.isNotEmpty) {
      final logoBytes = await File(logoPath).readAsBytes();
      logoWatermark = pw.MemoryImage(logoBytes);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              // Marca d'água
              if (logoWatermark != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.04,
                      child: pw.Container(
                        width: 260,
                        height: 280,
                        child: pw.FittedBox(
                          fit: pw.BoxFit.contain,
                          child: pw.Image(logoWatermark),
                        ),
                      ),
                    ),
                  ),
                ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Logo central
                  pw.Center(
                    child: pw.Column(
                      children: [
                        if (logoImage != null)
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Image(
                              logoImage,
                              height: 100,
                              width: 80,
                              fit: pw.BoxFit.contain,
                            ),
                          ),
                        pw.SizedBox(height: 10),
                        pw.Text(nomeEmpresa, style: pw.TextStyle(fontSize: 16)),
                        if (telefoneEmpresa.isNotEmpty)
                          pw.Text(
                            formatarTelefoneBR(telefoneEmpresa),
                            style: pw.TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 10),

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
                          formatarMoedaBR(
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
                      pw.Text(formatarMoedaBR(totalItens)),
                    ],
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Deslocamento:"),
                      pw.Text(formatarMoedaBR(deslocamento)),
                    ],
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Alimentação:"),
                      pw.Text(formatarMoedaBR(almoco)),
                    ],
                  ),

                  if (desconto > 0)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Desconto:"),
                        pw.Text(
                          formatarMoedaBR(desconto),
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
                          formatarMoedaBR(totalGeral),
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
                  pw.Divider(),
                  pw.SizedBox(height: 10),

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
                            textAlign: pw.TextAlign.center,
                          ),
                        if (emailEmpresa.isNotEmpty)
                          pw.Text(
                            emailEmpresa,
                            style: pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.center,
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

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/orcamento_$numeroOrcamento.pdf");

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);

    final mensagem =
        """
    Olá, $nomeCliente!

    Segue seu orçamento digital referente ao serviço solicitado.

    Valor total: ${formatarMoedaBR(totalGeral)}

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

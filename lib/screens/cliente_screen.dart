import 'package:flutter/material.dart';
import 'package:orcamento_app/screens/dashboard_screen.dart';
import 'package:orcamento_app/screens/historico_screen.dart';

import 'configuracoes_screen.dart';
import 'itens_screen.dart';
import 'lista_material_screen.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final nomeController = TextEditingController();

  void abrirOrcamento() {
    if (nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Informe o nome do cliente"),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItensScreen(nomeCliente: nomeController.text),
      ),
    );
  }

  Widget menuCard({
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(
          icone,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitulo),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EletricOrçamentos Pro"), actions: []),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo_app.png",
                    height: 90,
                  ),
                  //const SizedBox(height: 10),
                  //const Text(
                  // "EletricOrçamentos Pro",
                  //style: TextStyle(
                  // fontSize: 22,
                  // fontWeight: FontWeight.bold,
                  //),
                  //),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            menuCard(
              titulo: "Novo Orçamento",
              subtitulo: "Criar orçamento para cliente",
              icone: Icons.description,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Novo Orçamento"),
                      content: TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome do Cliente",
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancelar"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: const Text("Continuar"),
                          onPressed: () {
                            Navigator.pop(context);
                            abrirOrcamento();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            menuCard(
              titulo: "Lista de Materiais",
              subtitulo: "Criar ou consultar listas",
              icone: Icons.build,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaMaterialScreen(),
                  ),
                );
              },
            ),
            menuCard(
              titulo: "Histórico",
              subtitulo: "Orçamentos realizados",
              icone: Icons.history,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoricoScreen(),
                  ),
                );
              },
            ),
            menuCard(
              titulo: "Dashboard Financeiro",
              subtitulo: "Faturamento e indicadores",
              icone: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  ),
                );
              },
            ),
            menuCard(
              titulo: "Configuração da Empresa",
              subtitulo: "Logotipo e informações",
              icone: Icons.business,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConfiguracoesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final nomeEmpresaController = TextEditingController();
  final telefoneController = TextEditingController();
  final taxaKmController = TextEditingController();
  final emailController = TextEditingController();
  String? logoPath;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    nomeEmpresaController.text = prefs.getString('nomeEmpresa') ?? '';
    telefoneController.text = prefs.getString('telefone') ?? '';
    taxaKmController.text = prefs.getString('taxaKm') ?? '1.20';
    emailController.text = prefs.getString('emailEmpresa') ?? '';
    logoPath = prefs.getString('logoPath');
  }

  Future<void> salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('emailEmpresa', emailController.text);
    await prefs.setString('nomeEmpresa', nomeEmpresaController.text);
    await prefs.setString('telefone', telefoneController.text);
    await prefs.setString('taxaKm', taxaKmController.text);
    await prefs.setString('logoPath', logoPath ?? '');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Configurações salvas com sucesso!")),
    );
  }

  Future<void> escolherLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        logoPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeEmpresaController,
              decoration: const InputDecoration(labelText: "Nome da Empresa"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: telefoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: "Telefone"),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: taxaKmController,
              decoration: const InputDecoration(
                labelText: "Taxa padrão por KM",
              ),
              keyboardType: TextInputType.number,
            ),

            if (logoPath != null && logoPath!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Image.file(File(logoPath!), height: 100),
              ),

            ElevatedButton(
              onPressed: escolherLogo,
              child: const Text("Selecionar Logo"),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvarDados,
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

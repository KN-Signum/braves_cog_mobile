import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  final VoidCallback onBack;

  const GamesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: const Center(
        child: Text('Moduł gier w budowie'),
      ),
    );
  }
}
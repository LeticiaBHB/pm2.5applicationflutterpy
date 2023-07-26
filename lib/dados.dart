import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

class dados extends StatelessWidget {
  const dados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DADOS COMPILADOS'),
      ),
      body: Center(
        child: Text('Aqui estão os dados compilados na linguagem python', textAlign: TextAlign.center),
      ),
    );
  }
}

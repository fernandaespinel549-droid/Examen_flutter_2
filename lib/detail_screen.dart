import 'package:flutter/material.dart';
import 'database_helper.dart';

class DetailScreen extends StatelessWidget {
  final Map persona;

  DetailScreen({required this.persona});

  void eliminar(BuildContext context) async {
    await DatabaseHelper.instance.deletePerson(persona['id']);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Nombre: ${persona['nombre']} ${persona['apellido']}"),

            Text("Cédula: ${persona['cedula']}"),

            Text("Edad: ${persona['edad']}"),

            Text("Ciudad: ${persona['ciudad']}"),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => eliminar(context),
              child: Text("Eliminar"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'database_helper.dart';

// Pantalla de detalle de persona
// Muestra toda la información de una persona y permite eliminarla
class DetailScreen extends StatelessWidget {
  final Map persona;

  DetailScreen({required this.persona});

  // Función para eliminar una persona de la base de datos
  void eliminar(BuildContext context) async {
    // Confirmar antes de eliminar
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Está seguro de eliminar este registro?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      // Eliminar persona de la base de datos
      await DatabaseHelper.instance.deletePerson(persona['id']);

      // Regresar a la pantalla anterior
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
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
            // Mostrar nombre completo
            Text(
              "Nombre: ${persona['nombre']} ${persona['apellido']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Mostrar cédula
            Text(
              "Cédula: ${persona['cedula']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Mostrar edad
            Text("Edad: ${persona['edad']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Mostrar ciudad
            Text(
              "Ciudad: ${persona['ciudad']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Botón para eliminar
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

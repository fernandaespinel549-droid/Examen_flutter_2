import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'person.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final edadController = TextEditingController();
  final ciudadController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    edadController.dispose();
    ciudadController.dispose();
    super.dispose();
  }

  void guardarPersona(BuildContext context) async {
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        cedulaController.text.isEmpty ||
        edadController.text.isEmpty ||
        ciudadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos los campos son obligatorios")),
      );
      return;
    }

    if (cedulaController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La cédula debe tener 10 dígitos")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Person person = Person(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        cedula: cedulaController.text.trim(),
        edad: int.tryParse(edadController.text.trim()) ?? 0,
        ciudad: ciudadController.text.trim(),
      );

      print("Intentando guardar persona: ${person.toMap()}");

      final result = await DatabaseHelper.instance.insertPerson(person);

      print("Resultado de inserción: $result");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registro guardado")));

      nombreController.clear();
      apellidoController.clear();
      cedulaController.clear();
      edadController.clear();
      ciudadController.clear();
    } catch (e) {
      print("Error al guardar: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Persona")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),

            TextField(
              controller: apellidoController,
              decoration: InputDecoration(labelText: "Apellido"),
            ),

            TextField(
              controller: cedulaController,
              decoration: InputDecoration(labelText: "Cédula"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: edadController,
              decoration: InputDecoration(labelText: "Edad"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: ciudadController,
              decoration: InputDecoration(labelText: "Ciudad"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : () => guardarPersona(context),
              child: _isLoading ? CircularProgressIndicator() : Text("Guardar"),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: Text("Ver Personas Registradas"),
            ),
          ],
        ),
      ),
    );
  }
}

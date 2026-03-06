import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'person.dart';

// Pantalla de registro de personas
// Permite ingresar los datos de una nueva persona y guardarlos en SQLite
class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final edadController = TextEditingController();
  final ciudadController = TextEditingController();

  // Indicador de carga para mostrar mientras se guarda
  bool _isLoading = false;

  @override
  void dispose() {
    // Liberar los controladores cuando el widget se destruye
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    edadController.dispose();
    ciudadController.dispose();
    super.dispose();
  }

  // Función para guardar una nueva persona en la base de datos
  void guardarPersona(BuildContext context) async {
    // Validar que todos los campos estén llenos
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

    // Validar que la cédula tenga exactamente 10 dígitos
    if (cedulaController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La cédula debe tener 10 dígitos")),
      );
      return;
    }

    // Mostrar indicador de carga
    setState(() {
      _isLoading = true;
    });

    try {
      // Crear objeto Person con los datos del formulario
      Person person = Person(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        cedula: cedulaController.text.trim(),
        edad: int.tryParse(edadController.text.trim()) ?? 0,
        ciudad: ciudadController.text.trim(),
      );

      // Insertar persona en la base de datos
      await DatabaseHelper.instance.insertPerson(person);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registro guardado")));

      // Limpiar los campos del formulario
      nombreController.clear();
      apellidoController.clear();
      cedulaController.clear();
      edadController.clear();
      ciudadController.clear();
    } catch (e) {
      // Mostrar mensaje de error si falla el guardado
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
    } finally {
      // Ocultar indicador de carga
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
            // Campo: Nombre
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            // Campo: Apellido
            TextField(
              controller: apellidoController,
              decoration: InputDecoration(labelText: "Apellido"),
            ),
            // Campo: Cédula (solo números)
            TextField(
              controller: cedulaController,
              decoration: InputDecoration(labelText: "Cédula"),
              keyboardType: TextInputType.number,
            ),
            // Campo: Edad (solo números)
            TextField(
              controller: edadController,
              decoration: InputDecoration(labelText: "Edad"),
              keyboardType: TextInputType.number,
            ),
            // Campo: Ciudad
            TextField(
              controller: ciudadController,
              decoration: InputDecoration(labelText: "Ciudad"),
            ),
            SizedBox(height: 20),
            // Botón para guardar
            ElevatedButton(
              onPressed: _isLoading ? null : () => guardarPersona(context),
              child: _isLoading ? CircularProgressIndicator() : Text("Guardar"),
            ),
            SizedBox(height: 10),
            // Botón para ver la lista de personas
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

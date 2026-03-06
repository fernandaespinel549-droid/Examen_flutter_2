import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'detail_screen.dart';

// Pantalla de listado de personas
// Muestra todas las personas registradas en una lista
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // Lista de personas obtenidas de la base de datos
  List personas = [];

  // Función para cargar todas las personas desde SQLite
  void cargarPersonas() async {
    final data = await DatabaseHelper.instance.getPersons();

    setState(() {
      personas = data;
    });
  }

  @override
  void initState() {
    super.initState();
    // Cargar las personas al iniciar la pantalla
    cargarPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Personas")),
      body: personas.isEmpty
          ? Center(child: Text("No hay personas registradas"))
          : ListView.builder(
              // Cantidad de elementos en la lista
              itemCount: personas.length,
              // Constructor para cada elemento de la lista
              itemBuilder: (context, index) {
                final persona = personas[index];

                return ListTile(
                  // Mostrar nombre completo
                  title: Text("${persona['nombre']} ${persona['apellido']}"),
                  // Mostrar número de cédula
                  subtitle: Text(persona['cedula']),
                  // Al tocar, ir a la pantalla de detalle
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(persona: persona),
                      ),
                    ).then((_) {
                      // Recargar la lista al regresar de la pantalla de detalle
                      cargarPersonas();
                    });
                  },
                );
              },
            ),
    );
  }
}

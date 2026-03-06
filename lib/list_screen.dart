import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List personas = [];

  void cargarPersonas() async {
    final data = await DatabaseHelper.instance.getPersons();

    setState(() {
      personas = data;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Personas")),

      body: personas.isEmpty
          ? Center(child: Text("No hay personas registradas"))
          : ListView.builder(
              itemCount: personas.length,
              itemBuilder: (context, index) {
                final persona = personas[index];

                return ListTile(
                  title: Text("${persona['nombre']} ${persona['apellido']}"),
                  subtitle: Text(persona['cedula']),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(persona: persona),
                      ),
                    ).then((_) {
                      cargarPersonas();
                    });
                  },
                );
              },
            ),
    );
  }
}

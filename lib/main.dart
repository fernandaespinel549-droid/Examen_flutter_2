import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'list_screen.dart';

// Función principal que inicia la aplicación
void main() {
  runApp(MyApp());
}

// Clase principal de la aplicación
// Define las rutas de navegación entre pantallas
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro Personas',
      debugShowCheckedModeBanner: false,
      // Ruta inicial (pantalla de registro)
      initialRoute: '/',
      // Definición de rutas
      routes: {
        // Ruta principal - Pantalla de Registro
        '/': (context) => RegisterScreen(),
        // Ruta para Listado de Personas
        '/list': (context) => ListScreen(),
      },
    );
  }
}

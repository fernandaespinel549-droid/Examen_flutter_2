// Modelo de datos para una persona
// Representa la estructura de los datos de una persona en la aplicación
class Person {
  int? id;
  String nombre;
  String apellido;
  String cedula;
  int edad;
  String ciudad;

  // Constructor de la clase Person
  // id es opcional ya que se genera automáticamente en la base de datos
  Person({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.edad,
    required this.ciudad,
  });

  // Convierte el objeto Person a un mapa para almacenar en SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'edad': edad,
      'ciudad': ciudad,
    };
  }
}

class Person {
  int? id;
  String nombre;
  String apellido;
  String cedula;
  int edad;
  String ciudad;

  Person({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.edad,
    required this.ciudad,
  });

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

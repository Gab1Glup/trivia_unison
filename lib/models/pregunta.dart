class Pregunta {
  final int id;
  final String enunciado;
  final List<String> opciones;
  final int indiceCorrecto;
  final String categoria;
  final String dificultad;

  const Pregunta({
    required this.id,
    required this.enunciado,
    required this.opciones,
    required this.indiceCorrecto,
    required this.categoria,
    required this.dificultad,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id:             json['id']             as int,
      enunciado:      json['enunciado']      as String,
      opciones:       List<String>.from(json['opciones'] as List),
      indiceCorrecto: json['indiceCorrecto'] as int,
      categoria:      json['categoria']      as String,
      dificultad:     json['dificultad']     as String,
    );
  }
}

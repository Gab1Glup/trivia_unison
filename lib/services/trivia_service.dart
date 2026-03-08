import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/pregunta.dart';

class TriviaService {

  static List<Pregunta>? _cache;

  static Future<List<Pregunta>> obtenerPreguntas({
    int cantidad = 10,
    String? dificultad,
    String? categoria,
  }) async {
    final todas = await _cargarTodas();

    var filtradas = todas.where((p) {
      final pasaDificultad = dificultad == null || p.dificultad == dificultad;
      final pasaCategoria  = categoria  == null || p.categoria  == categoria;
      return pasaDificultad && pasaCategoria;
    }).toList();

    filtradas.shuffle(Random());

    return filtradas.take(cantidad).toList();
  }

  static Future<List<Pregunta>> obtenerPreguntasBalanceadas({
    int cantidad = 10,
  }) async {
    final todas = await _cargarTodas();

    final faciles  = todas.where((p) => p.dificultad == 'facil') .toList()..shuffle();
    final medias   = todas.where((p) => p.dificultad == 'medio') .toList()..shuffle();
    final dificiles = todas.where((p) => p.dificultad == 'dificil').toList()..shuffle();

    final nFacil   = (cantidad * 0.3).round();
    final nDificil = (cantidad * 0.2).round();
    final nMedio   = cantidad - nFacil - nDificil;

    final seleccion = [
      ...faciles.take(nFacil),
      ...medias.take(nMedio),
      ...dificiles.take(nDificil),
    ]..shuffle(Random());

    return seleccion;
  }

  static Future<List<String>> obtenerCategorias() async {
    final todas = await _cargarTodas();
    return todas.map((p) => p.categoria).toSet().toList()..sort();
  }

  static Future<List<Pregunta>> _cargarTodas() async {
    if (_cache != null) return _cache!;

    final rawJson = await rootBundle.loadString('assets/data/preguntas.json');
    final List<dynamic> lista = jsonDecode(rawJson) as List<dynamic>;
    _cache = lista
        .map((e) => Pregunta.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }
}

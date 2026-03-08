import 'package:flutter/material.dart';

class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key});

  static const navy = Color(0xFF001BB7);
  static const orange = Color(0xFFFF8040);
  static const green = Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final puntaje = args['puntaje'] ?? 0;
    final total = args['total'] ?? 10;
    final dificultad = args['dificultad'];

    final porcentaje = total > 0 ? puntaje / total : 0;

    String titulo;
    IconData icon;
    Color color;

    if (porcentaje >= 0.9) {
      titulo = "¡Excelente!";
      icon = Icons.emoji_events;
      color = green;
    } else if (porcentaje >= 0.6) {
      titulo = "¡Muy bien!";
      icon = Icons.thumb_up;
      color = orange;
    } else {
      titulo = "Sigue practicando";
      icon = Icons.refresh;
      color = Colors.red;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000D6B), navy, Color(0xFF0033DD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: color.withOpacity(.15),
                  child: Icon(icon, size: 50, color: color),
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _scoreCard(puntaje, total, porcentaje, color),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _button(
                        icon: Icons.home,
                        text: "Inicio",
                        color: Colors.white24,
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/bienvenida',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _button(
                        icon: Icons.replay,
                        text: "Repetir",
                        color: orange,
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/quiz',
                          arguments: {'dificultad': dificultad},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreCard(int puntaje, int total, double porcentaje, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "PUNTAJE FINAL",
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "$puntaje / $total",
            style: TextStyle(
              color: color,
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: porcentaje,
            minHeight: 10,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 6),
          Text(
            "${(porcentaje * 100).round()}% correcto",
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  static const navy   = Color(0xFF001BB7);
  static const orange = Color(0xFFFF8040);
  static const beige  = Color(0xFFF5F1DC);

  void comenzar(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/quiz');
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: navy,
                    boxShadow: [
                      BoxShadow(
                        color: orange.withOpacity(.3),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Image.asset('assets/trivia.png'),
                ),
                const SizedBox(height: 24),
                const Text(
                  "TRIVIA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const Text(
                  "UNISON",
                  style: TextStyle(
                    color: orange,
                    letterSpacing: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _infoCard(),
                const Spacer(),
                GestureDetector(
                  onTap: () => comenzar(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "COMENZAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text(
            "¿CÓMO JUGAR?",
            style: TextStyle(
              color: orange,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 16),
          _InfoRow(Icons.quiz_rounded,   "10 preguntas de tecnología e ingeniería"),
          _InfoRow(Icons.timer_rounded,  "15 segundos por pregunta"),
          _InfoRow(Icons.grid_view_rounded, "4 opciones de respuesta"),
          _InfoRow(Icons.star_rounded,   "Gana puntos respondiendo correctamente"),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF8040), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFF5F1DC),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

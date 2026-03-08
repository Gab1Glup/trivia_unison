import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pregunta.dart';
import '../services/trivia_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  static const _navy = Color(0xFF001BB7);
  static const _blue1 = Color(0xFF0046FF);
  static const _orange = Color(0xFFFF8040);
  static const _beige = Color(0xFFF5F1DC);
  static const _bgTop = Color(0xFF000D6B);
  static const _bgMid = Color(0xFF001BB7);
  static const _bgBot = Color(0xFF0033DD);
  List<Pregunta> _preguntas = [];
  int _indiceActual = 0;
  int _puntaje = 0;
  int _tiempoRestante = 15;
  bool _cargando = true;
  String? _errorMsg;
  bool _respondida = false;
  int _seleccionado = -1;
  Timer? _timer;
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);
  late final Animation<double> _fadeAnim =
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarPreguntas() async {
    try {
      final preguntas = await TriviaService.obtenerPreguntas();
      setState(() {
        _preguntas = preguntas;
        _cargando = false;
      });
      _fadeCtrl.forward();
      _iniciarTimer();
    } catch (e) {
      setState(() {
        _cargando = false;
        _errorMsg = e.toString();
      });
    }
  }

  void _iniciarTimer() {
    _tiempoRestante = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _tiempoRestante--);
      if (_tiempoRestante == 0) _verificarRespuesta(-1);
    });
  }

  void _verificarRespuesta(int index) {
    if (_respondida) return;
    setState(() {
      _respondida = true;
      _seleccionado = index;
    });
    _timer?.cancel();
    if (index == _preguntas[_indiceActual].indiceCorrecto) _puntaje++;
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_indiceActual < _preguntas.length - 1) {
        _fadeCtrl.reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _indiceActual++;
            _respondida = false;
            _seleccionado = -1;
          });
          _fadeCtrl.forward();
          _iniciarTimer();
        });
      } else {
        Navigator.pushReplacementNamed(context, '/resultado',
            arguments: {'puntaje': _puntaje, 'total': _preguntas.length});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: _bgTop,
        body: Center(child: CircularProgressIndicator(color: _orange)),
      );
    }
    final pregunta = _preguntas[_indiceActual];
    final total = _preguntas.length;
    final progress = (_indiceActual + 1) / total;
    final isUrgent = _tiempoRestante <= 5;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_bgTop, _bgMid, _bgBot],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: LayoutBuilder(
                builder: (ctx, bc) {
                  final totalH = bc.maxHeight;
                  final headerH = totalH * 0.11;
                  final questionH = totalH * 0.18;
                  final gridH = totalH * 0.62;
                  final gapH = (totalH - headerH - questionH - gridH) / 3;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: headerH,
                          child: Row(
                            children: [
                              _TimerCircle(
                                timeLeft: _tiempoRestante,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pregunta ${_indiceActual + 1} de $total',
                                      style: TextStyle(
                                        color: _beige.withOpacity(0.65),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 8,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.12),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                _orange),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: _orange, size: 14),
                                    const SizedBox(width: 4),
                                    Text('$_puntaje',
                                        style: const TextStyle(
                                          color: _orange,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: gapH),
                        SizedBox(
                          height: questionH,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.13),
                                  width: 1.2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pregunta.enunciado,
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: gapH),
                        SizedBox(
                          height: gridH,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pregunta.opciones.length.clamp(0, 4),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: (gridH - 12) / 2,
                            ),
                            itemBuilder: (_, i) => _OptionCard(
                              label: pregunta.opciones[i],
                              index: i,
                              answered: _respondida,
                              selected: _seleccionado,
                              correct: pregunta.indiceCorrecto,
                              onTap: () => _verificarRespuesta(i),
                            ),
                          ),
                        ),
                        SizedBox(height: gapH),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerCircle extends StatelessWidget {
  final int timeLeft;

  const _TimerCircle({
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: timeLeft / 15,
            strokeWidth: 4,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFF8040)),
          ),
          Text(
            "$timeLeft",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final int index, selected, correct;
  final bool answered;
  final VoidCallback onTap;
  static const _orange = Color(0xFFFF8040);
  static const _beige = Color(0xFFF5F1DC);
  static const _cellBg = [
    Color(0xFF0A2A9E),
    Color(0xFF0A3D7A),
    Color(0xFF7A2D00),
    Color(0xFF2D1A6E),
  ];
  static const _cellBorder = [
    Color(0xFF4D6EFF),
    Color(0xFF2A8FCC),
    Color(0xFFFF8040),
    Color(0xFF8B6BFF),
  ];
  const _OptionCard({
    required this.label,
    required this.index,
    required this.answered,
    required this.selected,
    required this.correct,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + index);
    final ci = index % _cellBg.length;
    Color bg = _cellBg[ci];
    Color border = _cellBorder[ci].withOpacity(0.70);
    Color textCol = _beige;
    Color letterBg = _cellBorder[ci];
    IconData? icon;
    if (answered) {
      if (index == correct) {
        bg = const Color(0xFF0D5C2A);
        border = const Color(0xFF1DB954);
        textCol = const Color(0xFFB8FFD0);
        letterBg = const Color(0xFF1DB954);
        icon = Icons.check_circle_rounded;
      } else if (index == selected) {
        bg = const Color(0xFF6B1A00);
        border = _orange;
        textCol = const Color(0xFFFFD0B0);
        letterBg = _orange;
        icon = Icons.cancel_rounded;
      } else {
        bg = Colors.white.withOpacity(0.04);
        border = Colors.white.withOpacity(0.08);
        textCol = Colors.white.withOpacity(0.28);
        letterBg = Colors.white.withOpacity(0.10);
      }
    }
    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 270),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1.8),
          boxShadow: answered
              ? []
              : [
                  BoxShadow(
                    color: _cellBorder[ci].withOpacity(0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 270),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: letterBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(letter,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ),
                if (answered && icon != null)
                  Icon(icon,
                      size: 20,
                      color:
                          index == correct ? const Color(0xFF1DB954) : _orange),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textCol,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

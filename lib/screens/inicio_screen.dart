import 'dart:async';
import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with TickerProviderStateMixin {
  static const _navy = Color(0xFF001BB7);
  static const _blue1 = Color(0xFF0046FF);
  static const _beige = Color(0xFFF5F1DC);
  static const _orange = Color(0xFFFF8040);

  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _fadeAnim = CurvedAnimation(
    parent: _fadeCtrl,
    curve: Curves.easeOut,
  );
  late final Animation<double> _slideAnim = Tween<double>(begin: 24, end: 0)
      .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fadeCtrl.forward();
    });
    Timer(const Duration(seconds: 4), _navegar);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _navegar() {
    if (_tapped) return;
    _tapped = true;
    Navigator.pushReplacementNamed(context, '/bienvenida');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _navegar,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF000D6B),
                    Color(0xFF001BB7),
                    Color(0xFF0033DD),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              top: -size.width * 0.3,
              right: -size.width * 0.25,
              child: _circle(size.width * 0.65, _blue1.withOpacity(0.08)),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation: _fadeCtrl,
                builder: (_, __) => Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (_, __) => Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(colors: [
                                  Color(0xFF0033DD).withOpacity(0.80),
                                  _navy.withOpacity(0.95),
                                ]),
                                border: Border.all(
                                  color: _orange.withOpacity(
                                      0.25 + 0.20 * _pulseCtrl.value),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _orange.withOpacity(
                                        0.08 + 0.12 * _pulseCtrl.value),
                                    blurRadius: 18 + 10 * _pulseCtrl.value,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Image.asset('assets/logo.png',
                                  fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text('TRIVIA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 10,
                              )),
                          const SizedBox(height: 4),
                          const Text('UNISON',
                              style: TextStyle(
                                color: _orange,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 7,
                              )),
                          const SizedBox(height: 32),
                          Row(children: [
                            Expanded(
                                child: Container(
                                    height: 1,
                                    color: _orange.withOpacity(0.3))),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _orange.withOpacity(0.6),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    height: 1,
                                    color: _orange.withOpacity(0.3))),
                          ]),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: Color(0xFF000D6B).withOpacity(0.65),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _blue1.withOpacity(0.4), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                    color: _navy.withOpacity(0.35),
                                    blurRadius: 24)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('INTEGRANTES',
                                    style: TextStyle(
                                      color: _orange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3,
                                    )),
                                const SizedBox(height: 12),
                                _memberTile('Barajas Miranda'),
                                _rowDivider(),
                                _memberTile('Jose Jose'),
                                _rowDivider(),
                                _memberTile('Salcido Gutierrez'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 44),
                          _TapHint(accent: _orange),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _memberTile(String nombre) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: _orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(nombre,
                  style: const TextStyle(
                    color: _beige,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  )),
            ),
          ],
        ),
      );

  Widget _rowDivider() => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: _blue1.withOpacity(0.15),
      );
}

class _TapHint extends StatefulWidget {
  final Color accent;
  const _TapHint({required this.accent});

  @override
  State<_TapHint> createState() => _TapHintState();
}

class _TapHintState extends State<_TapHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: 0.35 + 0.65 * _ctrl.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_rounded, size: 16, color: widget.accent),
            const SizedBox(width: 8),
            Text('Toca para continuar',
                style: TextStyle(
                  color: const Color(0xFFF5F1DC).withOpacity(0.55),
                  fontSize: 13,
                  letterSpacing: 1.2,
                )),
          ],
        ),
      ),
    );
  }
}

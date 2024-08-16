import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ruleta Agrosuper',
      home: Scaffold(
        body: Center(
          child: FortuneWheelExample(),
        ),
      ),
    );
  }
}

class FortuneWheelExample extends StatefulWidget {
  const FortuneWheelExample({super.key});

  @override
  _FortuneWheelExampleState createState() => _FortuneWheelExampleState();
}

class _FortuneWheelExampleState extends State<FortuneWheelExample> {
  final StreamController<int> _controller = StreamController<int>();
  int selectedIndex = 0;
  bool isButtonActive = true;

  // Definir una lista con 12 opciones, cada una con un color de fondo diferente
  final List<Map<String, dynamic>> opciones = [
    {"texto": "Mandil", "icono": Icons.check, "color": const Color(0xFF0161d3)},
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0070E3)
    },
    {
      "texto": "Tabla\nde sal",
      "icono": Icons.spa,
      "color": const Color(0xFF0150c6)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF013b98)
    },
    {
      "texto": "Pack de\ngalletas",
      "icono": Icons.fastfood,
      "color": const Color(0xFF07308d)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0070e3)
    },
    {
      "texto": "Cubiertos\nsustentables",
      "icono": Icons.eco,
      "color": const Color(0xFF0161d3)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0056ca)
    },
    {
      "texto": "Tabla\nde sal",
      "icono": Icons.spa,
      "color": const Color(0xFF0047b6)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF013b98)
    },
    {
      "texto": "Pack de\ngalletas",
      "icono": Icons.fastfood,
      "color": const Color(0xFF072e87)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0070e3)
    },
  ];

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void mostrarResultado(BuildContext context, String resultado) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutBack,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    resultado == "¡Sigue intentando!"
                        ? 'assets/win.png'
                        : 'assets/win.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: FortuneWheel(
                      animateFirst: false,
                      selected: _controller.stream,
                      items: opciones.map((opcion) {
                        String texto = opcion['texto'];
                        IconData? icono = opcion['icono'];
                        Color color = opcion['color'];
                        return FortuneItem(
                          child: RotatedBox(
                            quarterTurns: 5,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (icono != null)
                                    Icon(
                                      icono,
                                      color: Colors.white,
                                      size: screenWidth * 0.07,
                                    ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      texto,
                                      textHeightBehavior:
                                          const TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.020,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          style: FortuneItemStyle(
                            color: color,
                            borderColor: const Color(0xFF013b98),
                            borderWidth: 0.9,
                          ),
                        );
                      }).toList(),
                      onAnimationEnd: () {
                        setState(() {
                          isButtonActive = true;
                        });
                        String resultado = opciones[selectedIndex]['texto'];
                        if (resultado.startsWith("Siga")) {
                          mostrarResultado(context, "¡Sigue intentando!");
                        } else {
                          mostrarResultado(
                              context, "¡Felicidades! Ganaste $resultado");
                        }
                      },
                      indicators: <FortuneIndicator>[
                        FortuneIndicator(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(0, -screenWidth * 0.1),
                            child: Image.asset(
                              'assets/Pin_ruleta.png',
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Image.asset(
                      'assets/center.png',
                      width: size * 0.5,
                      height: size * 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: GestureDetector(
                  key: ValueKey<bool>(isButtonActive),
                  onTap: isButtonActive
                      ? () {
                          setState(() {
                            selectedIndex =
                                Fortune.randomInt(0, opciones.length);
                            _controller.add(selectedIndex);
                            isButtonActive = false;
                          });
                        }
                      : null,
                  child: Container(
                    width: screenWidth * 0.25, // Tamaño fijo para evitar salto
                    height: screenWidth * 0.25, // Tamaño fijo para evitar salto
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          isButtonActive
                              ? 'assets/Btn_Girar_Activo.png'
                              : 'assets/Btn_Girar_Inactivo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

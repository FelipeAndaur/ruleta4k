import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruleta Agrosuper',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ruleta de la Fortuna'),
        ),
        body: const Center(
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

  // Definir una lista con 12 opciones, algunas de las cuales se repiten
  final List<Map<String, IconData?>> opciones = [
    {"Siga\nparticipando": null},
    {"Mandil": Icons.check},
    {"Tabla\nde sal": Icons.spa},
    {"Siga\nparticipando": null},
    {"Pack de\ngalletas": Icons.fastfood},
    {"Siga\nparticipando": null},
    {"Cubiertos\nsustentables": Icons.eco},
    {"Siga\nparticipando": null},
    {"Tabla\nde sal": Icons.spa},
    {"Siga\nparticipando": null},
    {"Pack de\ngalletas": Icons.fastfood},
    {"Siga\nparticipando": null},
  ];

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void mostrarResultado(BuildContext context, String resultado) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Permite cerrar el diálogo al tocar fuera de él
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0), // Animar desde 0 a 1
            duration:
                const Duration(milliseconds: 1500), // Duración de la animación
            curve: Curves.easeOutBack, // Curva de la animación
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale, // Aplicar la escala animada
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    resultado == "¡Sigue intentando!"
                        ? 'assets/win.png' // Ruta de la imagen para perdedor
                        : 'assets/win.png', // Ruta de la imagen para ganador
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width, // Ancho máximo
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
        double size = constraints.maxWidth; // Usar el ancho completo

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
                        String text = opcion.keys.first;
                        IconData? icon = opcion.values.first;
                        return FortuneItem(
                          child: RotatedBox(
                            quarterTurns: 5,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth *
                                  0.04), // Ajustar padding proporcionalmente
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (icon != null)
                                    Icon(
                                      icon,
                                      color: Colors.white,
                                      size: screenWidth *
                                          0.07, // Ajustar tamaño del ícono proporcionalmente
                                    ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      text,
                                      textHeightBehavior:
                                          const TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: screenWidth *
                                            0.020, // Ajustar tamaño del texto proporcionalmente
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          style: FortuneItemStyle(
                            color:
                                Colors.blue, // Color de fondo de este segmento
                            borderColor: const Color.fromARGB(255, 17, 0, 198),
                            borderWidth: screenWidth *
                                0.005, // Ajustar grosor del borde proporcionalmente
                          ),
                        );
                      }).toList(),
                      onAnimationEnd: () {
                        // Mostrar un mensaje basado en el resultado
                        String resultado = opciones[selectedIndex].keys.first;
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
                              'assets/Pin_ruleta.png', // Ruta de la imagen del indicador
                              width: screenWidth *
                                  0.1, // Ajustar tamaño del indicador proporcionalmente
                              height: screenWidth * 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Imagen central sobre la ruleta
                  Positioned(
                    child: Image.asset(
                      'assets/center.png', // Ruta de la imagen del indicador
                      width: size * 0.6, // Ajustar tamaño de la imagen central
                      height: size * 0.6, // Ajustar tamaño de la imagen central
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = Fortune.randomInt(0, opciones.length);
                    _controller.add(selectedIndex);
                  });
                },
                child: const Text('Girar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

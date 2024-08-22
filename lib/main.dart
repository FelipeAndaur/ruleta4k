import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruleta Agrosuper',
      home: Scaffold(
        backgroundColor: Color(0xffededed),
        body: FortuneWheelExample(),
      ),
    );
  }
}

class FortuneWheelExample extends StatefulWidget {
  const FortuneWheelExample({super.key});

  @override
  FortuneWheelExampleState createState() => FortuneWheelExampleState();
}

class FortuneWheelExampleState extends State<FortuneWheelExample> {
  final StreamController<int> _controller = StreamController<int>();
  int selectedIndex = 0;
  bool isButtonActive = true;

  final List<Map<String, dynamic>> opciones = [
    {
      "texto": "Pechera",
      "icono": 'assets/pechera.svg',
      "color": const Color(0xFF0161d3)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0070E3)
    },
    {
      "texto": "Tabla\nde picoteo",
      "icono": 'assets/tabla.svg',
      "color": const Color(0xFF0150c6)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF013b98)
    },
    {
      "texto": "Galletas",
      "icono": 'assets/galletas.svg',
      "color": const Color(0xFF07308d)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0070e3)
    },
    {
      "texto": "Pechera",
      "icono": 'assets/pechera.svg',
      "color": const Color(0xFF0161d3)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF0056ca)
    },
    {
      "texto": "Tabla\nde picoteo",
      "icono": 'assets/tabla.svg',
      "color": const Color(0xFF0047b6)
    },
    {
      "texto": "Siga\nparticipando",
      "icono": null,
      "color": const Color(0xFF013b98)
    },
    {
      "texto": "Galletas",
      "icono": 'assets/galletas.svg',
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
                        ? 'assets/lose.png'
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
        double height = constraints.maxHeight;

        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size * 0.02), // Usando un porcentaje del tamaño total
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Image.asset(
                  'assets/Agrosuper.png', // Ruta a la imagen del logo
                  width: size * 0.25,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: Container(
                      padding: EdgeInsets.all(size * 0.02),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/circle.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: FortuneWheel(
                        animateFirst: false,
                        selected: _controller.stream,
                        items: opciones.map((opcion) {
                          String texto = opcion['texto'];
                          String? icono = opcion['icono'];
                          Color color = opcion['color'];
                          return FortuneItem(
                            child: RotatedBox(
                              quarterTurns: 5,
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (icono != null)
                                      SvgPicture.asset(
                                        icono,
                                        height: screenWidth * 0.09,
                                        width: screenWidth * 0.09,
                                      )
                                    else
                                      SizedBox(
                                        height: screenWidth * 0.04,
                                      ), // Añade un espacio cuando no hay ícono
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
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
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
                              offset: Offset(0, -screenWidth * 0.08),
                              child: Image.asset(
                                'assets/Pin_ruleta.png',
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              Padding(
                padding: EdgeInsets.only(
                    bottom:
                        height * 0.07), // Usando un porcentaje del tamaño total
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CanvasPage(),
    );
  }
}

class DrawnPoint {
  final Offset offset;
  final Paint paint;

  DrawnPoint(this.offset, this.paint);
}

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<DrawnPoint?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isEraser = false;

  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App - Lienzo Web'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Limpiar Lienzo',
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(
                    DrawnPoint(
                      renderBox.globalToLocal(details.globalPosition),
                      Paint()
                        ..color = isEraser ? Colors.white : selectedColor
                        ..strokeCap = StrokeCap.round
                        ..strokeWidth = strokeWidth,
                    ),
                  );
                });
              },
              onPanStart: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(
                    DrawnPoint(
                      renderBox.globalToLocal(details.globalPosition),
                      Paint()
                        ..color = isEraser ? Colors.white : selectedColor
                        ..strokeCap = StrokeCap.round
                        ..strokeWidth = strokeWidth,
                    ),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(null);
                });
              },
              child: CustomPaint(
                painter: CanvasPainter(points),
                size: Size.infinite,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...colors.map((color) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                              isEraser = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (selectedColor == color && !isEraser)
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        )),
                    IconButton(
                      icon: Icon(Icons.cleaning_services,
                          color: isEraser ? Colors.deepPurple : Colors.grey),
                      tooltip: 'Borrador',
                      onPressed: () {
                        setState(() {
                          isEraser = !isEraser;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.brush),
                    Expanded(
                      child: Slider(
                        value: strokeWidth,
                        min: 1.0,
                        max: 20.0,
                        onChanged: (val) {
                          setState(() {
                            strokeWidth = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<DrawnPoint?> points;

  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// Principal entry point for Drawing App
void main() {
  runApp(const DrawingApp());
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({Key? key}) : super(key: key);

  @override
  State<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  // Feature: Canvas & Brush properties (#1, #2)
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  void clearCanvas() {
    // Feature: Clear canvas implementation (#4)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawing App')),
      body: const Center(child: Text('Lienzo de dibujo')),
    );
  }
}

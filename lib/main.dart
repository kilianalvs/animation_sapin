import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Joyeux Noël'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  bool isDouble = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
      duration: const Duration(seconds: 25)
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isDouble = !isDouble;
                });
              },
              child: Text(isDouble ? "Simple spirale" : "Double spirale")
          )
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.66),
                painter: TreePainter(rotationValue: _controller.value, isDouble: isDouble),
              );
            }),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final double rotationValue;
  final bool isDouble;

  TreePainter({required this.rotationValue, required this.isDouble});

  @override
  void paint(Canvas canvas, Size size) {
    int turn = 8;
    int points = 50;

    final paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 2.0;

    final centerX = size.width / 2;
    final centerY = size.height * 0.8;
    final maxRadius = size.width / 2;
    final heightPerTurn = size.height / (turn * 1.5);

    for (int i = 0; i < turn * points; i++){
      final double t = i / (turn * points);
      final double baseAngle = t * turn * 2 * pi;
      final double radius = maxRadius * (1 - t);
      final double heightOffset = t * turn * heightPerTurn;
      final double angle = baseAngle - (rotationValue * 2 * pi);
      
      final double redX = centerX + radius * cos(angle);
      final double redY = centerY - heightOffset;
      
      paint.color = Colors.red;
      canvas.drawCircle(Offset(redX, redY), 2, paint);

      if (isDouble) {
        final double greenAngle = angle + (pi/2);
        final greenX = centerX + radius * cos(greenAngle);

        paint.color = Colors.green;
        canvas.drawCircle(Offset(greenX, redY), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}
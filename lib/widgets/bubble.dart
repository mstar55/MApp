import 'package:flutter/material.dart';
import 'dart:math';

class FloatingBubble extends StatefulWidget {
  final Icon icon;
  final bool shrink;
  final bool onScreen;

  const FloatingBubble({
    super.key,
    required this.icon,
    required this.shrink,
    required this.onScreen,
  });

  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  final Random _random = Random();
  bool _isSelected = false;
  bool canShowTrackingTip = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + _random.nextInt(3)),
      vsync: this,
    )..repeat(reverse: true);

    _xAnimation = Tween<double>(
      begin: -10 + _random.nextDouble() * 20,
      end: -10 + _random.nextDouble() * 30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _yAnimation = Tween<double>(
      begin: -10 + _random.nextDouble() * 20,
      end: -10 + _random.nextDouble() * 25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              top: 50 + _yAnimation.value,
              left: 50 + _xAnimation.value,
              width: _isSelected
                  ? 160
                  : widget.shrink
                  ? 60
                  : 80,
              height: _isSelected
                  ? 160
                  : widget.shrink
                  ? 60
                  : 80,
              child: GestureDetector(
                onTap: () {
                  if(!_isSelected && canShowTrackingTip)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Hold the bubble to see path'),
                            duration: Duration(seconds: 3)
                        ),
                      );
                      canShowTrackingTip = false;
                      Future.delayed(const Duration(seconds: 5), (){
                        canShowTrackingTip = true;
                      });
                    }
                  setState(() {
                    _isSelected = !_isSelected;
                  });
                },
                child: Tooltip(
                message: 'testing',
                child: Container(
                  decoration: BoxDecoration(
                    color: _isSelected ? Colors.white : Colors.deepPurpleAccent[100],
                    borderRadius: BorderRadius.circular(_isSelected ? 20 : 80),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.black,
                      size: _isSelected ? 28 : 20,
                    ),
                    child: widget.icon,
                  ),
                ),
              ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

class FloatingBubble extends StatefulWidget {
  final Icon icon;
  final bool shrink; // icon + metadata form or more details form
  final double zoom;
  final String description; // more details

  const FloatingBubble({
    super.key,
    required this.icon,
    required this.shrink,
    required this.zoom,
    required this.description,
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
      begin: -10 + _random.nextDouble() * 10,
      end: -10 + _random.nextDouble() * 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _yAnimation = Tween<double>(
      begin: -10 + _random.nextDouble() * 10,
      end: -10 + _random.nextDouble() * 10,
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
        return Center(
          child: GestureDetector(
            onTap: () {
              if (!_isSelected && canShowTrackingTip) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hold the bubble to trace path'),
                    duration: Duration(seconds: 3),
                  ),
                );
                canShowTrackingTip = false;
                Future.delayed(const Duration(seconds: 5), () {
                  canShowTrackingTip = true;
                });
              }
              setState(() {
                _isSelected = !_isSelected;
              });
            },
            child: Tooltip(
              message: 'Tracing...',
              child: Transform.translate(
                offset: Offset(_xAnimation.value, _yAnimation.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  width: _isSelected ? 200 : 50,
                  height: _isSelected ? 200 : 50,
                  decoration: BoxDecoration(
                    color: _isSelected
                        ? Colors.white
                        : Colors.deepPurpleAccent[100],
                    borderRadius:
                    BorderRadius.circular(_isSelected ? 20 : 80),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconTheme(
                    data: const IconThemeData(
                      color: Colors.black,
                      size: 20,
                    ),
                    child: widget.icon,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

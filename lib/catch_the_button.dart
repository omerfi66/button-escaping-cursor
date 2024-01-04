import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Kullanıcı Adı",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Şifre",
                  border: InputBorder.none,
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: AnimatedLoginButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLoginButton extends StatefulWidget {
  const AnimatedLoginButton({Key? key}) : super(key: key);

  @override
  AnimatedLoginButtonState createState() => AnimatedLoginButtonState();
}

class AnimatedLoginButtonState extends State<AnimatedLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final Random _random = Random();
  late Offset _currentOffset;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _currentOffset = _getRandomOffset();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _currentOffset,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_isHovered) {
            Timer(const Duration(seconds: 1), () {
              if (_isHovered) {
                setState(() {
                  _controller.reset();
                  _controller.forward();
                  _updateRandomOffset();
                });
              }
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getRandomOffset() {
    double x = (_random.nextDouble() * 10 - 5) * (_random.nextBool() ? 1 : -1);
    double y = (_random.nextDouble() * 10 - 5) * (_random.nextBool() ? 1 : -1);
    return Offset(x, y);
  }

  void _updateRandomOffset() {
    _offsetAnimation = Tween<Offset>(
      begin: _offsetAnimation.value,
      end: _getRandomOffset(),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MouseRegion(
          onEnter: (_) {
            _isHovered = true;
            if (!_controller.isAnimating) {
              _controller.forward();
            }
          },
          onExit: (_) {
            _isHovered = false;
            _controller.reverse().whenComplete(() {
              setState(() {
                _currentOffset = _getRandomOffset();
                _offsetAnimation = Tween<Offset>(
                  begin: _offsetAnimation.value,
                  end: _currentOffset,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut,
                  ),
                );
              });
            });
          },
          child: SlideTransition(
            position: _offsetAnimation,
            child: ElevatedButton(
              onPressed: () {
                // Burada giriş butonuna tıklanınca yapılması gereken işlemleri ekleyebilirsiniz.
              },
              child: const Text('Giriş'),
            ),
          ),
        ),
      ],
    );
  }
}

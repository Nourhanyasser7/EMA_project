import 'package:flutter/material.dart';
import 'dart:async';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  static const Color primaryColor = Color(0xFF5988AA);
  static const Color backgroundColor = Color(0xFFCFE0FA);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, "/signup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Gradient Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
               
              ),
            ),
          ),

          // Main Content with Fade Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Circular Avatar
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: const Color.fromARGB(255, 218, 232, 242),
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundColor: primaryColor,
                     
                      child: Icon(
                          Icons.store, 
                          size: 70, 
                           color: Colors.white, // Change to match your theme
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    "Welcome to Our App!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  // Subtitle Text
                  const Text(
                    "Your journey starts here. Sign in or create an account to continue.",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Get Started Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                        ),
                      );
                  },
                    child: const Text(
                      "  Sign Up  ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Login Button with Border
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryColor, width: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                     onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                        ),
                      );
                  },
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 18, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

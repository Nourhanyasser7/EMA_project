import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mobile_project/screens/store_list_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  bool isVisible = false;
  String? errorMessage;

  static const primaryColor = Color.fromARGB(255, 89, 136, 170);

  Future<void> login() async {
  try {
    final response = await _dio.post('/login/', data: {
      'email': emailController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      final message = response.data['message'] ?? 'Login Successfully';
      setState(() {
        errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreListScreen()),
      );
    } else {
      final error = response.data['error'] ?? 'Login failed. Please try again.';
      setState(() {
        errorMessage = error;
      });
    }
  } on DioException catch (e) {
    final error = e.response?.data['error'] ??
        e.response?.data['detail'] ??
        'Login failed. Please check your credentials.';
    setState(() {
      errorMessage = error;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.01),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ),
                  buildTextField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock,
                    obscure: !isVisible,
                    suffix: IconButton(
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 124, 6, 6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    width: 340,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryColor,
                    ),
                    child: TextButton(
                      onPressed: login,
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Center(
      child: SizedBox(
        width: 360,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(255, 218, 232, 242),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              icon: Icon(icon),
              hintText: hint,
              border: InputBorder.none,
              suffixIcon: suffix,
            ),
          ),
        ),
      ),
    );
  }
}

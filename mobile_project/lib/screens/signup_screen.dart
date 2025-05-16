import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  String name = '';
  String? gender;
  String email = '';
  String ?level;
  String password = '';
  String confirmPassword = '';

  final Color primaryColor = const Color.fromARGB(255, 89, 136, 170);
  final Color backgroundColor = const Color.fromARGB(255, 236, 239, 241);
  final Color fieldColor = const Color.fromARGB(255, 218, 232, 242);

  Future<void> _signup() async {
    try {
      final response = await _dio.post('/signup/', data: {
        'name': name,
        'gender': gender,
        'email': email,
        'level': level,
        'password': password,
        'confirm_password': confirmPassword,
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup successful!',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unexpected error: ${response.statusCode}',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
          ),
        );
      }
    } on DioError catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Signup failed:';
        if (errorData is Map<String, dynamic>) {
          errorData.forEach((key, value) {
            errorMessage += '\n$key: ${value is List ? value.join(', ') : value}';
          });
        } else {
          errorMessage += ' ${e.response!.data.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup failed: Network or server error',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Signup failed: ${e.toString()}',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "SIGN UP",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 89, 136, 170),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
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
          Container(color: Colors.black.withOpacity(0.01)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildInputField(
                      icon: Icons.person,
                      hintText: 'Full Name',
                      onChanged: (val) => name = val,
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Gender:", style: TextStyle(fontSize: 16)),
                    ),
                    Row(
                      children: ['M', 'F'].map((g) {
                        return Expanded(
                          child: RadioListTile<String>(
                            title: Text(g),
                            value: g,
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    buildInputField(
                      icon: Icons.email,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => email = val,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: (level != null && level!.isNotEmpty) ? level : null,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.school),
                          border: InputBorder.none,
                        ),
                        hint: const Text('Select Level'),
                        items: ['1', '2', '3', '4']
                            .map((l) => DropdownMenuItem(value: l, child: Text('Level $l')))
                            .toList(),
                        onChanged: (val) => setState(() => level = val ?? ''),
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildInputField(
                      icon: Icons.lock,
                      hintText: 'Password',
                      obscureText: true,
                      onChanged: (val) => password = val,
                    ),
                    const SizedBox(height: 12),
                    buildInputField(
                      icon: Icons.lock_outline,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      onChanged: (val) => confirmPassword = val,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 145, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _signup,
                      child: const Text(
                        'Signup',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            "LOG IN",
                            style: TextStyle(
                              color: Color.fromARGB(255, 89, 136, 170),
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
          ),
        ],
      ),
    );
  }

  Widget buildInputField({
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    void Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: fieldColor,
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}

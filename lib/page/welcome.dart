import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAccount = prefs.getBool('hasAccount') ?? false;

    Timer(const Duration(seconds: 5), () {
      if (hasAccount) {
        context.go('/home_page');
      } else {
        context.go('/connexion');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffD8EAEC), Color(0xff0E4F57)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ToDo-List',
              style: GoogleFonts.courgette(
                color: const Color(0xff000000),
                fontSize: 55,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset('assets/img/cahier.png', width: 70, height: 70),
          ],
        ),
      ),
    );
  }
}

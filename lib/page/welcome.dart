import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.go('/connexion');
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
              end: Alignment.bottomCenter)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ToDo-List',
            style: GoogleFonts.courgette(
                color: const Color(0xff000000),
                fontSize: 55,
                fontWeight: FontWeight.bold),
          ),
          Image.asset(width: 70, height: 70, 'assets/img/cahier.png')
        ],
      ),
    ));
  }
}

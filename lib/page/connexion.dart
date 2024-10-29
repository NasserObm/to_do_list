// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/object/user.dart';
import 'package:http/http.dart' as http;

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  late User user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    user = User(nom: '', email: '', passWord: '');
    // Ajout d'un délai pour charger les données après le démarrage
    Future.delayed(const Duration(seconds: 1), _loadUserData);
  }

  Future<void> saveUserData(Map<String, dynamic> user, String token) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user', jsonEncode(user));
    await preferences.setString('accessToken', token);
    print("Données utilisateur sauvegardées : $user et accessToken : $token");
  }

  Future<bool> connexion(String email, String password) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/auth/connexion');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Connexion réussie : ${data['user']}");
        await saveUserData(data['user'], data['acessToken']);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Erreur détectée lors de la connexion")));
        print('Erreur de réponse : ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Une erreur s'est produite.")));
      print('Erreur lors de la requête : $error');
      return false;
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      try {
        final decodedUser = jsonDecode(userData) as Map<String, dynamic>;
        setState(() {
          user.nom = decodedUser['nom'] ?? '';
          user.email = decodedUser['email'] ?? '';
          user.passWord = decodedUser['password'] ?? '';
        });
        print("Données utilisateur chargées : $decodedUser");
      } catch (e) {
        print("Erreur lors du décodage des données utilisateur : $e");
      }
    } else {
      print("Aucune donnée utilisateur trouvée dans SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text(
              'ToDoList',
              style: GoogleFonts.montserrat(
                color: const Color(0xff0E4F57),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xff0E4F57),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color(0xff0E4F57),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xff0E4F57),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 3) {
                    return 'Le mot de passe doit contenir au moins 3 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      bool success = await connexion(
                          _emailController.text, _passwordController.text);
                      if (success) {
                        context.go('/home_page');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0E4F57),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Text(
                    'Se connecter',
                    style: GoogleFonts.montserrat(
                        color: const Color(0xffffffff),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  context.go('/enregistrer');
                },
                child: Text(
                  'Vous n\'avez pas de compte? Cliquez ici',
                  style: GoogleFonts.montserrat(
                      color: const Color(0xff0E4F57),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationColor: const Color(0xff0E4F57)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/object/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final User user;
  @override
  void initState() {
    super.initState();
    user = User(nom: '', email: '', passWord: '');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user.nom = prefs.getString('nom') ?? '';
      user.email = prefs.getString('email') ?? '';
      user.passWord = prefs.getString('password') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _nomController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Color(0xff0E4F57),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Center(
                    child: Text(
                      'ToDoList',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xff0E4F57),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Tache',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.note_alt_outlined,
                        color: Color(0xff0E4F57),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0E4F57),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        'Soumettre',
                        style: GoogleFonts.montserrat(
                            color: const Color(0xffffffff),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Liste des Taches',
                    style: GoogleFonts.montserrat(
                        color: const Color(0xff000000),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 2,
        child: Container(
          color: const Color(0xff0E4F57),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                // ignore: sort_child_properties_last
                child: Text(
                  'Profil de ${user.nom}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xff0E4F57),
                ),
              ),
              ListTile(
                title: const Text('Paramètres',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.go('/compte');
                },
              ),
              ListTile(
                title: const Text('Déconnexion',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.go('/connexion');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

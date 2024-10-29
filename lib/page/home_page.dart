import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/object/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final User user;
  List<Map<String, dynamic>> tasks = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = User(nom: '', email: '', passWord: '');
    _loadUserData();
    _fetchTasks();
  }

  // Méthode pour charger les informations de l'utilisateur
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
      } catch (e) {
        print("Erreur lors du décodage des données utilisateur : $e");
      }
    } else {
      print("Aucune donnée utilisateur trouvée dans SharedPreferences");
    }
  }

  // Méthode pour récupérer la liste des tâches
  Future<void> _fetchTasks() async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task'); // Remplace API_URL par l'URL de l'API pour obtenir les tâches
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          tasks = data.map((task) => task as Map<String, dynamic>).toList();
        });
      } else {
        print(
            'Erreur lors de la récupération des tâches : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  // Méthode pour ajouter une nouvelle tâche
  Future<void> _addTask(String taskName) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task'); // Remplace API_URL par l'URL de l'API pour créer une tâche
    final body = jsonEncode({'name': taskName});

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 201) {
        _fetchTasks();
        _taskController.clear();
      } else {
        print('Erreur lors de l\'ajout de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  // Méthode pour modifier une tâche par son ID
  Future<void> _updateTask(int taskId, String updatedName) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$taskId'); // Remplace API_URL par l'URL de l'API pour modifier une tâche
    final body = jsonEncode({'name': updatedName});

    try {
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200) {
        _fetchTasks();
      } else {
        print(
            'Erreur lors de la mise à jour de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  // Méthode pour supprimer une tâche par son ID
  Future<void> _deleteTask(int taskId) async {
    final url = Uri.parse(
        'https://todolist-api-production-1e59.up.railway.app/task/$taskId'); // Remplace API_URL par l'URL de l'API pour supprimer une tâche

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _fetchTasks();
      } else {
        print(
            'Erreur lors de la suppression de la tâche : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de requête : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoList',
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(
                  labelText: 'Nouvelle tâche', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty
                  ? 'Veuillez entrer une tâche'
                  : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addTask(_taskController.text),
              child:
                  Text('Ajouter', style: GoogleFonts.montserrat(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('Aucune tâche disponible'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task['name'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _updateTask(
                                    task['id'], 'Nouveau Nom de Tâche'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteTask(task['id']),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Profil de ${user.nom}',
                  style: const TextStyle(color: Colors.white, fontSize: 24)),
              decoration: const BoxDecoration(color: Color(0xff0E4F57)),
            ),
            ListTile(
              title: const Text('Paramètres',
                  style: TextStyle(color: Colors.white)),
              onTap: () => context.go('/compte'),
            ),
            ListTile(
              title: const Text('Déconnexion',
                  style: TextStyle(color: Colors.white)),
              onTap: () => context.go('/connexion'),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  String nom;
  String email;
  String passWord;

  User({required this.email, required this.passWord, required this.nom});

  Map<String, dynamic> toMap() {
    return {'nom': nom, 'email': email, 'password': passWord};
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        email: map['email'], passWord: map['password'], nom: map['nom']);
  }
}

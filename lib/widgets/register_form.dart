import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

/// [RegisterForm] est un widget qui gère le formulaire d'inscription.
/// Il permet aux utilisateurs de créer un nouveau compte en fournissant
/// leurs informations personnelles (prénom, nom, email, mot de passe).
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

/// État mutable du formulaire d'inscription.
/// Gère les contrôleurs de texte, l'état de chargement et la logique d'inscription.
class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;

  String? validatePassword(String value) {
    if (value.length < 8) return "8 caractères minimum";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "1 majuscule requise";
    if (!RegExp(r'[a-z]').hasMatch(value)) return "1 minuscule requise";
    if (!RegExp(r'[0-9]').hasMatch(value)) return "1 chiffre requis";
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) return "1 symbole requis";
    return null;
  }

  /// Effectue la requête d'inscription auprès de l'API backend.
  ///
  /// Valide d'abord que les mots de passe correspondent, puis envoie
  /// les données utilisateur au serveur. Gère les réponses et les erreurs
  /// avec des messages SnackBar.
  Future<void> register() async {
      print("Début register");

    // Vérifier que les deux mots de passe sont identiques
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    setState(() => loading = true);

    final String url = "$apiUrl/auth/register";
    print("URL: $url");

    try {
      // Envoyer les données d'inscription au serveur
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "firstname": firstNameController.text,
          "lastname": lastNameController.text,
          "role": "learner",
          "password": passwordController.text,
          "password_confirmation": confirmPasswordController.text,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé avec succès")),
        );

        Navigator.pop(context);
      } else {
        // Afficher l'erreur API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur API ${response.statusCode}")),
        );
      }
    } catch (e) {
      // Gérer les erreurs de réseau
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur réseau : $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // En-tête avec icône d'ajout de personne
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE7E7E1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_add,
              color: Color(0xFF3A4D39),
              size: 30,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Créer un compte",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            "Rejoignez API quiz dès maintenant",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: inputStyle("Prénom", Icons.person),
                          validator: (v) => v!.isEmpty ? "Requis" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: inputStyle("Nom", Icons.person),
                          validator: (v) => v!.isEmpty ? "Requis" : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: emailController,
                    decoration: inputStyle("Email", Icons.mail_outline),
                    validator: (v) => v!.isEmpty ? "Email requis" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputStyle("Mot de passe", Icons.lock),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Mot de passe requis";
                      }
                      return validatePassword(v);
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: inputStyle(
                      "Confirmer le mot de passe",
                      Icons.lock,
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Confirmation requise" : null,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3A4D39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                register();
                              }
                            },
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Créer mon compte",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous avez déjà un compte ? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Color(0xFFE85D45),
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

  /// Retourne un style de décoration standardisé pour les champs TextFormField.
  ///
  /// Paramètres :
  /// - [hint] : le texte d'indication affiché dans le champ
  /// - [icon] : l'icône affichée à gauche du champ
  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

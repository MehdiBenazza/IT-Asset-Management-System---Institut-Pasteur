import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_form.dart';
// import du controller si existant
// import 'user_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Utilisateurs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Naviguer vers le formulaire d'ajout d'utilisateur
              Get.to(() => UserForm(
                    onSubmit: (user) {
                      // TODO: Ajouter l'utilisateur via UserController
                      Get.back();
                      Get.snackbar("Succès", "Utilisateur ajouté");
                    },
                  ));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // ⚠️ à remplacer par tes données dynamiques
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text("Utilisateur #$index"),
            subtitle: const Text("email@example.com"),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  // Naviguer vers le formulaire d'édition
                  Get.to(() => UserForm(
                        initial: null, // Remplacer par l'utilisateur à éditer
                        onSubmit: (user) {
                          // TODO: Modifier l'utilisateur via UserController
                          Get.back();
                          Get.snackbar("Succès", "Utilisateur modifié");
                        },
                      ));
                } else if (value == "delete") {
                  // Appeler la suppression via UserController
                  // TODO: Supprimer l'utilisateur via UserController
                  Get.snackbar("Supprimer", "Suppression utilisateur #$index");
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "edit",
                  child: Text("Modifier"),
                ),
                const PopupMenuItem(
                  value: "delete",
                  child: Text("Supprimer"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

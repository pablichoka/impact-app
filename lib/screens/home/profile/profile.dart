import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: theme.colorScheme.secondary,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                        'https://placehold.co/400.png',
                      ), // Placeholder image
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '${user.name} ${user.lastName}', // Usa los datos del User
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              color: theme.colorScheme.secondary,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Otros Datos del Perfil:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: ${user.email}', // Usa los datos del User
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nombre de usuario: ${user.username}', // Usa los datos del User
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Miembro desde: ${user.joinDate}', // Usa y formatea los datos del User
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    if (user.birthDate != null) ...[
                      // Muestra la fecha de nacimiento si está disponible
                      const SizedBox(height: 8.0),
                      Text(
                        'Fecha de nacimiento: ${(user.birthDate!)}',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ],
                    const SizedBox(height: 8.0),
                    Text(
                      'Premium: ${user.isPremium ? "Sí" : "No"}', // Usa los datos del User
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(), // Pushes buttons to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    onPressed: () {
                      // TODO: Implementar lógica de edición
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme
                          .colorScheme
                          .primary, // Changed text and icon color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    onPressed: () {
                      // TODO: Implementar lógica de cierre de sesión
                      Navigator.pushReplacementNamed(
                        context,
                        '/init',
                      ); // Navigate to InitScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: theme
                          .colorScheme
                          .primary, // Changed text and icon color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

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
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Nombre del Usuario', // Placeholder name
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: usuario@example.com', // Placeholder data
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Teléfono: +1234567890', // Placeholder data
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Miembro desde: Enero 2023', // Placeholder data
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
                      foregroundColor: theme.colorScheme.primary, // Changed text and icon color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),                
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    onPressed: () {
                      // TODO: Implementar lógica de cierre de sesión
                      Navigator.pushReplacementNamed(context, '/init'); // Navigate to InitScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: theme.colorScheme.primary, // Changed text and icon color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
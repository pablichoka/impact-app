import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final String userName = "Usuario";
  final int remainingCredits = 75;
  final String otherData = "Nivel 5";

  final List<Map<String, String>> announcements = const [
    {
      "title": "¡Mantenimiento Programado!",
      "content": "El sistema estará en mantenimiento el próximo sábado de 02:00 a 04:00 AM.",
      "date": "10 de junio de 2025"
    },
    {
      "title": "Nuevas Funcionalidades Disponibles",
      "content": "Hemos lanzado una actualización con nuevas herramientas para mejorar tu experiencia.",
      "date": "5 de junio de 2025"
    },
    {
      "title": "Oferta Especial de Verano",
      "content": "¡Aprovecha un 20% de descuento en todos los planes hasta fin de mes!",
      "date": "1 de junio de 2025"
    },{
      "title": "¡Mantenimiento Programado!",
      "content": "El sistema estará en mantenimiento el próximo sábado de 02:00 a 04:00 AM.",
      "date": "10 de junio de 2025"
    },
    {
      "title": "Nuevas Funcionalidades Disponibles",
      "content": "Hemos lanzado una actualización con nuevas herramientas para mejorar tu experiencia.",
      "date": "5 de junio de 2025"
    },
    {
      "title": "Oferta Especial de Verano",
      "content": "¡Aprovecha un 20% de descuento en todos los planes hasta fin de mes!",
      "date": "1 de junio de 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding( // Añadimos Padding aquí para todo el contenido
        padding: const EdgeInsets.all(16.0),
        child: Column( // Usamos Column como el widget principal del body
          crossAxisAlignment: CrossAxisAlignment.start, // Para alinear el texto de bienvenida a la izquierda
          children: <Widget>[
            Text(
              '¡Bienvenido de nuevo, $userName!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),

            Card(
              elevation: 4.0,
              color: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tu Resumen',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSecondary, // Ajustado para contraste con 'secondary'
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Créditos Restantes:',
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSecondary),
                        ),
                        Text(
                          '$remainingCredits',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Otros Datos:',
                           style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSecondary),
                        ),
                        Text(
                          otherData,
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // 3. Sección de Anuncios y Comunicaciones
            Text(
              'Anuncios y Comunicaciones',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded( // Expanded permite que ListView.builder ocupe el espacio restante y sea scrollable
              child: announcements.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'No hay anuncios por el momento.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(), // Puedes mantener esto si te gusta el efecto
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          color: theme.colorScheme.surfaceContainerHighest, // Usar un color de tarjeta del tema
                           shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              announcement['title']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "${announcement['content']!}\n${announcement['date']!}",
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
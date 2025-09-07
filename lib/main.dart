import 'package:flutter/material.dart';
import 'package:impact/screens/init.dart';
import 'package:impact/screens/home.dart';
import 'package:impact/theme_data.dart';
import 'package:impact/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debug: show existing firebase apps before initialization
  debugPrint('firebase: existing apps before init = ${Firebase.apps.length}');
  // avoid duplicate Firebase app initialization
  try {
    if (Firebase.apps.isEmpty) {
      // initialize default firebase app with platform options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('firebase: initialized default app');
    }
  } on FirebaseException catch (e) {
    // ignore duplicate-app error which can occur in some dev environments
    debugPrint('firebase: initialize exception code=${e.code} message=${e.message}');
    if (e.code != 'duplicate-app') rethrow;
  }
  debugPrint('firebase: existing apps after init = ${Firebase.apps.length}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact',
      theme: lightThemeData, 
      darkTheme: darkThemeData, 
      themeMode: ThemeMode.system, 
      home: const _AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/init': (context) => const InitScreen(),
        '/home': (context) => const HomeScreen(),        
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }
        if (!user.emailVerified) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please verify your email'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email sent')));
                    },
                    child: const Text('Resend'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await user.reload();
                    },
                    child: const Text('I verified'),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Logout'),
                  )
                ],
              ),
            ),
          );
        }
        return const HomeScreen();
      },
    );
  }
}
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:impact/services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();
  final _signupConfirmCtrl = TextEditingController();
  bool _loginObscure = true;
  bool _signupObscure = true;
  bool _signupConfirmObscure = true;
  bool _loading = false;
  String? _error;
  final _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPasswordCtrl.dispose();
    _signupConfirmCtrl.dispose();
    super.dispose();
  }

  void _setError(String? msg) {
    setState(() => _error = msg);
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();
    setState(() { _loading = true; _error = null; });
    try {
      await _authService.signInEmail(_loginEmailCtrl.text.trim(), _loginPasswordCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _setError('login failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onSignup() async {
    FocusScope.of(context).unfocus();
    final p1 = _signupPasswordCtrl.text.trim();
    final p2 = _signupConfirmCtrl.text.trim();
    if (p1 != p2) { _setError('passwords do not match'); return; }
    if (p1.length < 8) { _setError('weak password'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      await _authService.signUpEmail(_signupEmailCtrl.text.trim(), p1);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created. Check verification email.')));
      _tabController.animateTo(0);
    } catch (e) {
      _setError('signup failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onResetPassword() async {
    final email = _loginEmailCtrl.text.trim();
    if (email.isEmpty) { _setError('enter email first'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      await _authService.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent')));
    } catch (e) {
      _setError('reset failed');
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _onSocial(String provider) async {
    setState(() { _loading = true; _error = null; });
    try {
      if (provider == 'google') {
        await _authService.signInGoogle();
      } else if (provider == 'microsoft') {
        throw Exception('microsoft not implemented');
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$provider sign in failed')));
      }
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscure=false, VoidCallback? onToggle, TextInputAction action=TextInputAction.next, void Function(String)? onFieldSubmitted}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: theme.colorScheme.onSurface),
      textInputAction: action,
      onSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        suffixIcon: onToggle != null ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: theme.colorScheme.onSurfaceVariant),
          onPressed: onToggle,
        ) : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isDark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _loginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField(controller: _loginEmailCtrl, label: 'Email'),
          const SizedBox(height: 12),
          _buildTextField(controller: _loginPasswordCtrl, label: 'Password', obscure: _loginObscure, onToggle: () => setState(()=> _loginObscure = !_loginObscure), action: TextInputAction.done, onFieldSubmitted: (_) => _onLogin()),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _loading ? null : _onResetPassword,
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _onLogin,
              child: _loading ? const SizedBox(height:20,width:20,child: CircularProgressIndicator(strokeWidth:2)) : const Text('Login'),
            ),
          ),
          const SizedBox(height: 16),
          _socialButtons(),
        ],
      ),
    );
  }

  Widget _signupForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField(controller: _signupEmailCtrl, label: 'Email'),
          const SizedBox(height: 12),
          _buildTextField(controller: _signupPasswordCtrl, label: 'Password', obscure: _signupObscure, onToggle: () => setState(()=> _signupObscure = !_signupObscure)),
          const SizedBox(height: 12),
          _buildTextField(controller: _signupConfirmCtrl, label: 'Confirm Password', obscure: _signupConfirmObscure, onToggle: () => setState(()=> _signupConfirmObscure = !_signupConfirmObscure)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _onSignup,
              child: _loading ? const SizedBox(height:20,width:20,child: CircularProgressIndicator(strokeWidth:2)) : const Text('Create account'),
            ),
          ),
          const SizedBox(height: 16),
          _socialButtons(),
        ],
      ),
    );
  }

  Widget _socialButtons() {
    final buttons = <Widget>[
      _SocialBtn(label: 'Continue with Google', icon: Icons.g_mobiledata, color: Colors.white, textColor: Colors.black, onTap: _loading ? null : () => _onSocial('google')),
      _SocialBtn(label: 'Continue with Microsoft', icon: Icons.window, color: const Color(0xFF2F2F2F), textColor: Colors.white, onTap: _loading ? null : () => _onSocial('microsoft')),
    ];
    if (Platform.isIOS) {
      buttons.add(_SocialBtn(label: 'Continue with Apple', icon: Icons.apple, color: Colors.black, textColor: Colors.white, onTap: _loading ? null : () => _onSocial('apple')));
    }
    return Column(
      children: [
        const SizedBox(height: 8),
        for (final b in buttons) ...[
          b,
          const SizedBox(height: 10),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.surface : theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        backgroundColor: isDark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primary,
        foregroundColor: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Sign up'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_error != null)
            Container(
              width: double.infinity,
              color: theme.colorScheme.error.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: TextStyle(color: theme.colorScheme.error))),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.error),
                    onPressed: () => _setError(null),
                  )
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _loginForm(),
                _signupForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  const _SocialBtn({required this.label, required this.icon, required this.color, required this.textColor, this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

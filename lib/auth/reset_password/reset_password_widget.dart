import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  static const String routeName = 'ResetPassword';
  static const String routePath = '/reset-password';

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _loading = true;
  bool _submitting = false;
  String? _email;
  String? _oobCode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initializeResetFlow();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _readParam(String key) {
    final direct = Uri.base.queryParameters[key];
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final nestedLink = Uri.base.queryParameters['link'] ??
        Uri.base.queryParameters['continueUrl'] ??
        Uri.base.queryParameters['deep_link_id'];
    if (nestedLink == null || nestedLink.isEmpty) {
      return null;
    }

    try {
      final nested = Uri.parse(nestedLink);
      return nested.queryParameters[key];
    } catch (_) {
      return null;
    }
  }

  Future<void> _initializeResetFlow() async {
    final mode = _readParam('mode');
    final oobCode = _readParam('oobCode');

    if (mode != 'resetPassword' || oobCode == null || oobCode.isEmpty) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Invalid or incomplete reset link.';
        _loading = false;
      });
      return;
    }

    try {
      final email = await FirebaseAuth.instance.verifyPasswordResetCode(oobCode);
      if (!mounted) return;
      setState(() {
        _oobCode = oobCode;
        _email = email;
        _loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.message ?? 'This reset link is invalid or expired.';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Unable to validate reset link.';
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_oobCode == null) return;

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: _oobCode!,
        newPassword: password,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      context.goNamed(AutWidget.routeName);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Unable to reset password')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorText != null
                      ? _buildErrorState(theme)
                      : _buildResetForm(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(FlutterFlowTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Reset link issue',
          style: theme.headlineMedium.override(
            fontFamily: theme.headlineMediumFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            useGoogleFonts: !theme.headlineMediumIsCustom,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _errorText!,
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.secondaryText,
            letterSpacing: 0,
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.goNamed(AutWidget.routeName),
          child: const Text('Back to Login'),
        ),
      ],
    );
  }

  Widget _buildResetForm(FlutterFlowTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Set a new password',
          style: theme.headlineMedium.override(
            fontFamily: theme.headlineMediumFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            useGoogleFonts: !theme.headlineMediumIsCustom,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _email == null ? 'Reset your password' : 'Account: $_email',
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.secondaryText,
            letterSpacing: 0,
            useGoogleFonts: !theme.bodyMediumIsCustom,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: 'New Password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _passwordVisible = !_passwordVisible);
              },
              icon: Icon(
                  _passwordVisible ? Icons.visibility_off : Icons.visibility),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_confirmPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(
                    () => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
              icon: Icon(_confirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update Password'),
        ),
      ],
    );
  }
}

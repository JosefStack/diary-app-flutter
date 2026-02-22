import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _user = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    if (name.trim().isEmpty) {
      _error = "Please enter your name.";
      notifyListeners();
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _error = "Please enter a valid email address.";
      notifyListeners();
      return;
    }

    if (password.length < 6) {
      _error = "Password must be at least 6 characters.";
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      if (response.user != null && response.session == null) {
        _error = "Account created! Please check your email to confirm.";
      }
    } catch (e) {
      _error = e.toString().contains('already registered')
          ? "This email is already in use."
          : e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

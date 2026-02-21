import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Memoir',
                style: GoogleFonts.indieFlower(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 70)
              ),
              const SizedBox(height: 5),
              Text(
                'Welcome to your safe space.',
                 style: GoogleFonts.indieFlower(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 20)
              ),
              const SizedBox(height: 30),
              Container(
                
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final messenger = ScaffoldMessenger.of(context);
                                if (_isLogin) {
                                  await auth.signIn(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else {
                                  await auth.signUp(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                                
                                if (auth.error != null) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text(auth.error!)),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                        
                          backgroundColor:  Colors.teal[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: auth.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isLogin ? 'Sign In' : 'Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? "New here? Create an account" : "Have an account? Sign in",
                   style: GoogleFonts.indieFlower(color: Colors.teal[500],fontWeight: FontWeight.bold,fontSize: 15)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

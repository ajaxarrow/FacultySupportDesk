import 'package:facultysupportdesk/services/auth_service.dart';
import 'package:facultysupportdesk/themes/colors.dart';
import 'package:facultysupportdesk/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isRegister = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgColor,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            width: 800,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: outlineColor,
                width: 1
              ),
              borderRadius: BorderRadius.circular(25), // Set border radius for the second SizedBox
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 400,
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isRegister ? 'Create Your Account' : 'Welcome Back!',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: AuthService().signInWithGoogle,
                                icon: const PhosphorIcon(PhosphorIconsFill.googleLogo),
                                label: Text(isRegister ? 'Register with Google' : 'Login with Google'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: AuthService().signInWithGithub,
                                icon: const PhosphorIcon(PhosphorIconsFill.githubLogo),
                                label: Text(isRegister ? 'Register with Github' : 'Login with Github'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 51),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(isRegister ? 'Already have an account? ' : 'New to the app? '),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        isRegister = !isRegister;
                                      });
                                    },
                                    child: Text(
                                      isRegister ? 'Login here' : 'Register Here',
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff274c77),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                        ),
                        width: 398,
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Faculty Support Desk',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color: highlightColor
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Image.asset('lib/assets/images/auth-image.png'),
                              ),
                              const Text(
                                'Schedule your consultation with faculty directly through Faculty Support Desk',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: highlightColor
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );

  }
}

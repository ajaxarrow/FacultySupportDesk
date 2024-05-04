import 'package:facultysupportdesk/models/app_user.dart';
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
  final _form = GlobalKey<FormState>();
  bool showPassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void resetForm(){
    _form.currentState!.reset();
    emailController.text = '';
    nameController.text = '';
    passwordController.text = '';
  }

  void submit() async{
    final isValid = _form.currentState!.validate();

    AppUser user = AppUser(
        name: nameController.text,
        password: passwordController.text,
        email: emailController.text,
        context: context
    );

    if(!isValid){
      return;
    }
    _form.currentState!.save();
    if(isRegister){
      await user.register();
    } else {
      await user.login();
    }
  }
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
                      SizedBox(
                        width: 400,
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: _form,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Text(
                                    //   'facultysupportdesk.',
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //       fontSize: 25,
                                    //       fontWeight: FontWeight.w900,
                                    //       color: Theme.of(context).colorScheme.primary
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   height: 20,
                                    // ),
                                    Text(
                                      isRegister ? 'Create Account!' : 'Welcome Back!',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    Text(
                                      isRegister ? 'Please register here to continue' : 'Please login here to continue',
                                      style: const TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isRegister ? const SizedBox(
                                      height: 20,
                                    ) : const SizedBox.shrink(),
                                    isRegister ? TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'Complete Name',
                                      ),
                                      validator: (value){
                                        if (value!.trim().isEmpty || value == null || value!.trim().length < 4  ){
                                          return 'Name must atleast have 5 characters';
                                        }
                                        return null;
                                      },
                                    ) : const SizedBox.shrink(),
                                    isRegister ? const SizedBox(
                                      height: 15,
                                    ) : const SizedBox.shrink(),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: 'Email',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization: TextCapitalization.none,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: showPassword,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock),
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                                showPassword ? Icons.visibility : Icons.visibility_off
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          )
                                      ),
                                      validator: (value){
                                        if (value!.trim().isEmpty || value == null || value!.trim().length < 8  ){
                                          return 'Password must atleast have 8 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 18)
                                        ),
                                        onPressed: submit,
                                        child: Text(
                                          isRegister ? 'Register' : 'Login',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(isRegister ? 'Already have an account?' : 'New to platform?'),
                                        TextButton(
                                            onPressed: (){
                                              resetForm();
                                              setState(() {
                                                isRegister = !isRegister;
                                              });
                                            },
                                            child: Text(isRegister ? 'Login here' : 'Register Here')
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                              // Text(
                              //   isRegister ? 'Create Your Account' : 'Welcome Back!',
                              //   style: const TextStyle(
                              //       fontWeight: FontWeight.w900,
                              //       fontSize: 24
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              // ElevatedButton.icon(
                              //   onPressed: AuthService().signInWithGoogle,
                              //   icon: const PhosphorIcon(PhosphorIconsFill.googleLogo),
                              //   label: Text(isRegister ? 'Register with Google' : 'Login with Google'),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 10),
                              // ElevatedButton.icon(
                              //   onPressed: AuthService().signInWithGithub,
                              //   icon: const PhosphorIcon(PhosphorIconsFill.githubLogo),
                              //   label: Text(isRegister ? 'Register with Github' : 'Login with Github'),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 51),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(isRegister ? 'Already have an account? ' : 'New to the app? '),
                              //     GestureDetector(
                              //       onTap: (){
                              //         setState(() {
                              //           isRegister = !isRegister;
                              //         });
                              //       },
                              //       child: Text(
                              //         isRegister ? 'Login here' : 'Register Here',
                              //         style: const TextStyle(
                              //           decoration: TextDecoration.underline,
                              //         ),
                              //       ),
                              //     ),
                              //
                              //   ],
                              // )

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

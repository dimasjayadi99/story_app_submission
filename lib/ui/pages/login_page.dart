import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/provider/login_provider.dart';
import 'package:submission_story_app/shared/widgets/custom_button.dart';
import 'package:submission_story_app/shared/widgets/custom_text_field.dart';
import 'package:submission_story_app/shared/widgets/gap.dart';
import 'package:submission_story_app/utils/custom_snack_bar.dart';
import 'package:submission_story_app/utils/form_validation.dart';

class LoginPage extends StatefulWidget {
  final Function(String) processLogin;
  final VoidCallback toRegisterPage;
  const LoginPage(
      {super.key, required this.processLogin, required this.toRegisterPage});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              height: heightScreen * 0.8,
              width: widthScreen * 0.9,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sign in",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const Gap.v(h: 16),
                    Text("Silahkan masukan alamat email dan password anda",
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Gap.v(h: 16),
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              label: "Email Address",
                              prefixIcon: Icons.email,
                              controller: _emailController,
                              maxLines: 1,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                String? validationMessage =
                                    FormValidation().validateEmail(value);
                                if (validationMessage != null) {
                                  return validationMessage;
                                }
                                return null;
                              },
                            ),
                            const Gap.v(h: 16),
                            CustomTextField(
                              label: "Password",
                              prefixIcon: Icons.lock,
                              isObscure: isObscure,
                              maxLines: 1,
                              suffixIcon: isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixIconTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              controller: _passwordController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                String? validationMessage =
                                    FormValidation().validatePassword(value);
                                if (validationMessage != null) {
                                  return validationMessage;
                                }
                                return null;
                              },
                            ),
                            const Gap.v(h: 32),
                            Column(
                              children: [
                                Consumer<LoginProvider>(
                                  builder: (context, loginProvider, child) {
                                    if (loginProvider.responseState ==
                                        ResponseState.loading) {
                                      return const CircularProgressIndicator();
                                    }

                                    return CustomButton().filledButton(
                                        widthScreen, "Sign in", () async {
                                      final email =
                                          _emailController.text.trim();
                                      final password =
                                          _passwordController.text.trim();
                                      if (formKey.currentState!.validate()) {
                                        await loginProvider.loginAccount(
                                            email, password);
                                        if (loginProvider.responseState ==
                                            ResponseState.success) {
                                          widget.processLogin(
                                              loginProvider.token);
                                          if (context.mounted) {
                                            CustomSnackBar().showSnackBar(
                                                context,
                                                loginProvider.message,
                                                true);
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CustomSnackBar().showSnackBar(
                                                context,
                                                loginProvider.message,
                                                false);
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                                const Gap.v(h: 16),
                                CustomButton().outlinedButton(
                                    widthScreen, "Create an account", () {
                                  widget.toRegisterPage();
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

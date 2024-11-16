import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/common/app_const.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/provider/register_provider.dart';
import 'package:submission_story_app/shared/widgets/custom_button.dart';
import 'package:submission_story_app/shared/widgets/custom_text_field.dart';
import 'package:submission_story_app/shared/widgets/gap.dart';

import '../../utils/custom_snack_bar.dart';
import '../../utils/form_validation.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback processRegister;
  final VoidCallback toLoginPage;
  const RegisterPage(
      {super.key, required this.processRegister, required this.toLoginPage});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.clear();
    _nameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              height: heightScreen * 0.8,
              width: widthScreen * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Register",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Gap.v(h: 16),
                  Text(
                      "Silahkan lengkapi data berikut untuk membuat akun baru.",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Gap.v(h: 16),
                  Expanded(
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              label: "Email Address",
                              prefixIcon: Icons.email,
                              maxLines: 1,
                              controller: _emailController,
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
                              label: "Name",
                              maxLines: 1,
                              prefixIcon: Icons.person,
                              controller: _nameController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == '') {
                                  return AppConst.nameBlank;
                                }
                                return null;
                              },
                            ),
                            const Gap.v(h: 16),
                            CustomTextField(
                              label: "Password",
                              maxLines: 1,
                              prefixIcon: Icons.lock,
                              isObscure: isObscure,
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
                            const Gap.v(h: 16),
                            CustomTextField(
                              label: "Confirm Password",
                              prefixIcon: Icons.lock,
                              maxLines: 1,
                              isObscure: isObscure,
                              suffixIcon: isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              suffixIconTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              controller: _confirmPasswordController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                String? password =
                                    _passwordController.text.trim();
                                if (value != password) {
                                  return AppConst.emailNotMatch;
                                }
                                return null;
                              },
                            ),
                            const Gap.v(h: 32),
                            Consumer<RegisterProvider>(
                                builder: (context, registerProvider, _) {
                              if (registerProvider.responseState ==
                                  ResponseState.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return CustomButton().filledButton(
                                  widthScreen, "Register", () async {
                                if (formKey.currentState!.validate()) {
                                  final email = _emailController.text.trim();
                                  final name = _nameController.text.trim();
                                  final password =
                                      _passwordController.text.trim();
                                  await registerProvider.registerAccount(
                                      name, email, password);
                                  if (registerProvider.responseState ==
                                      ResponseState.success) {
                                    if (context.mounted) {
                                      widget.processRegister();
                                      CustomSnackBar().showSnackBar(context,
                                          registerProvider.message, true);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackBar().showSnackBar(context,
                                          registerProvider.message, false);
                                    }
                                  }
                                }
                              });
                            }),
                            const Gap.v(h: 16),
                            RichText(
                                text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                  const TextSpan(text: "Sudah memiliki akun? "),
                                  TextSpan(
                                    text: "Sign in",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => widget.toLoginPage(),
                                  ),
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:erva_vocubulary/ui/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/register/register_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/register/register_event.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/register/register_state.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<RegisterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  bool get _isPasswordMatching =>
      passwordController.text == passwordAgainController.text;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.formStatus is FormSubmissionSuccess) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        } else if (state.formStatus is FormSubmissionFailed) {
          final error = (state.formStatus as FormSubmissionFailed).exception;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      },
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Username', icon: Icon(Icons.person)),
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterUsernameChanged(username: value)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Email', icon: Icon(Icons.email)),
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterEmailChanged(email: value)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Password', icon: Icon(Icons.lock)),
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (value) => context
                            .read<RegisterBloc>()
                            .add(RegisterPasswordChanged(password: value)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordAgainController,
                        decoration: const InputDecoration(
                            hintText: 'Şifre Tekrar', icon: Icon(Icons.lock)),
                        obscureText: true,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                              RegisterPasswordCheck(
                                  password: passwordController.text,
                                  confirmPassword: value));
                        },
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Şifreler eşleşmiyor';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isPasswordMatching
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<RegisterBloc>()
                                        .add(RegisterSubmitted());
                                  }
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Passwords do not match'),
                                    ),
                                  );
                                },
                          child: const Text('Register'),
                        );
                      },
                    ),
                  ],
                ))),
      ),
    );
  }
}

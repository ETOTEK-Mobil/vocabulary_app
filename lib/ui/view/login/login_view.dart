import 'package:erva_vocubulary/bloc.dart/Auth/login/login.state.dart';
import 'package:erva_vocubulary/ui/view/home/card_swiper_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/login/login_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/login/login_event.dart';
import 'package:erva_vocubulary/ui/view/register/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formStatus is FormSubmissionSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CardSwiperScreen()));
        } else if (state.formStatus is FormSubmissionFailed) {
          final error = (state.formStatus as FormSubmissionFailed).exception;
          _showSnackBar(context, error.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Email', icon: Icon(Icons.person)),
                validator: (value) =>
                    value!.isEmpty ? 'Email cannot be empty' : null,
                onChanged: (value) => context
                    .read<LoginBloc>()
                    .add(LoginEmailChanged(email: value)),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Password', icon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Password cannot be empty' : null,
                onChanged: (value) => context
                    .read<LoginBloc>()
                    .add(LoginPasswordChanged(password: value)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              _registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute<dynamic>(
            builder: (context) => const RegisterView(),
          ),
        );
      },
      child: const Text('Register'),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

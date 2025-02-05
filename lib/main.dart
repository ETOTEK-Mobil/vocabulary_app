import 'package:erva_vocubulary/bloc.dart/Auth/login/login_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Auth/register/register_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/Card/card_bloc.dart';
import 'package:erva_vocubulary/bloc.dart/auth_repository.dart';
import 'package:erva_vocubulary/services/auth_service.dart';
import 'package:erva_vocubulary/ui/view/home/card_swiper_page.dart';
import 'package:erva_vocubulary/ui/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.loggedIn();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.loggedIn, super.key});
  final bool loggedIn;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CardBloc()),
        BlocProvider(
            create: (context) => RegisterBloc(authService: AuthService())),
        BlocProvider(
            create: (context) => LoginBloc(authService: AuthService())),
      ],
      child: MaterialApp(
        home: RepositoryProvider(
          create: (context) => AuthRepository(),
          child: loggedIn ? const CardSwiperScreen() : const LoginView(),
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/repository/firebase_repository.dart';
import 'package:instagram_clone/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone/features/presentation/page/credentiatl/sign_in_page.dart';
import 'package:instagram_clone/features/presentation/page/main_screen/main_screen.dart';
import 'package:instagram_clone/on_generate_route.dart';
import 'features/presentation/cubit/credential/credential_cubit.dart';
import 'features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';
import 'injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBnhSj2FwtF2GDe78ndtSfQ2o6F0Z6xm4s',
          appId: '1:169117164643:android:b8dc84e8596ba30d80c456',
          messagingSenderId: "CXXXCCCXCX",
          projectId: 'instagram-flutter-570e9'));
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Instagram Clone",
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                return MainScreen(
                  uid: authState.uid,
                );
              } else {
                return SignInPage();
              }
            });
          }
        },
      ),
    );
  }
}

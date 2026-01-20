import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouptalk/core/core/Route/app_router.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';
import 'package:grouptalk/firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth bloc
        BlocProvider(create: (context) => di.sl<AuthBloc>()),

        // Room bloc
        BlocProvider(create: (context) => di.sl<RoomBloc>()),

        // Chat bloc
        BlocProvider(create: (context) => di.sl<ChatBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: "Grout talk",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF009688),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
      ),
    );
  }
}

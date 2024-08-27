import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_example/auth_gate.dart';
import 'package:freezed_example/core/theme/theme.dart';
import 'package:freezed_example/features/applied_jobs/presentation/bloc/applied_jobs_bloc.dart';
import 'package:freezed_example/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:freezed_example/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:freezed_example/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:freezed_example/features/post/presentation/bloc/post_bloc.dart';
import 'package:freezed_example/features/profile/presentation/bloc/user_bloc.dart';
import 'package:freezed_example/features/profile/presentation/bloc/work_experience_bloc.dart';
import 'package:freezed_example/firebase_options.dart';
import 'package:freezed_example/init_dependencies_main.dart';
import 'core/route/router.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<UserBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<WorkExperienceBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<FeedBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<PostBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AppliedJobsBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ChatBloc>(),
        ),
        // ChangeNotifierProvider(
        //     create: (_) => ChatProvider(
        //           serviceLocator(),
        //           serviceLocator(),
        //         )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tegether 3',
      theme: ThemeData.light(),
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const AuthGate(),
    );
  }
}
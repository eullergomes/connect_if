import 'package:connect_if/features/auth/data/firebase_auth_repo.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_states.dart';
import 'package:connect_if/features/auth/presentation/cubits/pages/auth_page.dart';
import 'package:connect_if/features/home/presentation/pages/home_page.dart';
import 'package:connect_if/features/profile/data/firebase_profile_repo.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/storage/data/firebase_storage_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
App - Root level

--------------------------------

Repositories: for database
- Firebase

Bloc Providers: for state management
- auth
- profile
- post
- search

Check Auth State
- unauthenticated: -> Auth Page (login/register)
- authenticated: -> Home Page
*/

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();

  // storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubit to app
    return MultiBlocProvider(
       providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        )
       ], 
       child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, authState) {
          // unauthenticated -> auth page (login/register)
          if (authState is Unauthenticated) {
            return const AuthPage();
          }

          // unauthenticated -> home page
          if (authState is Authenticated) {
            return const HomePage();
          }

          // loading...
          else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        ),
      ),
    );
  }
}
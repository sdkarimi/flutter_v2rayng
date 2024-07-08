import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2y/data/repo/app_repository.dart';
import 'package:flutter_v2y/data/repo/config_repository.dart';
import 'package:flutter_v2y/theme.dart';
import 'package:flutter_v2y/ui/home/Home.dart';
import 'package:flutter_v2y/ui/splash/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final bloc = SplashBloc(
              appRepository: appRepository,
              configRepository: configRepository
          );
          bloc.stream.forEach((state) {
            if (state is SplashSuccess) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()
                  )
              );
            } else if (state is SplashError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message))
              );
            }
          });
          bloc.add(SplashStarted());
          return bloc;
        },
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            return Container(
              color: DarkTheme.backgroundColor,
              child: const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to My App',
                      style: TextStyle(
                        color: DarkTheme.foregroundColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircularProgressIndicator(
                      color: DarkTheme.foregroundColor,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

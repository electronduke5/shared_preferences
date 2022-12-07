import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_pr/cubit/theme_cubit.dart';
import 'package:shared_preferences_pr/pages/input_page.dart';
import 'package:shared_preferences_pr/pages/text_page.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(prefs),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: context.read<ThemeCubit>().getCurrentTheme,
            theme: ThemeData(colorScheme: const ColorScheme.light()),
            darkTheme: ThemeData(colorScheme: const ColorScheme.dark()),
            home: FutureBuilder(
              future: isHaveText(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.data == true ? TextPage() : InputPage();
              },
            ),
            routes: {
              '/TextPage': (context) => TextPage(),
              '/InputPage': (context) => InputPage(),
            },
          );
        },
      ),
    );
  }

  Future<bool> isHaveText() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('text');
  }
}

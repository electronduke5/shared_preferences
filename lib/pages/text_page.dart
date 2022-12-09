import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_pr/cubit/theme_cubit.dart';

class TextPage extends StatelessWidget {
  TextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? text;
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 100),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FutureBuilder(
                  future: getText(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (args == null) {
                      text = snapshot.data;
                      if (text == null) {
                        return Text(
                          'Ошибка',
                          style: Theme.of(context).textTheme.headline4,
                        );
                      }
                      return Text(
                        'Текст из Shared Preferences: ${text!}',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    }
                    text = args as String;
                    return Text(
                      'Текст из аргументов: ${text!}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  clearPreferences();
                  Navigator.of(context).pushNamed('/InputPage');
                },
                child: const Text('Clear preferences'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              context.read<ThemeCubit>().switchTheme();
            },
            tooltip: 'Switch theme',
            child: Icon(state == ThemeMode.light
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
          );
        },
      ),
    );
  }

  Future<String> getText() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('text') ?? 'Неполучилос';
  }

  void clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('text');
    await prefs.remove('themeState');
  }
}

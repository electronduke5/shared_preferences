import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_pr/cubit/theme_cubit.dart';

class InputPage extends StatelessWidget {
  InputPage({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Введите текст...'),
              controller: _textController,
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    onClick();
                    Navigator.of(context).pushNamed('/TextPage',
                        arguments: _textController.text);
                  },
                  child: const Text('Сохранить'),
                );
              },
            ),
          ],
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

  void onClick() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('text', _textController.text);
  }
}

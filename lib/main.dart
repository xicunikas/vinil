import 'package:flutter/material.dart';
import 'core/theme/neo_theme.dart';
import 'features/player/now_playing.dart';

void main() => runApp(const VinilApp());

class VinilApp extends StatelessWidget {
  const VinilApp({super.key});
  @override Widget build(BuildContext context) {
    final theme = NeoTheme.presets.first; // trocar via provider de temas
    return MaterialApp(
      title: 'Vinil', debugShowCheckedModeBanner: false,
      theme: theme.toThemeData(), home: NowPlaying(theme: theme));
  }
}

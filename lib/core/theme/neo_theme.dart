import 'dart:convert';
import 'package:flutter/material.dart';

enum PlayerStyle { cd, ipod, hifi, minimal }

/// Tema 100% serializável: criar, duplicar, editar, exportar/importar (JSON).
class NeoTheme {
  final String name;
  final Color primary, secondary, background, surface;
  final double glassBlur, glassOpacity, radius, grain, effects; // effects 0 = minimalista
  final String fontFamily;
  final PlayerStyle playerStyle;
  final bool dark;

  const NeoTheme({
    required this.name, required this.primary, required this.secondary,
    required this.background, required this.surface,
    this.glassBlur = 18, this.glassOpacity = .12, this.radius = 24,
    this.grain = .15, this.effects = .8, this.fontFamily = 'serif',
    this.playerStyle = PlayerStyle.cd, this.dark = true,
  });

  NeoTheme copyWith({String? name, Color? primary, Color? secondary, Color? background,
      Color? surface, double? glassBlur, double? glassOpacity, double? radius,
      double? grain, double? effects, String? fontFamily, PlayerStyle? playerStyle, bool? dark}) =>
    NeoTheme(
      name: name ?? this.name, primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary, background: background ?? this.background,
      surface: surface ?? this.surface, glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity, radius: radius ?? this.radius,
      grain: grain ?? this.grain, effects: effects ?? this.effects,
      fontFamily: fontFamily ?? this.fontFamily, playerStyle: playerStyle ?? this.playerStyle,
      dark: dark ?? this.dark);

  NeoTheme duplicate() => copyWith(name: '$name (cópia)');

  Map<String, dynamic> toJson() => {
    'name': name, 'primary': primary.value, 'secondary': secondary.value,
    'background': background.value, 'surface': surface.value,
    'glassBlur': glassBlur, 'glassOpacity': glassOpacity, 'radius': radius,
    'grain': grain, 'effects': effects, 'fontFamily': fontFamily,
    'playerStyle': playerStyle.name, 'dark': dark,
  };
  String export() => jsonEncode(toJson());

  factory NeoTheme.fromJson(Map<String, dynamic> j) => NeoTheme(
    name: j['name'], primary: Color(j['primary']), secondary: Color(j['secondary']),
    background: Color(j['background']), surface: Color(j['surface']),
    glassBlur: (j['glassBlur'] as num).toDouble(), glassOpacity: (j['glassOpacity'] as num).toDouble(),
    radius: (j['radius'] as num).toDouble(), grain: (j['grain'] as num).toDouble(),
    effects: (j['effects'] as num).toDouble(), fontFamily: j['fontFamily'],
    playerStyle: PlayerStyle.values.byName(j['playerStyle']), dark: j['dark']);

  /// Cores dinâmicas da capa (extraídas com PaletteGenerator no serviço de capas).
  NeoTheme withAlbumColors(Color dominant, Color accent) =>
      copyWith(primary: accent, background: Color.lerp(background, dominant, .25));

  ThemeData toThemeData() => ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: background,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: primary,
        brightness: dark ? Brightness.dark : Brightness.light, secondary: secondary, surface: surface),
  );

  static const presets = <NeoTheme>[
    NeoTheme(name: 'Hi-Fi 1978', primary: Color(0xFFE0A458), secondary: Color(0xFF8C5E3C),
        background: Color(0xFF16110D), surface: Color(0xFF241B14), playerStyle: PlayerStyle.hifi, grain: .3),
    NeoTheme(name: 'Y2K Chrome', primary: Color(0xFF7DF9FF), secondary: Color(0xFFC77DFF),
        background: Color(0xFF0B0F1E), surface: Color(0xFF16213E), glassBlur: 26, playerStyle: PlayerStyle.ipod, fontFamily: 'sans-serif'),
    NeoTheme(name: 'Chiptune', primary: Color(0xFF39FF14), secondary: Color(0xFFFF2E63),
        background: Color(0xFF0A0A0A), surface: Color(0xFF151515), radius: 4, glassBlur: 0, fontFamily: 'monospace'),
    NeoTheme(name: 'Minimal Claro', primary: Color(0xFF1B1B1B), secondary: Color(0xFF8A8A8A),
        background: Color(0xFFF4F1EA), surface: Color(0xFFFFFFFF), effects: 0, grain: 0, dark: false, playerStyle: PlayerStyle.minimal),
  ];
}

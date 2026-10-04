import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/neo_theme.dart';

/// Player expandido: disco girando + painel de vidro + controles.
/// Respeita effects/glassBlur e reduz animações (acessibilidade).
class NowPlaying extends StatefulWidget {
  final NeoTheme theme;
  const NowPlaying({super.key, required this.theme});
  @override State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> with SingleTickerProviderStateMixin {
  late final _spin = AnimationController(vsync: this, duration: const Duration(seconds: 8));
  bool playing = true;
  double progress = .35;

  @override void dispose() { _spin.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final reduce = MediaQuery.of(context).disableAnimations || t.effects == 0;
    if (playing && !reduce) { _spin.repeat(); } else { _spin.stop(); }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color.lerp(t.background, t.primary, .18 * t.effects)!, t.background])),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            Semantics(label: 'Capa do álbum', child: RotationTransition(
              turns: _spin,
              child: Container(width: 260, height: 260,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: SweepGradient(colors: [t.primary, t.secondary, t.surface, t.primary]),
                  boxShadow: [BoxShadow(color: t.primary.withOpacity(.35 * t.effects), blurRadius: 40)]),
                child: Center(child: Container(width: 56, height: 56,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: t.background,
                    border: Border.all(color: t.surface, width: 6)))),
              ))),
            const Spacer(),
            _Glass(t: t, child: Column(children: [
              Text('Nome da Faixa', style: TextStyle(fontSize: 22, color: t.primary)),
              const SizedBox(height: 4),
              Text('Artista · Álbum · LOCAL', style: TextStyle(color: t.primary.withOpacity(.6))),
              Slider(value: progress, onChanged: (v) => setState(() => progress = v),
                  activeColor: t.primary, semanticFormatterCallback: (v) => '${(v * 100).round()}% da faixa'),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _Btn(Icons.shuffle, 'Aleatório', () {}),
                _Btn(Icons.skip_previous, 'Anterior', () {}),
                _Btn(playing ? Icons.pause_circle : Icons.play_circle, playing ? 'Pausar' : 'Tocar',
                    () => setState(() => playing = !playing), size: 64),
                _Btn(Icons.skip_next, 'Próxima', () {}),
                _Btn(Icons.repeat, 'Repetir', () {}),
              ]),
            ])),
          ]),
        )),
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  final NeoTheme t; final Widget child;
  const _Glass({required this.t, required this.child});
  @override Widget build(BuildContext c) => ClipRRect(
    borderRadius: BorderRadius.circular(t.radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: t.glassBlur, sigmaY: t.glassBlur),
      child: Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: t.surface.withOpacity(t.glassOpacity + .3),
          border: Border.all(color: t.primary.withOpacity(.15)),
          borderRadius: BorderRadius.circular(t.radius)),
        child: child)));
}

class _Btn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final double size;
  const _Btn(this.icon, this.label, this.onTap, {this.size = 32});
  @override Widget build(BuildContext c) => IconButton(
    tooltip: label, iconSize: size, onPressed: onTap, icon: Icon(icon),
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48));
}

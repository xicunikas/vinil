# Vinil — central de música pessoal (Flutter: Android, iOS, Windows)

## Camadas (uma pasta/pacote por responsabilidade)
- lib/core/theme      Sistema de temas (JSON, duplicar, exportar/importar, cores da capa)
- lib/core/sources    Contrato MusicSource: Local / Spotify / YouTube (com Capabilities)
- lib/features/player UI do player (mini, expandido, cinematográfico)
- A CRIAR: core/audio (just_audio + audio_service), core/db (drift), core/sync,
  core/cache, core/settings, platform/ (widgets, tray, atalhos globais)

## Regras de conformidade
- Local: reprodução própria, offline, edição de tags.
- Spotify: OAuth PKCE, Web API + App Remote. Sem reproduzir/baixar/armazenar áudio.
- YouTube: Data API v3 + player oficial incorporado. Sem extração de áudio.

## Rodar
flutter create . --platforms=android,ios,windows && flutter pub get && flutter run

## Roadmap
1 scanner+tags -> drift  2 player real + audio_service  3 busca global (FTS5)
4 playlists inteligentes (regras em JSON)  5 Spotify  6 YouTube  7 sync opcional
8 widgets (Android: Glance; iOS: WidgetKit) e Windows (tray, atalhos, mini-player)

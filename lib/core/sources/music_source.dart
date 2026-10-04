/// Contrato único para todas as origens. Cada fonte declara o que PODE fazer;
/// a UI se adapta às capacidades (e à licença) de cada serviço.
enum SourceKind { local, spotify, youtube }

class Capabilities {
  final bool offline, ownsPlayback, canSearch, canControlRemote, canEditMetadata;
  const Capabilities({this.offline = false, this.ownsPlayback = false, this.canSearch = true,
      this.canControlRemote = false, this.canEditMetadata = false});
}

class Track {
  final String id, title, artist, album;
  final Duration? duration;
  final String? artworkUri;
  final SourceKind source; // sempre exibido na UI como badge de origem
  const Track({required this.id, required this.title, required this.artist,
      required this.album, required this.source, this.duration, this.artworkUri});
}

abstract class MusicSource {
  SourceKind get kind;
  Capabilities get capabilities;
  Future<List<Track>> search(String query);
}

/// Arquivos do usuário: reprodução própria, offline, edição de tags.
abstract class LocalSource extends MusicSource {
  @override SourceKind get kind => SourceKind.local;
  @override Capabilities get capabilities => const Capabilities(
      offline: true, ownsPlayback: true, canEditMetadata: true);
  Future<void> scanFolder(String path);
}

/// Spotify: OAuth PKCE + Web API (biblioteca/busca/estado) e controle via
/// Spotify App Remote / Connect. NÃO reproduz nem armazena áudio.
abstract class SpotifySource extends MusicSource {
  @override SourceKind get kind => SourceKind.spotify;
  @override Capabilities get capabilities => const Capabilities(canControlRemote: true);
  Future<void> signIn();
}

/// YouTube: Data API v3 para busca/metadados; reprodução somente pelo
/// player oficial incorporado. Sem extração de áudio.
abstract class YouTubeSource extends MusicSource {
  @override SourceKind get kind => SourceKind.youtube;
  @override Capabilities get capabilities => const Capabilities();
}

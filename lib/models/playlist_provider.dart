import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier{
  final  List<Song> _playlist = [
  // song 1
  Song(
    songName: "Pluto Projector", 
    artistName: "Rex Orange County", 
    albumArtImagePath: "assets/images/pluto projector.jpeg", 
    audioPath: "audio/Rex+Orange+County+-+Pluto+Projector+(Official+Audio).mp3",
    ),
  // song 2
  Song(
    songName: "This is What Autum Feels Like", 
    artistName: "JVKE", 
    albumArtImagePath: "assets/images/jvke.jpeg", 
    audioPath: "audio/JVKE+-+this+is+what+autumn+feels+like.mp3",
    ),
  // song 3
  Song(
    songName: "UNDESTAND", 
    artistName: "Keshi", 
    albumArtImagePath: "assets/images/keshi.jpeg", 
    audioPath: "audio/keshi+-+UNDERSTAND+(Official+Music+Video).mp3",
    ),
  // song 4
  Song(
    songName: "Winter's Glow", 
    artistName: "Kardi", 
    albumArtImagePath: "assets/images/kardi.jpg", 
    audioPath: "audio/Winter's+Glow.mp3",
    ),
  // song 5
  Song(
    songName: "Love Me", 
    artistName: "Realstk", 
    albumArtImagePath: "assets/images/realstk.jpeg", 
    audioPath: "audio/RealestK+-+Love+Me+(Official+Audio).mp3",
    ),
  ];

  int? _currentSongIndex;

  /*

  A U D I O P L A Y E R

  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider () {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to durations
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /*

  G E T T E R S

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*

  s E T T E R S

  */

  set currentSongIndex(int? newIndex) {

    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }
    
    notifyListeners();
  }
}

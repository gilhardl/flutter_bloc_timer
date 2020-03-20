import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TimerEvent extends Equatable {
  TimerEvent();

  @override
  List<Object> get props => [];
}

class Start extends TimerEvent {
  Start({@required this.duration});

  final int duration;

  @override
  String toString() => "Start { duration: $duration }";
}

class Pause extends TimerEvent {
  Pause({@required this.duration});

  final int duration;

  @override
  String toString() => "Pause { duration: $duration }";
}

class Resume extends TimerEvent {}

class Reset extends TimerEvent {}

class Tick extends TimerEvent {
  Tick({@required this.duration});

  final int duration;

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "Tick { duration: $duration }";
}

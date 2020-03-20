import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  TimerState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  TimerInitial(int duration) : super(duration);

  @override
  toString() => 'TimerInitial { duration: $duration}';
}

class TimerPaused extends TimerState {
  TimerPaused(int duration) : super(duration);

  @override
  toString() => 'TimerPaused { duration: $duration}';
}

class TimerRunning extends TimerState {
  TimerRunning(int duration) : super(duration);

  @override
  toString() => 'TimerRunning { duration: $duration}';
}

class TimerFinished extends TimerState {
  TimerFinished() : super(0);

  @override
  toString() => 'TimerFinished { duration: $duration}';
}

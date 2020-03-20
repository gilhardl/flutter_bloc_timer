import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:bloc_timer/bloc/timer/timer_state.dart';
import 'package:bloc_timer/bloc/timer/timer_event.dart';
import 'package:bloc_timer/providers/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  final Ticker _ticker;
  final int _duration = 60;
  StreamSubscription<int> _tickerSubscription;

  @override
  TimerState get initialState => TimerInitial(_duration);

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is Start) {
      yield* _start(event);
    } else if (event is Pause) {
      yield* _pause(event);
    } else if (event is Resume) {
      yield* _resume(event);
    } else if (event is Reset) {
      yield* _reset(event);
    } else if (event is Tick) {
      yield* _tick(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _start(Start event) async* {
    yield TimerRunning(event.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(event.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }

  Stream<TimerState> _pause(Pause event) async* {
    if (state is TimerRunning) {
      _tickerSubscription?.pause();
      yield TimerPaused(event.duration);
    }
  }

  Stream<TimerState> _resume(Resume event) async* {
    if (state is TimerPaused) {
      _tickerSubscription?.resume();
      yield TimerRunning(_duration);
    }
  }

  Stream<TimerState> _reset(Reset event) async* {
    _tickerSubscription?.cancel();
    yield TimerInitial(_duration);
  }

  Stream<TimerState> _tick(Tick event) async* {
    yield event.duration > 0 ? TimerRunning(event.duration) : TimerFinished();
  }
}

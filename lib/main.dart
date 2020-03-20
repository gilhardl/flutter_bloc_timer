import 'package:bloc_timer/bloc/timer/timer_event.dart';
import 'package:bloc_timer/bloc/timer/timer_state.dart';
import 'package:bloc_timer/providers/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/timer/timer_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'BLoC Timer'),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider<TimerBloc>(
        create: (_) => TimerBloc(ticker: Ticker()),
        child: BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
          final String minutesStr =
              ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
          final String secondsStr =
              (state.duration % 60).floor().toString().padLeft(2, '0');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Center(
                  child: Text(
                    '$minutesStr:$secondsStr',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _buildActionButtons(BlocProvider.of<TimerBloc>(context)),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildActionButtons(TimerBloc timerBloc) {
    if (timerBloc.state is TimerInitial) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(Start(duration: 60)),
          child: Icon(Icons.play_arrow),
        ),
      ];
    }
    if (timerBloc.state is TimerRunning) {
      return [
        FloatingActionButton(
          onPressed: () =>
              timerBloc.add(Pause(duration: timerBloc.state.duration)),
          child: Icon(Icons.pause),
        ),
        FloatingActionButton(
          onPressed: () => timerBloc.add(Reset()),
          child: Icon(Icons.replay),
        ),
      ];
    }
    if (timerBloc.state is TimerPaused) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(Resume()),
          child: Icon(Icons.play_arrow),
        ),
        FloatingActionButton(
          onPressed: () => timerBloc.add(Reset()),
          child: Icon(Icons.replay),
        ),
      ];
    }
    if (timerBloc.state is TimerFinished) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(Reset()),
          child: Icon(Icons.replay),
        ),
      ];
    }
    return [];
  }
}

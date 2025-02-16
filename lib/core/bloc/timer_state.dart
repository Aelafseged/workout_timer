// lib/core/bloc/timer_state.dart
import 'package:equatable/equatable.dart';

/// Base state for timer
abstract class TimerState extends Equatable {
  final int exerciseTime;
  final int restTime;
  final int currentTime;
  final bool isExercise;

  const TimerState({
    required this.exerciseTime,
    required this.restTime,
    required this.currentTime,
    required this.isExercise,
  });

  @override
  List<Object> get props => [exerciseTime, restTime, currentTime, isExercise];
}

/// Initial ready state
class TimerReady extends TimerState {
  const TimerReady({
    required super.exerciseTime,
    required super.restTime,
    required super.currentTime,
    required super.isExercise,
  });
}

/// Timer is actively running
class TimerRunning extends TimerState {
  const TimerRunning({
    required super.exerciseTime,
    required super.restTime,
    required super.currentTime,
    required super.isExercise,
  });
}

/// Timer is paused
class TimerPaused extends TimerState {
  const TimerPaused({
    required super.exerciseTime,
    required super.restTime,
    required super.currentTime,
    required super.isExercise,
  });
}

/// Timer is FINISHED
class TimerFinished extends TimerState {
  const TimerFinished({
    required super.exerciseTime,
    required super.restTime,
    required super.currentTime,
    required super.isExercise,
  });
}
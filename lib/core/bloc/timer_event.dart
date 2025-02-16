import 'package:equatable/equatable.dart';

/// Events that trigger timer state changes
abstract class TimerEvent extends Equatable {
  const TimerEvent();

   @override
  List<Object> get props => [];
}

class TimerStart extends TimerEvent {
  final int exerciseTime;
  final int restTime;

 const TimerStart(this.exerciseTime, this.restTime);

  @override
  List<Object> get props => [exerciseTime, restTime];
}

/// Event: User pauses the timer
class TimerPause extends TimerEvent {
  const TimerPause();
}

/// Event: User stops and resets the timer
class TimerReset extends TimerEvent {
  const TimerReset();
}

/// Event: Internal event for switching between exercise/rest phases
class TimerSwitchPhase extends TimerEvent {
  const TimerSwitchPhase();
}

/// Event: User updates the exercise duration
class UpdateExerciseTime extends TimerEvent {
  final int newTime;

  const UpdateExerciseTime(this.newTime);

  @override
  List<Object> get props => [newTime];
}

/// Event: User updates the rest duration
class UpdateRestTime extends TimerEvent {
  final int newTime;

  const UpdateRestTime(this.newTime);

  @override
  List<Object> get props => [newTime];
}
// lib/core/bloc/timer_bloc.dart
import 'package:bloc/bloc.dart';
import 'dart:async';
import '../services/audio_service.dart';
import 'timer_event.dart';
import 'timer_state.dart';

/// Business Logic Component for timer management
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final AudioService audioService;
  Timer? _countdownTimer;

  TimerBloc({required this.audioService}) : super(const TimerReady(
    exerciseTime: 50,
    restTime: 10,
    currentTime: 50,
    isExercise: true,
  )) {
    on<TimerStart>(_onTimerStart);
    on<TimerPause>(_onTimerPause);
    on<TimerReset>(_onTimerReset);
    on<TimerSwitchPhase>(_onTimerSwitchPhase);
    on<UpdateExerciseTime>(_onUpdateExerciseTime);
  }
  //handle update exercise time
  void _onUpdateExerciseTime(UpdateExerciseTime event, Emitter<TimerState> emit) {
    
    emit(TimerReady(
      exerciseTime: event.newTime,
      restTime: state.restTime,
      currentTime: event.newTime,
      isExercise: true,
    ));
  }

  /// Handle timer start/resume events
  void _onTimerStart(TimerStart event, Emitter<TimerState> emit) {
    // Cancel any existing timer
    _countdownTimer?.cancel();
    
    // Initialize or restart the timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerSwitchPhase());
    });

    emit(TimerRunning(
      exerciseTime: event.exerciseTime,
      restTime: event.restTime,
      currentTime: state.currentTime,
      isExercise: state.isExercise,
    ));
  }

  /// Handle timer pause events
  void _onTimerPause(TimerPause event, Emitter<TimerState> emit) {
    _countdownTimer?.cancel();
    emit(TimerPaused(
      exerciseTime: state.exerciseTime,
      restTime: state.restTime,
      currentTime: state.currentTime,
      isExercise: state.isExercise,
    ));
  }

  /// Handle timer reset events
  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _countdownTimer?.cancel();
    emit(const TimerReady(
      exerciseTime: 50,
      restTime: 10,
      currentTime: 50,
      isExercise: true,
    ));
  }

  /// Handle phase switching and countdown logic
  void _onTimerSwitchPhase(TimerSwitchPhase event, Emitter<TimerState> emit) {
    int newTime = state.currentTime - 1;
    bool newIsExercise = state.isExercise;

    // When time reaches 0, switch phase
    if (newTime < 0) {
      audioService.playSound('beep.mp3');
      newIsExercise = !state.isExercise;
      newTime = newIsExercise ? state.exerciseTime : state.restTime;
    }

    emit(state is TimerRunning
        ? TimerRunning(
            exerciseTime: state.exerciseTime,
            restTime: state.restTime,
            currentTime: newTime,
            isExercise: newIsExercise,
          )
        : TimerPaused(
            exerciseTime: state.exerciseTime,
            restTime: state.restTime,
            currentTime: newTime,
            isExercise: newIsExercise,
          ));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
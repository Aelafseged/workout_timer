// lib/features/floating_gadget/floating_gadget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_timer/core/bloc/timer_bloc.dart';
import 'package:workout_timer/core/bloc/timer_event.dart';
import '../../core/bloc/timer_state.dart';

/// Floating overlay widget with compact timer display
class FloatingGadget extends StatelessWidget {
  final double animationValue;

  const FloatingGadget({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            child: BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.isExercise ? 'EX' : 'RT',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${state.currentTime}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    _buildMiniControls(context, state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniControls(BuildContext context, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(state is TimerRunning ? Icons.pause : Icons.play_arrow),
          iconSize: 20,
          onPressed: () => state is TimerRunning
              ? context.read<TimerBloc>().add(const TimerPause())
              : context.read<TimerBloc>().add(TimerStart(
                  state.exerciseTime,
                  state.restTime,
                )),
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          iconSize: 20,
          onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
        ),
      ],
    );
  }
}
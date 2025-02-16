// lib/features/timer_screen/timer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:workout_timer/core/bloc/timer_bloc.dart';
import '../../core/bloc/timer_state.dart';
import '../../core/bloc/timer_event.dart';
import 'floating_gadget.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_to_front),
            onPressed: () => _showFloatingGadget(context),
            tooltip: 'Show Floating Gadget',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state is TimerFinished) {
              _showCompletionSnackbar(context);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhaseIndicator(state),
                const SizedBox(height: 30),
                _buildTimeDisplay(state),
                const SizedBox(height: 30),
                _buildControlButtons(context, state),
                const SizedBox(height: 30),
                _buildConfigurationPanel(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------------
  // UI Component Builders
  // ----------------------

  /// Builds the current phase indicator (Exercise/Rest)
  Widget _buildPhaseIndicator(TimerState state) {
    return Text(
      state.isExercise ? 'EXERCISE' : 'REST',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  /// Builds the large time display
  Widget _buildTimeDisplay(TimerState state) {
    return Text(
      '${state.currentTime}',
      style: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  /// Builds the control buttons row
  Widget _buildControlButtons(BuildContext context, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStartButton(context, state),
        const SizedBox(width: 10),
        _buildPauseButton(context, state),
        const SizedBox(width: 10),
        _buildResetButton(context, state),
      ],
    );
  }

  /// Builds the configuration panel with time dropdowns
  Widget _buildConfigurationPanel(BuildContext context, TimerState state) {
    return Column(
      children: [
        const Text(
          'Configure Timer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildExerciseDropdown(context, state),
            const SizedBox(width: 20),
            _buildRestDropdown(context, state),
          ],
        ),
      ],
    );
  }

  // ----------------------
  // Control Button Helpers
  // ----------------------

  Widget _buildStartButton(BuildContext context, TimerState state) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: const Text('Start'),
      onPressed: state is! TimerRunning
          ? () => context.read<TimerBloc>().add(
                TimerStart(state.exerciseTime, state.restTime),
              )
          : null,
    );
  }

  Widget _buildPauseButton(BuildContext context, TimerState state) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.pause),
      label: const Text('Pause'),
      onPressed: state is TimerRunning
          ? () => context.read<TimerBloc>().add(const TimerPause())
          : null,
    );
  }

  Widget _buildResetButton(BuildContext context, TimerState state) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.stop),
      label: const Text('Reset'),
      onPressed: state is! TimerReady
          ? () => context.read<TimerBloc>().add(const TimerReset())
          : null,
    );
  }

  // ----------------------
  // Dropdown Helpers
  // ----------------------

  Widget _buildExerciseDropdown(BuildContext context, TimerState state) {
    return Column(
      children: [
        const Text('Exercise (sec):'),
        DropdownButton<int>(
          value: state.exerciseTime,
          items: [20, 30, 40, 45, 50, 60].map((value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          onChanged: state is TimerRunning
              ? null
              : (value) => context.read<TimerBloc>().add(
                    UpdateExerciseTime(value!),
                  ),
        ),
      ],
    );
  }

  Widget _buildRestDropdown(BuildContext context, TimerState state) {
    return Column(
      children: [
        const Text('Rest (sec):'),
        DropdownButton<int>(
          value: state.restTime,
          items: [5, 10, 15, 20, 25, 30].map((value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          onChanged: state is TimerRunning
              ? null
              : (value) => context.read<TimerBloc>().add(
                    UpdateRestTime(value!),
                  ),
        ),
      ],
    );
  }

  // ----------------------
  // Helper Methods
  // ----------------------

  void _showFloatingGadget(BuildContext context) {
    showOverlay(
      (context, t) => FloatingGadget(animationValue: t),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showCompletionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout Completed!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
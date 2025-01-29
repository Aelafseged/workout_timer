import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(WorkoutTimerApp());
}

class WorkoutTimerApp extends StatelessWidget {
  const WorkoutTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutTimerScreen(),
    );
  }
}

class WorkoutTimerScreen extends StatefulWidget {
  @override
  _WorkoutTimerScreenState createState() => _WorkoutTimerScreenState();
}


class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  int exerciseTime = 50; // Default exercise time in seconds
  int restTime = 10; // Default rest time in seconds
  int currentTime = 0;
  bool isExercise = true;
  bool isRunning = false;
  bool isPaused = false;
  AudioPlayer audioPlayer = AudioPlayer();

  void startTimer() {
    setState(() {
      isRunning = true;
      isPaused = false;
      currentTime = isExercise ? exerciseTime : restTime;
    });
    _runTimer();
  }

  void _runTimer() async {
    while (isRunning && currentTime > 0) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        currentTime--;
      });
    }
    if (currentTime == 0) {
      _switchMode();
    }
  }

  void _switchMode() {
    audioPlayer.play(AssetSource('retro-blip-2-236668.mp3')); // Play a sound
    setState(() {
      isExercise = !isExercise;
      currentTime = isExercise ? exerciseTime : restTime;
    });
    if (isRunning) {
      _runTimer();
    }
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
      isPaused = false;
      currentTime = isExercise ? exerciseTime : restTime;
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      isPaused = false;
      isExercise = true;
      currentTime = exerciseTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExercise ? 'Exercise Time' : 'Rest Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$currentTime',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : () => startTimer(),
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isRunning && !isPaused ? () => pauseTimer() : null,
                  child: Text('Pause'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isRunning || isPaused ? () => stopTimer() : null,
                  child: Text('Stop'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => resetTimer(),
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Configure Timer'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Exercise (secs):'),
                    SizedBox(height: 10),
                    DropdownButton<int>(
                      value: exerciseTime,
                      items: [15,30, 40, 50, 60].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: isRunning
                          ? null
                          : (value) {
                              setState(() {
                                exerciseTime = value!;
                              });
                            },
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text('Rest (secs):'),
                    SizedBox(height: 10),
                    DropdownButton<int>(
                      value: restTime,
                      items: [5, 10, 15, 20].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                      onChanged: isRunning
                          ? null
                          : (value) {
                              setState(() {
                                restTime = value!;
                              });
                            },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
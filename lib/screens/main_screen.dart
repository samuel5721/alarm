import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Duration timerDuration = const Duration(hours: 23, minutes: 20, seconds: 0);

  int setHour = 23;
  int setMinute = 20;

  int currentHour = DateTime.now().hour;
  int currentMinute = DateTime.now().minute;
  int currentSecond = DateTime.now().second;

  bool isAlarmOn = false;

  Timer? backgroundTimer;

  @override
  void initState() {
    super.initState();

    // 1초마다 코드를 실행
    backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentHour = DateTime.now().hour;
        currentMinute = DateTime.now().minute;
        currentSecond = DateTime.now().second;
      });
      checkAlarmTime();
    });
  }

  void checkAlarmTime() {
    if (setHour == currentHour &&
        setMinute == currentMinute &&
        currentSecond == 0) {
      if (!isAlarmOn) {
        alarmOn();
      }
    }
  }

  void setAlarm() {
    setState(() {
      setHour = timerDuration.inHours;
      setMinute = timerDuration.inMinutes.remainder(60);
    });
  }

  void alarmOn() {
    setState(() {
      isAlarmOn = true;
    });
  }

  void alarmOff() {
    setState(() {
      isAlarmOn = false;
    });
  }

  @override
  void dispose() {
    backgroundTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupertino Timer Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wake at: $setHour:$setMinute',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'time: $currentHour:$currentMinute',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: timerDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  setState(() {
                    timerDuration = newDuration;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: setAlarm,
              child: const Text('확인'),
            ),
            if (isAlarmOn)
              ElevatedButton(
                onPressed: alarmOff,
                child: const Text('알람 끄기'),
              ),
          ],
        ),
      ),
    );
  }
}

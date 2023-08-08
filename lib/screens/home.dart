import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hb/constants/colors.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  bool isBPMEnabled = false;

  /// list to store raw values in
  List<SensorValue> data = [];
  late Timer firstTimer;
  double percent = 0.0;
  double prevPercent = 0.0;

  /// variable to store measured BPM value
  int bpmValue = 0;
  measure() {
    setState(() {
      bpmValue = 0;
      percent = 0;
      percent = prevPercent + 0.5;
      prevPercent = percent;
      isBPMEnabled = !isBPMEnabled;
      data.clear();
    });
    firstTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        percent += 0.5;
        isBPMEnabled = !isBPMEnabled;
      });
      firstTimer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height * .03),
                if (isBPMEnabled)
                  Column(
                    children: [
                      HeartBPMDialog(
                        context: context,
                        // sampleDelay: 1000 ~/ 20,
                        child: const Text(''),

                        onRawData: (value) {
                          setState(() {
                            // add raw data points to the list
                            // with a maximum length of 100
                            if (data.length == 100) data.removeAt(0);
                            data.add(value);
                          });
                        },
                        onBPM: (value) {
                          Future.delayed(
                            const Duration(milliseconds: 1000 ~/ 40),
                            () => setState(() {
                              bpmValue = value;
                            }),
                          );
                        },
                      ),
                      Text(
                        'Please place finger on the rear camera',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: width * .01 + 14,
                          color: AppColors.color.withOpacity(.5),
                        ),
                      )
                    ],
                  ).animate().fadeIn()
                else
                  const SizedBox(),
                CircularPercentIndicator(
                  radius: 100.0,
                  animation: true,
                  animationDuration: 500,
                  lineWidth: 5.0,
                  percent: percent,
                  center: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.heart_fill,
                        color: AppColors.accent,
                      ),
                      Text(
                        bpmValue.toString(),
                        style: TextStyle(
                          fontSize: width * .09 + 42,
                          color: AppColors.color,
                        ),
                      ),
                      Text(
                        'BPM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * .01 + 16,
                          color: AppColors.color.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  progressColor: AppColors.primaryColor,
                  backgroundColor: Colors.grey,
                ),
                !isBPMEnabled
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            AppColors.primaryColor.withOpacity(.7),
                          ),
                        ),
                        onPressed: measure,
                        child: Text(
                          !isBPMEnabled ? "Measure" : "Stop",
                          style: TextStyle(
                            fontSize: width * .01 + 25,
                            color: AppColors.color,
                          ),
                        ),
                      ).animate().fadeIn()
                    : const Text(''),
                data.isNotEmpty
                    ? SizedBox(
                        height: height * .25,
                        width: width,
                        child: BPMChart(data),
                      )
                    : const Text(''),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Text(
                //           'MIN',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: width * .01 + 16,
                //             color: AppColors.color,
                //           ),
                //         ),
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           children: <Widget>[
                //             Text(
                //               '42',
                //               style: TextStyle(
                //                 fontSize: width * .02 + 32,
                //                 color: AppColors.color,
                //               ),
                //             ),
                //             SizedBox(width: width * .02),
                //             Padding(
                //               padding: const EdgeInsets.only(bottom: 10.0),
                //               child: Text(
                //                 'BPM',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: width * .01 + 16,
                //                   color: AppColors.color,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Text(
                //           'MAX',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: width * .01 + 16,
                //             color: AppColors.color,
                //           ),
                //         ),
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           children: <Widget>[
                //             Text(
                //               '132',
                //               style: TextStyle(
                //                 fontSize: width * .02 + 32,
                //                 color: AppColors.color,
                //               ),
                //             ),
                //             SizedBox(width: width * .02),
                //             Padding(
                //               padding: const EdgeInsets.only(bottom: 10.0),
                //               child: Text(
                //                 'BPM',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: width * .01 + 16,
                //                   color: AppColors.color,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.mainBg,
        currentIndex: currentIndex,
        elevation: 0,
        selectedIconTheme:
            const IconThemeData(color: AppColors.primaryColor, size: 25),
        unselectedIconTheme:
            const IconThemeData(color: AppColors.color, size: 25),
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.color,
        selectedFontSize: width * .01 + 12,
        unselectedFontSize: width * .01 + 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.heart_fill,
            ),
            label: 'Measure',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.chart_bar_fill,
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.time,
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

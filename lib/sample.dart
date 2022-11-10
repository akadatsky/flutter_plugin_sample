import 'package:flutter/material.dart';
import 'package:plugin_sample/custom_widgets/nice_loading_button.dart';
import 'package:plugin_sample/utils.dart';
import 'package:raminfo/raminfo.dart';
import 'package:slider_button/slider_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            child: NiceLoadingButton(
              'Press me',
              loading: isWaiting,
              icon: isWaiting
                  ? null
                  : const Icon(
                      Icons.play_circle,
                      color: Colors.white,
                    ),
              onPressed: () async {
                setState(() {
                  isWaiting = true;
                });
                Future.delayed(
                  const Duration(seconds: 3),
                  () async {
                    setState(() {
                      isWaiting = false;
                    });
                    await showSampleDialog(
                      context: context,
                      modalPage: const RamInfoDemo(),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: middlePadding),
          SliderButton(
            action: () async {
              await showSampleDialog(
                context: context,
                modalPage: const RamInfoDemo(),
              );
            },
            label: const Text(
              "Slide me",
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            icon: const Text(
              "X",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 44,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class RamInfoDemo extends StatelessWidget {
  const RamInfoDemo({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: FutureBuilder(
          future: RamInfo.getRamUsageMb(),
          builder: (context, snapshot) {
            return Text('RamUsage: ${snapshot.data}');
          },
        ),
      );
}

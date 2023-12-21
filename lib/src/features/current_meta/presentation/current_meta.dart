import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class CurrentMetaScreen extends ConsumerStatefulWidget {
  const CurrentMetaScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentMetaScreenState();
}

class _CurrentMetaScreenState extends ConsumerState<CurrentMetaScreen> {
  AppMetadata? meta;
  @override
  Widget build(BuildContext context) {
    var metaService = ref.watch(currentMetaServiceProvider);
    // bool background = ref.watch(backgroundProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Meta"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Actions"),
                ElevatedButton(
                    child: const Text("Get Current Meta"),
                    onPressed: () => {
                          metaService.currentMeta().then((value) => {
                                setState(() {
                                  meta = value;
                                })
                              })
                        }),
                ElevatedButton(
                    child: const Text("Record Position"),
                    onPressed: () => {metaService.recordPosition()}),
                ElevatedButton(
                    child: const Text("Start Background"),
                    onPressed: () async => {
                          if (await FlutterBackgroundService().isRunning() ==
                              false)
                            {FlutterBackgroundService().startService()}
                        }),
                ElevatedButton(
                    child: const Text("Stop Background"),
                    onPressed: () async => {
                          if (await FlutterBackgroundService().isRunning() ==
                              true)
                            {FlutterBackgroundService().invoke("stopService")}
                        }),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Current Meta"),
            Text("ID: ${meta?.deviceInfo.id}"),
            Text(
                "Location: ${meta?.location.latitude}, ${meta?.location.longitude} "),
            Text("Battery: ${meta?.battery}"),
            Text("Brand: ${meta?.deviceInfo.brand}"),
            Text("Model: ${meta?.deviceInfo.model}"),
            Text("OS: ${meta?.deviceInfo.os}"),
            Text("App Version: ${meta?.deviceInfo.appVersion}"),
            Text("Carrier: ${meta?.deviceInfo.carrier}"),
          ],
        ),
      ),
    );
  }
}
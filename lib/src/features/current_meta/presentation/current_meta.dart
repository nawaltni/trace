import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/src/common_widgets/common_drawer.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:trace/src/features/current_meta/service/current_meta_service.dart';
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
    var metaRepository = ref.watch(currentMetaRepositoryProvider);
    var metaService = ref.watch(currentMetaServiceProvider);
    // bool background = ref.watch(backgroundProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Meta"),
      ),
      drawer: const CommonDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Actions"),
                FilledButton(
                    child: const Text("Revisar meta data"),
                    onPressed: () => {
                          metaRepository.currentMeta().then((value) => {
                                setState(() {
                                  meta = value;
                                })
                              })
                        }),
                FilledButton(
                    child: const Text("Registrar Position Actual"),
                    onPressed: () {
                      metaService.recordPosition();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Position registrada')),
                      );
                    }),
                FilledButton(
                    child: const Text("Check-in"),
                    onPressed: () async {
                      if (await FlutterBackgroundService().isRunning() ==
                          false) {
                        FlutterBackgroundService().startService();
                      }
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checkin registrado')),
                      );
                    }),
                FilledButton(
                    child: const Text("Check-out"),
                    onPressed: () async {
                      if (await FlutterBackgroundService().isRunning() ==
                          true) {
                        FlutterBackgroundService().invoke("stopService");
                      }

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checkout registrado')),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Current Meta"),
            Text("ID: ${meta?.phoneMeta.id}"),
            Text(
                "Location: ${meta?.location.latitude}, ${meta?.location.longitude} "),
            Text("Battery: ${meta?.battery}"),
            Text("Brand: ${meta?.phoneMeta.brand}"),
            Text("Model: ${meta?.phoneMeta.model}"),
            Text("OS: ${meta?.phoneMeta.os}"),
            Text("App Version: ${meta?.phoneMeta.appVersion}"),
            Text("Carrier: ${meta?.phoneMeta.carrier}"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/src/features/current_location/data/current_location_repository.dart';

class CurrentPositionScreen extends ConsumerStatefulWidget {
  const CurrentPositionScreen({Key? key}) : super(key: key);

  @override
  _PositionState createState() => _PositionState();
}

class _PositionState extends ConsumerState<CurrentPositionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: GeoLocationService.positionStream,
              // initialData: ,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }
                return Text(
                    'Location: ${snapshot.data?.latitude}, ${snapshot.data?.longitude}');
              },
            )
          ],
        ),
      ),
    );
  }
}

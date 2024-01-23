import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trace/domain/place.dart';

part 'places.g.dart';

class NawaltPlacesAPI {
  late final ClientChannel _channel;
  late final PlacesServiceClient _stub;

  NawaltPlacesAPI() {
    var host = dotenv.env['GRPC_HOST'];
    var port = dotenv.env['GRPC_PORT'];
    print('NawaltPlacesAPI: host: $host, port: $port');
    _channel = ClientChannel(
      host!,
      port: int.parse(port!),
      options: const ChannelOptions(
        credentials: ChannelCredentials.secure(),
        // credentials: ChannelCredentials.insecure(),
      ),
    );

    _stub = PlacesServiceClient(_channel);
  }

  Future<void> exportSurveys(PlaceDraft draft) async {
    print('NawaltPlacesAPI.exportSurveys called');
    // Split draft.location by comma and remove spaces
    final locationParts =
        draft.location.split(',').map((part) => part.trim()).toList();

    if (locationParts.length != 2) {
      throw Exception('Invalid location format');
    }

    final loc = GeoPoint(
      latitude: double.parse(locationParts[0]),
      longitude: double.parse(locationParts[1]),
    );

    print("created_at is ${draft.timestamp} ");

    final createPlaceDraftRequest = CreatePlaceDraftRequest(
        name: draft.name,
        location: loc,
        description: draft.description,
        contact: draft.contact,
        contactRole: draft.contactRole,
        city: draft.city,
        region: draft.region,
        country: draft.country,
        address: draft.address,
        postalCode: draft.postalCode,
        category: draft.category,
        userId: draft.userId,
        createdAt: Timestamp.fromDateTime(draft.timestamp));

    // Use locationParts in your code as needed

    final createPlaceResponse =
        await _stub.createPlaceDraft(createPlaceDraftRequest);
    print('NawaltPlacesAPI.exportSurveys response: $createPlaceResponse');
  }
}

@Riverpod(keepAlive: true)
NawaltPlacesAPI nawaltPlacesAPI(NawaltPlacesAPIRef ref) {
  return NawaltPlacesAPI();
}

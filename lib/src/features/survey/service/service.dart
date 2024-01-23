import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trace/domain/place.dart';
import 'package:trace/src/features/authentication/data/auth_repository.dart';
import 'package:trace/src/features/survey/data/db.dart';
import 'package:trace/src/features/survey/data/models.dart';
import 'package:trace/src/grpc/auth.dart';
import 'package:trace/src/grpc/places.dart';

part 'service.g.dart';

class SurveyService {
  final dbHelper = DatabaseHelper.instance;
  final NawaltPlacesAPI _nawaltPlacesAPI = NawaltPlacesAPI();
  final AuthRepository _authRepository;

  SurveyService(this._authRepository);

  Future<int> exportSurveys() async {
    final authData = await _authRepository.getAuthData();

    List<SurveyRecord> surveys = [];
    var syncedRecords = 0;
    try {
      surveys = await dbHelper.getNonExportedRecords();
    } catch (e) {
      print('export surveys failed with error: $e');
      return syncedRecords;
    }

    print("user id: ${authData.userId}");
    for (final s in surveys) {
      print("survey timestamp: ${s.createdAt}");
      try {
        final draft = PlaceDraft(
          userId: authData.userId,
          name: s.placeName,
          location: s.location,
          description: s.comment,
          contact: s.contact,
          contactRole: "unknown",
          city: s.city,
          region: "unknown",
          country: "Nicaragua",
          address: "unknown",
          postalCode: "unknown",
          category: s.placeCategory,
          timestamp: s.createdAt,
        );

        await _nawaltPlacesAPI.exportSurveys(draft);
      } catch (e) {
        print('survey ${s.id} failed to be exported  with error: $e, skipping');
        continue;
      }

      print('survey ${s.id} exported successfully');

      try {
        await dbHelper.markSurveyAsExported(s.id);
      } catch (e) {
        print('survey ${s.id} failed to be marked as exported with error: $e');
        continue;
      }

      syncedRecords++;
      print('survey ${s.id} marked as exported successfully');
    }
    return syncedRecords;
  }
}

@Riverpod(keepAlive: true)
SurveyService surveyService(SurveyServiceRef ref) {
  return SurveyService(ref.watch(authRepositoryProvider));
}

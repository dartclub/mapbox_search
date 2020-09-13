import 'package:mapbox_search/mapbox_search.dart';
import 'package:test/test.dart';
import 'package:turf/turf.dart';

import 'credentials.dart';

void main() async {
  test("Has api key", () {
    expect(MAPBOX_KEY, isNotNull);
  });

  test("Places search test", () async {
    var search = PlacesSearch(
      apiKey: MAPBOX_KEY,
      country: "BR",
      limit: 5,
    );

    var searchPlace = search.getPlaces(
      "patio",
      position: Position.named(
        lat: -19.984634,
        lng: -43.9502958,
      ),
    );

    expect(searchPlace, completion(isA<FeatureCollection>()));
    expect(searchPlace, completion(isNotEmpty));
    expect(searchPlace, completion(hasLength(5)));
  });
}

import 'dart:io';

import 'package:mapbox_search/mapbox_search.dart';
import 'package:test/test.dart';
import 'package:turf/turf.dart';

import 'credentials.dart';

main() {
  group('static image', () {
    var staticImage;

    setUp(() {
      staticImage = StaticImage(apiKey: MAPBOX_KEY);
    });

    test('polyline', () async {
      var polyline = staticImage.getStaticUrlWithPolyline(
        point1: Position.named(lat: 37.77343, lng: -122.46589),
        point2: Position.named(lat: 37.75965, lng: -122.42816),
        marker1: MapBoxMarker(
            markerColor: Color.rgb(0, 0, 0),
            markerLetter: 'p',
            markerSize: MarkerSize.LARGE),
        marker2: MapBoxMarker(
            markerColor: Color.rgb(244, 67, 54),
            markerLetter: 'q',
            markerSize: MarkerSize.SMALL),
        height: 300,
        width: 600,
        zoomLevel: 16,
        style: MapBoxStyle.Dark,
        render2x: true,
        center:
            Position.named(lat: 37.766541503617475, lng: -122.44702324243272),
        auto: true,
      );

      expect(polyline,
          "https://api.mapbox.com/styles/v1/mapbox/dark-v10/static/pin-l-p+000(-122.46589,37.77343),pin-s-q+f44336(-122.42816,37.75965),path-5+f44336-0.5(%7DrpeFxbnjVsFwdAvr@cHgFor@jEmAlFmEMwM_FuItCkOi@wc@bg@wBSgM)/auto/600x300@2x?access_token=$MAPBOX_KEY");
      var uri = Uri.tryParse(polyline);
      expect(uri, isNotNull);

      var req = await HttpClient().getUrl(uri);
      var resp = await req.close();
      expect(resp.statusCode, 200);
    });
    test('with Marker', () async {
      var withMarker = staticImage.getStaticUrlWithMarker(
        center: Position.named(lat: 37.77343, lng: -122.46589),
        marker: MapBoxMarker(
            markerColor: Color.rgb(0, 0, 0),
            markerLetter: 'p',
            markerSize: MarkerSize.LARGE),
        height: 300,
        width: 600,
        zoomLevel: 16,
        style: MapBoxStyle.Streets,
        render2x: true,
      );

      expect(withMarker,
          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l-p+000(-122.46589,37.77343)/-122.46589,37.77343,16,0,20/600x300@2x?access_token=$MAPBOX_KEY");

      var uri = Uri.tryParse(withMarker);
      expect(uri, isNotNull);

      var req = await HttpClient().getUrl(uri);
      var resp = await req.close();
      expect(resp.statusCode, 200);
    });
    test('without Marker', () async {
      var withoutMarker = staticImage.getStaticUrlWithoutMarker(
        center: Position.named(lat: 37.75965, lng: -122.42816),
        height: 300,
        width: 600,
        zoomLevel: 16,
        style: MapBoxStyle.Outdoors,
        render2x: true,
      );

      expect(withoutMarker,
          "https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/static/-122.42816,37.75965,16,0,20/600x300@2x?access_token=$MAPBOX_KEY");

      var uri = Uri.tryParse(withoutMarker);
      expect(uri, isNotNull);

      var req = await HttpClient().getUrl(uri);
      var resp = await req.close();
      expect(resp.statusCode, 200);
    });
  });
}

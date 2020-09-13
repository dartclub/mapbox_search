part of mapbox_search;

class PlacesSearch {
  /// API Key of the MapBox.
  final String apiKey;

  /// Specify the user’s language. This parameter controls the language of the text supplied in responses.
  ///
  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API
  final String language;

  ///Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes separated by commas.
  ///
  /// Check the full list of [supported countries](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) for the MapBox API
  final String country;

  /// Specify the maximum number of results to return. The default is 5 and the maximum supported is 10.
  final int limit;

  final String _url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';

  PlacesSearch({
    this.apiKey,
    this.country,
    this.limit,
    this.language,
  }) : assert(apiKey != null);

  String _createUrl(String queryText, [Position position]) {
    String finalUrl = '$_url${Uri.encodeFull(queryText)}.json?';
    finalUrl += 'access_token=$apiKey';

    if (position != null) {
      finalUrl += '&proximity=${position.lng}%2C${position.lat}';
    }

    if (country != null) {
      finalUrl += "&country=$country";
    }

    if (limit != null) {
      finalUrl += "&limit=$limit";
    }

    if (language != null) {
      finalUrl += "&language=$language";
    }

    return finalUrl;
  }

  Future<FeatureCollection<Point>> getPlaces(
    String queryText, {
    Position position,
  }) async {
    String url = _createUrl(queryText, position);
    final response = await http.get(url);

    if (response?.body?.contains('message') ?? false) {
      throw Exception(json.decode(response.body)['message']);
    }

    return FeatureCollection<Point>.fromJson(json.decode(response.body));
  }
}

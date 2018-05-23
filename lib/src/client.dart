import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'models/category.dart';

typedef void APIErrorHandler(String endpoint, int statusCode, String response);

class WordpressClient {
  final Logger _logger = new Logger('API');

  String _baseURL;
  Client _client;
  APIErrorHandler _errorHandler;

  WordpressClient(this._baseURL, this._client, [this._errorHandler = null]);

  /// Get all available posts.
  Future<List<Map>> listPosts() async {
    String _endpoint = '/wp/v2/posts';

    List<Map> postMaps = await _get(_endpoint);
    return postMaps;
  }

  /// Get all available categories.
  Future<List<Category>> listCategories() async {
    String _endpoint = '/wp/v2/categories';

    // Retrieve the data
    List<Map> categoryMaps = await _get(_endpoint);

    List<Category> categories = new List();
    categories = categoryMaps
        .map((categoryMap) => new Category.fromMap(categoryMap))
        .toList();

    return categories;
  }

  _handleError(String endpoint, int statusCode, String response) {
    // If an error handler has been provided use that, otherwise log
    if (_errorHandler != null) {
      _errorHandler(endpoint, statusCode, response);
      return;
    }

    _logger.log(
        Level.SEVERE, "Received $statusCode from '$endpoint' => $response");
  }

  Future _get(String url) async {
    dynamic jsonObj;
    String endpoint = '$_baseURL$url';

    try {
      Response response = await _client.get(endpoint);

      // Error handling
      if (response.statusCode != 200) {
        _handleError(url, response.statusCode, response.body);
        return null;
      }

      jsonObj = json.decode(response.body);
    } catch (e) {
      _logger.log(Level.SEVERE, 'Error in GET call to $endpoint', e);
    }

    if (jsonObj is List) {
      // This is needed for Dart 2 type constraints
      return jsonObj.map((item) => item as Map).toList();
    }

    return jsonObj;
  }
}

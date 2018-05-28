import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'models/category.dart';
import 'models/post.dart';

typedef void APIErrorHandler(String endpoint, int statusCode, String response);

class WordpressClient {
  final Logger _logger = new Logger('API');

  String _baseURL;
  Client _client;
  APIErrorHandler _errorHandler;

  WordpressClient(this._baseURL, this._client, [this._errorHandler = null]);

  /// Get all available posts.
  Future<List<Post>> listPosts() async {
    String _endpoint = '/wp/v2/posts';

    // Retrieve the data
    List<Map> postMaps = await _get(_endpoint);

    List<Post> posts = new List();
    posts = postMaps.map((postMap) => new Post.fromMap(postMap)).toList();

    return posts;
  }

  /// Get all available categories.
  ///
  /// If [hideEmpty] is false then ALL categories will be returned, and
  /// [excludeIDs] can be used to ignore specific category IDs
  Future<List<Category>> listCategories(
      {bool hideEmpty: true, List<int> excludeIDs: null}) async {
    String _endpoint = '/wp/v2/categories';

    // Build query string
    String queryString = '';
    if (hideEmpty) {
      queryString = _addParamToQueryString(queryString, 'hide_empty', 'true');
    }
    if (excludeIDs != null && excludeIDs.length > 0) {
      queryString =
          _addParamToQueryString(queryString, 'exclude', excludeIDs.join(','));
    }

    // Append the query string
    _endpoint += queryString;
    print(_endpoint);

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

  String _addParamToQueryString(String queryString, String key, String value) {
    if (queryString == null) {
      queryString = '';
    }

    // If this is our first parameter, start with '?'
    if (queryString.length == 0) {
      queryString += '?';
    }

    // Otherwise, add '&'
    else {
      queryString += '&';
    }

    // TODO URLEncode
    queryString += '$key=$value';

    return queryString;
  }
}

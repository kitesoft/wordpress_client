import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'models/category.dart';
import 'models/media.dart';
import 'models/post.dart';

typedef void APIErrorHandler(String endpoint, int statusCode, String response);

class WordpressClient {
  final Logger _logger = new Logger('API');

  String _baseURL;
  Client _client;
  APIErrorHandler _errorHandler;

  WordpressClient(this._baseURL, this._client, [this._errorHandler = null]);

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

    // Retrieve the data
    List<Map> categoryMaps = await _get(_endpoint);

    List<Category> categories = new List();
    categories = categoryMaps
        .map((categoryMap) => new Category.fromMap(categoryMap))
        .toList();

    return categories;
  }

  /// Get all available posts.
  ///
  /// If [categoryIDs] list is provided then only posts within those categories
  /// will be returned. Use [injectObjects] to have full objects injected
  /// rather than just the object ID (i.e. a posts's featured media). The [page]
  /// and [perPage] parameters allow for pagination.
  Future<List<Post>> listPosts(
      {List<int> categoryIDs: null,
      bool injectObjects: true,
      int page: 1,
      int perPage: 10}) async {
    String _endpoint = '/wp/v2/posts';

    // Build query string starting with pagination
    String queryString = '';
    queryString = _addParamToQueryString(queryString, 'page', page.toString());
    queryString =
        _addParamToQueryString(queryString, 'per_page', perPage.toString());

    // If category IDs were sent, limit to those
    if (categoryIDs != null && categoryIDs.length > 0) {
      queryString = _addParamToQueryString(
          queryString, 'categories', categoryIDs.join(','));
    }

    // Append the query string
    _endpoint += queryString;

    // Retrieve the data
    List<Map> postMaps = await _get(_endpoint);

    List<Post> posts = new List();
    posts = postMaps.map((postMap) => new Post.fromMap(postMap)).toList();

    // Inject objects if requested
    if (injectObjects) {
      for (Post p in posts) {
        if (p.featuredMediaID != null && p.featuredMediaID > 0) {
          p.featuredMedia = await getMedia(p.featuredMediaID);
        }
      }
    }

    return posts;
  }

  /// Get post
  Future<Post> getPost(int postID, {bool injectObjects: true}) async {
    if (postID == null) {
      return null;
    }

    String _endpoint = '/wp/v2/posts/$postID';

    // Retrieve the data
    Map postMap = await _get(_endpoint);
    if (postMap == null) {
      return null;
    }

    Post p = new Post.fromMap(postMap);

    // Inject objects if requested
    if (injectObjects) {
      if (p.featuredMediaID != null && p.featuredMediaID > 0) {
        p.featuredMedia = await getMedia(p.featuredMediaID);
      }
    }

    return p;
  }

  /// Get media item
  Future<Media> getMedia(int mediaID) async {
    if (mediaID == null) {
      return null;
    }

    String _endpoint = '/wp/v2/media/$mediaID';

    // Retrieve the data
    Map mediaMap = await _get(_endpoint);
    if (mediaMap == null) {
      return null;
    }

    return new Media.fromMap(mediaMap);
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

    // TODO URL encode
    queryString += '$key=$value';

    return queryString;
  }
}

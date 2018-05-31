import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wordpress_client/src/client.dart';
import 'package:wordpress_client/src/models/category.dart';
import 'package:wordpress_client/src/models/post.dart';
import 'package:wordpress_client/wordpress_client.dart';

void main() {
  final String _baseURL = 'http://wpdart.silverbirchstudios.com/index.php/wp-json';

  group('API tests', () {
    WordpressClient client;

    setUp(() {
      client = new WordpressClient(_baseURL, new http.Client());
    });

    test('Get categories', () async {
      List<Category> categories = await client.listCategories();

      expect(categories, isList);
      expect(categories[0], new isInstanceOf<Category>());

      // TODO: Tests for hideEmpty and excludeIDs
    });

    test('Get posts', () async {
      List<Post> posts = await client.listPosts();

      expect(posts, isList);
      expect(posts[0], new isInstanceOf<Post>());

      // Now check the featured media injection
      posts = await client.listPosts(injectObjects: true);
      expect(posts[0].featuredMedia, new isInstanceOf<Media>());

      // Pagination
      posts = await client.listPosts(perPage: 2);
      expect(posts.length, equals(2));
      // TODO: Test for posts with a slug
    });

    test('Get post', () async {
      final int postID = 5;
      Post post = await client.getPost(postID);

      expect(post.id, isNotNull);
      expect(post, new isInstanceOf<Post>());

      // TODO: Test for posts with a slug
    });

    test('Get media', () async {
      final int mediaID = 12;
      Media media = await client.getMedia(mediaID);

      expect(media.id, isNotNull);
      expect(media, new isInstanceOf<Media>());

      // TODO: Test for posts with a slug
    });
  });
}

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wordpress_client/src/client.dart';
import 'package:wordpress_client/src/models/category.dart';
import 'package:wordpress_client/src/models/post.dart';

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
    });

    test('Get posts', () async {
      List<Post> posts = await client.listPosts();

      expect(posts, isList);
      expect(posts[0], new isInstanceOf<Post>());
    });
  });
}

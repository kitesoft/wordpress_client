import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wordpress_client/src/client.dart';
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
    });

    test('Get posts', () async {
      expect(await client.listPosts(), isList);
    });
  });
}

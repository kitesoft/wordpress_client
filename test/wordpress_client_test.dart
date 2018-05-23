import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wordpress_client/src/api.dart';
import 'package:wordpress_client/wordpress_client.dart';

void main() {
  final String _baseURL = 'http://wpdart.silverbirchstudios.com/index.php/wp-json';

  group('API tests', () {
    API api;

    setUp(() {
      api = new API(_baseURL, new http.Client());
    });

    test('Get posts', () async {
      expect(await api.getPosts(), isList);
    });
  });
}

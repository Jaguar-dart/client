import 'package:jaguar/jaguar.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:http/io_client.dart';

void main() {
  resty.globalClient = IOClient();
  group('A group of tests', () {
    Jaguar server;

    setUpAll(() async {
      server = Jaguar(port: 10000);
      server.get(
          '/api/add', (ctx) => ctx.query.getInt('a') + ctx.query.getInt('b'));
      server.post('/api/sub', (ctx) async {
        Map map = await ctx.bodyAsJsonMap();
        return map['a'] + map['b'];
      });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Query', () async {
      await resty
          .get('http://localhost:10000/api/add')
          .query('a', '5')
          .query('b', '20')
          .go()
          .exact(body: '25');
    });

    test('JSON body', () async {
      await resty
          .post('http://localhost:10000/api/sub')
          .json({'a': 5, 'b': 20}).go(then: (resp) => expect(resp.body, '25'));
    });
  });
}

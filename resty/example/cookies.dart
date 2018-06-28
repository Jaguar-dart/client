import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';

final server = new Jaguar(port: 8000)
  ..get(
      '/key',
      (Context ctx) => new StrResponse.json({'Msg': 'Success!'})
        ..cookies.add(new Cookie('Key', 'Pass')))
  ..getJson('/data', (Context ctx) async {
    if (!ctx.cookies.containsKey('Key')) return {'Msg': 'Invalid!'};
    if (ctx.cookies['Key'].value != 'Pass') return {'Msg': 'Invalid!'};
    return {'Msg': 'Success!'};
  })
  ..log.onRecord.listen(print);

final jar = new resty.CookieJar();

Future client() async {
  print(await resty
      .get('http://localhost:8000/data')
      .interceptBefore(jar.intercept)
      .go()
      .body);
  print(await resty
      .get('http://localhost:8000/key')
      .interceptBefore(jar.intercept)
      .go()
      .body);
  print(await resty
      .get('http://localhost:8000/data')
      .interceptBefore(jar.intercept)
      .go()
      .body);
}

main() async {
  resty.globalClient = new ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

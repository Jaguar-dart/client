import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';

final server = Jaguar(port: 8000)
  ..get(
      '/key',
      (Context ctx) => Response.json({'Msg': 'Success!'})
        ..cookies.add(Cookie('Key', 'Pass')))
  ..getJson('/data', (Context ctx) async {
    if (!ctx.cookies.containsKey('Key')) return {'Msg': 'Invalid!'};
    if (ctx.cookies['Key'].value != 'Pass') return {'Msg': 'Invalid!'};
    return {'Msg': 'Success!'};
  })
  ..log.onRecord.listen(print);

final jar = resty.CookieJar();

Future client() async {
  print(await resty.get('http://localhost:8000/data').before(jar).go().body);
  print(await resty.get('http://localhost:8000/key').before(jar).go().body);
  print(await resty.get('http://localhost:8000/data').before(jar).go().body);
}

main() async {
  resty.globalClient = ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

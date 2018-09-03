import 'dart:async';
import 'package:http/http.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';

final server = Jaguar(port: 8000)
  ..getJson('/math/addition',
      (Context ctx) => ctx.query.getInt("a") + ctx.query.getInt("b"));

resty.Before setQuery(int a, int b) => (resty.RouteBase route) {
      route.query("a", a);
      route.query("b", b);
    };

Response printResult(resty.Response<String> resp) {
  print(resp.body);
}

Future client() async {
  await resty
      .get('/math/addition')
      .http('localhost:8000')
      .interceptBefore(setQuery(5, 20))
      .interceptAfter(printResult)
      .go();
}

main() async {
  resty.globalClient = new ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

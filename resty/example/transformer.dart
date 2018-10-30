import 'dart:async';
import 'package:http/io_client.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';

// TODO WIP

final server = Jaguar(port: 8000)
  ..getJson('/math/addition',
      (Context ctx) => ctx.query.getInt("a") + ctx.query.getInt("b"));

resty.Before setQuery(int a, int b) => (resty.RouteBase route) {
      route.query("a", a);
      route.query("b", b);
    };

void printResult(resty.Response<String> resp) {
  print(resp.body);
}

Future client() async {
  await resty
      .get('/math/addition')
      .http('localhost:8000')
      .before(setQuery(5, 20))
      .after(printResult)
      .go();
}

main() async {
  resty.globalClient = new ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

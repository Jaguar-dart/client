import 'dart:async';
import 'package:http/io_client.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';

class Book {
  String id;

  String name;

  Book({this.id, this.name});

  static Book map(Map map) => new Book()..fromMap(map);

  Map toJson() => {
        'id': id,
        'name': name,
      };

  void fromMap(Map map) => this
    ..id = map['id']
    ..name = map['name'];

  String toString() => toJson().toString();
}

final books = <Book>[
  new Book(id: '1', name: 'Harry potter'),
  new Book(id: '2', name: 'Da Vinci code'),
  new Book(id: '3', name: 'Angels and deamons'),
];

final server = new Jaguar(port: 8000)
  ..getJson(
      '/book/:id',
      (Context ctx) => books.firstWhere((b) => b.id == ctx.pathParams['id'],
          orElse: () => null))
  ..postJson('/book', (Context ctx) async {
    books.add(await ctx.bodyAsJson(convert: Book.map));
    return books;
  });

Future client() async {
  print(
      await resty.get('/book/1').http('localhost:8000').one(convert: Book.map));
  print(await resty
      .post('/book')
      .http('localhost:8000')
      .json(new Book(id: '4', name: 'Book4'))
      .list(convert: Book.map));
}

main() async {
  resty.globalClient = new ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

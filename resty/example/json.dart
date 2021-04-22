import 'dart:async';
import 'package:http/io_client.dart' as ht;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_resty/method/uri_builder.dart';

class Book {
  String? id;

  String? name;

  Book({this.id, this.name});

  static Book map(Map map) => Book()..fromMap(map);

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
  Book(id: '1', name: 'Harry potter'),
  Book(id: '2', name: 'Da Vinci code'),
  Book(id: '3', name: 'Angels and deamons'),
];

final server = Jaguar(port: 8000)
  ..getJson('/book/:id',
      (Context ctx) => books.firstWhere((b) => b.id == ctx.pathParams['id']))
  ..postJson('/book', (Context ctx) async {
    books.add(await ctx.bodyAsJson(convert: Book.map));
    return books;
  });

Future client() async {
  print(await resty
      .get('http://localhost:8000/book/1')
      .readOne(convert: Book.map));
  print(await resty
      .post('http://localhost:8000/book')
      .json(Book(id: '4', name: 'Book4'))
      .readList(convert: Book.map));
}

main() async {
  resty.globalClient = ht.IOClient();

  await server.serve(logRequests: true);

  await client();
  await server.close();
}

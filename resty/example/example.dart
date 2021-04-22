import 'package:jaguar_resty/jaguar_resty.dart';

class Book {
  String id;

  String name;

  Book(this.id, this.name);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

Future<void> main() async {
  String id = '5';
  await get('http://localhost:8080/api/book/${id}').go();
  await get('http://localhost:8080/api').path('book').path(id).go();
  await get('/books').query('page', '2').go();
  await get('/book').header('page', '2').go();
  await post('/book').json(Book('1', 'Harry potter')).readOne();
}

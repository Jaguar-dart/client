/// Build fluent functional REST API clients
///
/// Example:
///     put('/api/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => new Book.fromMap(m));
library jaguar_resty;

export 'package:http/http.dart' show Response;

export 'package:jaguar_resty/expect/expect.dart';
export 'package:jaguar_resty/interceptor/interceptors.dart';
export 'package:jaguar_resty/method/method.dart';
export 'package:jaguar_resty/response/response.dart';

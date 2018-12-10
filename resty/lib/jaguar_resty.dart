/// Build fluent functional REST API clients
///
/// Example:
///     put('/api/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => new Book.fromMap(m));
library jaguar_resty;

export 'package:jaguar_resty/expect/expect.dart';
export 'package:jaguar_resty/interceptor/interceptors.dart';
export 'package:jaguar_resty/routes/routes.dart';
export 'package:jaguar_resty/response/response.dart';

/// Build fluent functional REST API clients
///
/// Example:
///     put('/api/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => new Book.fromMap(m));
library jaguar_resty;

export 'src/expect.dart';
export 'src/interceptors.dart';
export 'src/jaguar_resty_base.dart';
export 'src/response.dart';

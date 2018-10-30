library retrofit.annotations;

export 'requests.dart';
export 'params.dart';

class GenApiClient {
  final String path;
  final Map<String, dynamic> metadata;
  const GenApiClient({this.path, this.metadata: const {}});
}

export 'requests.dart';
export 'params.dart';

class GenApiClient {
  final String path;
  final Map<String, dynamic> metaData;
  const GenApiClient({this.path, this.metaData});
}

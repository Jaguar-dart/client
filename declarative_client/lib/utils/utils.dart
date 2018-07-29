import 'package:http/http.dart' as http;
import 'package:http/src/utils.dart' as http_utils;

bool responseSuccessful(http.Response response) =>
    response.statusCode >= 200 && response.statusCode < 300;

String paramsToQueryUri(Map<String, String> params) =>
    http_utils.mapToQuery(params);

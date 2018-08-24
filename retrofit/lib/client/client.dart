library jaguar.retrofit.client;

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

abstract class ApiClient {
  Route get base;
  SerializerRepo get serializers;
}

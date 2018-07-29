library declarative_client.client;

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_client/jaguar_client.dart';

abstract class ApiClient {
  Route get base;
  SerializerRepo get serializers;
}

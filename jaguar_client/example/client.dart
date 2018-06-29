// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

@Controller(path: '/api')
class ExampleApi {
  @GetJson(path: '/map')
  Map getMap(_) => {'jaguar': 'awesome'};

  @GetJson(path: '/list')
  List<String> getList(_) => ['Hello', 'World'];

  @GetJson(path: '/string')
  String getString(_) => "Jaguar";

  @GetJson(path: '/header')
  Map<String, String> getHeader(Context ctx) =>
      {'testing': ctx.req.headers.value('jaguar-testing')};

  @PostJson(path: '/map')
  Future<Map> postMap(Context ctx) => ctx.bodyAsJsonMap();

  @PutJson(path: '/map')
  Future<Map> putMap(Context ctx) => ctx.bodyAsJsonMap();

  @DeleteJson(path: '/map/:id')
  Map deleteMap(Context ctx) =>
      {'id': ctx.pathParams['id'], 'query': ctx.query['query']};

  @GetJson(path: '/bool')
  bool get(Context ctx) => false;
}

Future serve() async {
  Jaguar server = new Jaguar(port: 10123);
  server.add(reflect(new ExampleApi()));
  await server.serve();
}

Future client() async {
  final http.Client baseClient = new http.Client();
  final JsonClient client = new JsonClient(baseClient, repo: new JsonRepo());

  {
    final JsonResponse resp =
        await client.get('http://localhost:10123/api/map');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.get('http://localhost:10123/api/list');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.get('http://localhost:10123/api/string');
    print(resp.body);
  }

  {
    final JsonResponse resp = await client.get(
        'http://localhost:10123/api/header',
        headers: {'jaguar-testing': 'testing 1 2 3'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .post('http://localhost:10123/api/map', body: {'posting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .put('http://localhost:10123/api/map', body: {'putting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.delete('http://localhost:10123/api/map/123?query=why');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.get('http://localhost:10123/api/bool');
    print(resp.decode<bool>());
  }
}

main() async {
  await serve();
  await client();

  exit(0);
}

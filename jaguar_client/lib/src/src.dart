// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library http.json;

import 'dart:async';
import 'package:async/async.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'package:http/http.dart' as http;

import 'package:auth_header/auth_header.dart';

import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'authenticators.dart';
part 'client.dart';
part 'response.dart';
part 'resource.dart';
part 'serialized_client.dart';

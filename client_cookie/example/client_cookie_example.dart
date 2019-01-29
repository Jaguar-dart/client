// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:client_cookie/client_cookie.dart';

main() {
  // Initializing a cookie
  final cookie1 = ClientCookie('Client', 'jaguar_resty', DateTime.now());

  // Cookie to header string
  print(cookie1.toReqHeader);

  // Encoding many cookies
  final cookie2 = ClientCookie('Who', 'teja', DateTime.now());
  print(ClientCookie.toSetCookie([cookie1, cookie2]));

  print(parseSetCookie(ClientCookie.toSetCookie([cookie1, cookie2])));
}

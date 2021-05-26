import 'package:flutter/material.dart';

import '../models/config.dart';

import 'auth.dart';

class Goals with ChangeNotifier {
  Auth _auth;

  Config get config {
    return _auth.config;
  }

  set auth(Auth value) {
    _auth = value;
  }

  Goals({required Auth auth}) : _auth = auth;
}

import 'dart:convert';
import 'dart:io';

import 'models/awesome_list.dart';
import 'models/category.dart';
import 'models/entity.dart';

class AwesomeListMaker {
  Future<void> make(AwesomeList awesomeList) async {
    print(json.encode(awesomeList.toJson()));
  }
}

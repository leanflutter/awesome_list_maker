import 'dart:io';

import 'package:awesome_list_maker/awesome_list_maker.dart';
import 'package:yaml/yaml.dart';

Future<void> main(List<String> args) async {
  final awesomeListMaker = AwesomeListMaker();
  await awesomeListMaker.make();
}

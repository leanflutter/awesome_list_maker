import 'dart:io';

import 'package:awesome_list_maker/awesome_list_maker.dart';

Future<void> main(List<String> args) async {
  final awesomeListMaker = AwesomeListMaker(
    githubToken: Platform.environment['GITHUB_TOKEN'],
  );
  await awesomeListMaker.make();
}

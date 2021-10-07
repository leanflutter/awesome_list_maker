import 'dart:convert';
import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';
import 'package:yaml/yaml.dart';

import 'models/awesome_list.dart';
import 'models/category.dart';
import 'models/entity.dart';

const _kMdMark = '<!-- AWESOME_LIST_MAKER -->';

class AwesomeListMaker {
  Future<void> make() async {
    final File tmplFile = File('awesome_list.tmpl');
    final tmplString = tmplFile.readAsStringSync();

    final File yamlFile = File('awesome_list.yaml');
    final yamlString = yamlFile.readAsStringSync();

    AwesomeList awesomeList = AwesomeList.fromYaml(loadYaml(yamlString));

    Context context = Context.create()..variables = awesomeList.toJson();
    Template template = Template.parse(context, Source.fromString(tmplString));
    String renderedString = await template.render(context);

    File mdFile = File('README.md');
    String mdString = mdFile.readAsStringSync();

    int markIndexS = mdString.indexOf(_kMdMark) + _kMdMark.length;
    int markIndexE = mdString.lastIndexOf(_kMdMark);

    String newContent = '';
    newContent += mdString.substring(0, markIndexS);
    newContent += '\n$renderedString\n';
    newContent += mdString.substring(markIndexE);

    mdFile.writeAsStringSync(newContent);
  }
}

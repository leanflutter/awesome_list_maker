import 'dart:convert';
import 'dart:io';

import 'package:github/github.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';

import 'models/awesome_list.dart';
import 'models/entity.dart';
import 'utils/pretty_json.dart';

const _kMdMark = '<!-- AWESOME_LIST_MAKER -->';

class AwesomeListMaker {
  late GitHub ghClient;
  late PubClient pubClient;

  final File _ghCacheFile = File('.cache_gh.json');
  final File _pubCacheFile = File('.cache_pub.json');
  Map<String, dynamic> _ghCacheMap = {};
  Map<String, dynamic> _pubCacheMap = {};

  AwesomeListMaker({
    String? githubToken,
  }) {
    ghClient = GitHub(auth: Authentication.withToken(githubToken));
    pubClient = PubClient();
  }

  Future<Repository> _getGhRepository(String githubId) async {
    if (_ghCacheFile.existsSync()) {
      String jsonString = await _ghCacheFile.readAsString();
      _ghCacheMap = json.decode(jsonString);
    }
    Repository repository;
    if (_ghCacheMap.containsKey(githubId)) {
      repository = Repository.fromJson(_ghCacheMap[githubId]);
    } else {
      var slug = RepositorySlug(githubId.split('/')[0], githubId.split('/')[1]);
      repository = await ghClient.repositories.getRepository(slug);
      _ghCacheMap.putIfAbsent(githubId, () => repository.toJson());

      String jsonString = prettyJsonString(_ghCacheMap);
      _ghCacheFile.writeAsStringSync(jsonString);
    }
    return repository;
  }

  Future<PubPackage> _getPubPackage(String pubId) async {
    if (_pubCacheFile.existsSync()) {
      String jsonString = await _pubCacheFile.readAsString();
      _pubCacheMap = json.decode(jsonString);
    }
    PubPackage pubPackage;
    if (_pubCacheMap.containsKey(pubId)) {
      pubPackage = PubPackage.fromJson(_pubCacheMap[pubId]);
    } else {
      pubPackage = await pubClient.packageInfo(pubId);
      _pubCacheMap.putIfAbsent(pubId, () => pubPackage.toJson());

      String jsonString = prettyJsonString(_pubCacheMap);
      _pubCacheFile.writeAsStringSync(jsonString);
    }
    return pubPackage;
  }

  Future<void> make() async {
    final File tmplFile = File('awesome_list.tmpl');
    final tmplString = tmplFile.readAsStringSync();

    final File yamlFile = File('awesome_list.yaml');
    final yamlString = yamlFile.readAsStringSync();

    AwesomeList awesomeList = AwesomeList.fromYaml(loadYaml(yamlString));
    for (var i = 0; i < awesomeList.entities.length; i++) {
      Entity entity = awesomeList.entities[i];
      if (entity.pub_id != null) {
        PubPackage pubPackage = await _getPubPackage(entity.pub_id!);
        awesomeList.entities[i].description = pubPackage.description.trim();
      } else if (entity.github_id != null) {
        Repository repository = await _getGhRepository(entity.github_id!);
        awesomeList.entities[i].description = repository.description.trim();
      }
    }

    Context context = Context.create()..variables = awesomeList.toJson();
    Template template = Template.parse(context, Source.fromString(tmplString));
    String renderedString = await template.render(context)
      ..replaceAll('\n\n', '\n');

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

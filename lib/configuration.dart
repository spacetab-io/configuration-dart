library configuration_dart;

import 'dart:io';

import 'package:configuration/logger_interface.dart';
import 'package:configuration/null_logger.dart';
import 'package:merge_map/merge_map.dart';
import 'package:yaml/yaml.dart';

class Configuration {
  static const String _CONFIG_PATH = "CONFIG_PATH";
  static const String _DEFAULT_CONFIG_PATH = "./configuration";
  static const String _STAGE = "STAGE";
  static const String _DEFAULT_STAGE = "local";

  final String path;
  final String stage;

  Map _config = {};
  LoggerInterface logger;

  Configuration({
    String path,
    String stage,
  })  : this.path = path ??
            _getEnvVariable(
              _CONFIG_PATH,
              _DEFAULT_CONFIG_PATH,
            ),
        this.stage = stage ??
            _getEnvVariable(
              _STAGE,
              _DEFAULT_STAGE,
            ),
        logger = NullLogger();

  void load() {
    logger.info('$_CONFIG_PATH = $path');
    logger.info('$_STAGE = $stage');

    try {
      _config = Configuration._mergeRecursive(
        _parseConfiguration(),
        _parseConfiguration(stage),
      );
    } catch (error) {
      logger.error(error.toString());
      throw error;
    }

    logger.info('Configuration module loaded');
  }

  Map _parseConfiguration([String currentStage = "defaults"]) {
    final String _path = '$path${Platform.pathSeparator}$currentStage';
    final Directory _folder = Directory(_path);

    if (!_folder.existsSync()) {
      throw Exception("Directory for $_STAGE - '$currentStage' does not exist");
    }

    final List<FileSystemEntity> _folderFiles = _folder.listSync().toList();
    final List<File> _configurationFiles = _folderFiles
        .where((FileSystemEntity file) {
          return file is File &&
              (file.path.contains(".yaml") || file.path.contains(".yml"));
        })
        .map((FileSystemEntity file) => file as File)
        .toList();

    if (_configurationFiles.length > 0) {
      logger.debug(
        "Following configuration files found for $_STAGE - '$currentStage': $_configurationFiles",
      );
      return _eachReadAndMerge(_configurationFiles, currentStage);
    } else {
      logger.debug("No configuration files for $_STAGE - '$stage'");
      return {};
    }
  }

  Map _eachReadAndMerge(List<File> files, [String currentStage]) {
    Map _configurations = {};

    for (File file in files) {
      final String _fileContent = file.readAsStringSync();

      if (_fileContent != "") {
        Map _content = loadYaml(_fileContent) as Map;

        if (currentStage != "") {
          _content = _content[currentStage];

          if (_content == null) {
            throw Exception(
              "There is no top level configuration key '$currentStage' in file for $_STAGE: '$currentStage': $file",
            );
          }
        }

        _configurations = Configuration._mergeRecursive(
          _configurations,
          _content,
        );
      } else {
        logger.debug("No content in $file, skipping");
      }
    }

    return _configurations;
  }

  Map get all => _config;

  T get<T>(String path, [T defaultValue]) {
    final List<String> _pathParts = path.split('.');
    dynamic _content = _config[_pathParts.removeAt(0)];

    if (_pathParts.length > 0) {
      for (String part in _pathParts) {
        if (_content is Map) {
          _content = (_content as Map)[part];
        } else {
          throw Exception("Wrong path: $path");
        }
      }
    }

    return _content as T ?? defaultValue;
  }

  static Map _mergeRecursive(Map x, Map y) {
    return mergeMap([x, y]);
  }

  static String _getEnvVariable(String name, [String defaultValue = ""]) {
    return Platform.environment[name] ?? defaultValue;
  }
}

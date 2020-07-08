import 'package:test/test.dart';
import 'package:configuration/configuration.dart';

void main() {
  group('Configuration test', () {
    test('Configuration is instantiable', () {
      expect(Configuration(), isA<Configuration>());
    });

    test('Configuration is instantiable with constructors params', () {
      final Configuration conf = Configuration(
        path: './conf',
        stage: 'dev',
      );

      expect(conf.path, equals('./conf'));
      expect(conf.stage, equals('dev'));
    });

    test('Configuration loaded with defaults', () {
      final Configuration conf = Configuration();

      expect(conf.path, equals('./configuration'));
      expect(conf.stage, equals('defaults'));
    });

    test('loaded configuration and parsed', () {
      final Configuration conf = Configuration(
        path: './test/configuration_spec',
        stage: 'test',
      );
      conf.load();

      final Map expected = {
        'hotelbook_params': {
          'area_mapping': {
            'KRK': 'Krakow',
            'MSK': 'Moscow',
            'CHB': 'Челябинск',
          },
          'url': 'https://hotelbook.com/xml_endpoint',
          'username': 'TESt_USERNAME',
          'password': 'PASSWORD',
        },
        'logging': 'info',
        'default_list': ['bar', 'baz'],
        'empty_array': ['foo'],
        'databases': {
          'redis': {
            'master': {
              'username': 'R_USER',
              'password': 'R_PASS',
            }
          }
        }
      };

      expect(conf.all, equals(expected));
      expect(conf.get('hotelbook_params.area_mapping.KRK'), equals('Krakow'));
      expect(conf.get('default_list'), equals(['bar', 'baz']));
    });

    test('Loading symlinks configs', () {
      final Configuration conf = Configuration(
        path: './test/configuration_symlinks',
        stage: 'test',
      );
      conf.load();

      final Map expected = {
        'redis': {
          'hostname': '127.0.0.1',
          'password': '',
          'database': 0,
          'port': 6379,
        },
        'debug': true,
        'log': {
          'level': 'wa"rn',
          'format': "js'on",
        },
        'host': 'localhost',
        'port': 8080,
      };

      expect(conf.all, equals(expected));
      expect(conf.get('redis.port'), equals(6379));
      expect(conf.get('debug'), isTrue);
    });
  });
}

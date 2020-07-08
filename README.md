Dart language configuration module
----------------------------------

Configuration module for applications written on Dart. Preserves [corporate standards for services configuration](https://confluence.teamc.io/pages/viewpage.action?pageId=4227704).

## Installation

Import in your `pubscpec.yaml` configuration file

```yaml
dependencies:
  auth_flutter_login:
      git:
        url: https://github.com/spacetab-io/configuration-dart.git
```

## Usage

By default path to configuration directory and application stage
loading from `./configuration` with `local` stage.
 
Code example:

1) Simple with standard logger
```dart
import 'package:configuration/configuration.dart';

// if you want use standard logger
import 'package:configuration/stdout_console_logger.dart';

void main() {
  final Configuration config = Configuration();
  final StdoutConsoleLogger logger = StdoutConsoleLogger(true); // fasle if you don't want debug logs
  
  
  config.logger = logger;
  config.load();
  
  print(config.all); // get all config
  print(config.get('foo.bar')); // get nested key use dot notation
}
```


2) If you would like override default values, you can pass 2 arguments to
class constructor or set up use setters.

```dart
import 'package:configuration/configuration.dart';

// if you want use standard logger
import 'package:configuration/stdout_console_logger.dart';

void main() {
  final Configuration config = Configuration(path: './configuration', stage: 'test');
  // or
  // config.path = './configs';
  // config.stage = 'local';
  config.load();
  
  print(config.all); // get all config
}
```

3) If the operating system has an env variables `CONFIG_PATH` and `STAGE`,
then values for the package will be taken from there.

```bash
export CONFIG_PATH=./configuration
export STAGE=prod
```

```dart
import 'package:configuration/configuration.dart';

void main() {
  final Configuration config = Configuration();
  config.load(); // loaded files from ./configuration for prod stage.
  
  print(config.get('foo.bar')); // get nested key use dot notation
}
```

Or if you would like use external logger,
integrate it with [LoggerInterface](./lib/logger_interface.dart). Just a write the adapter for it.

## License

The MIT License

Copyright © 2020 SpaceTab.io, Inc. https://spacetab.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

import 'dart:io';

void main() async {
  // gen_l10n
  const srcPath = 'lib/core/localization/generated/app_localizations.dart';
  const outPath = 'lib/core/localization/l10n/l10n_forwarders.g.dart';

  final src = await File(srcPath).readAsString();

  // find the abstract class
  final abstractClassMatch = RegExp(
    r'abstract class\s+AppLocalizations\s*\{([\s\S]*?)^\}',
    multiLine: true,
  ).firstMatch(src);
  if (abstractClassMatch == null) {
    stderr.writeln(
      'Could not find abstract class AppLocalizations in $srcPath',
    );
    exit(1);
  }

  final body = abstractClassMatch.group(1)!;

  // get the getters:  String get keyName;
  final getterRegex = RegExp(
    r'\bString\s+get\s+([a-zA-Z_]\w*)\s*;',
    multiLine: true,
  );
  final getters = getterRegex.allMatches(body).map((m) => m.group(1)!).toList();

  // get the methods with simple parameters (String name) / (int count)
  final methodRegex = RegExp(
    r'\bString\s+([a-zA-Z_]\w*)\s*\(\s*(?:int\s+([a-zA-Z_]\w*)|String\s+([a-zA-Z_]\w*))\s*\)\s*;',
    multiLine: true,
  );
  final methods = <String, Map<String, String>>{};
  for (final m in methodRegex.allMatches(body)) {
    final name = m.group(1)!;
    final intParam = m.group(2);
    final stringParam = m.group(3);
    if (intParam != null) {
      methods[name] = {'type': 'int', 'name': intParam};
    } else if (stringParam != null) {
      methods[name] = {'type': 'String', 'name': stringParam};
    }
  }

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln('// *****************************************************')
    ..writeln('//  L10n forwarders generated from app_localizations.dart')
    ..writeln('//  Run: dart run tool/generate_l10n_forwarders.dart')
    ..writeln('// *****************************************************')
    ..writeln()
    ..writeln("part of '../localization.dart';")
    ..writeln()
    ..writeln(
      '/// Global localization utility for accessing translations without context',
    )
    ..writeln('class L10n {')
    ..writeln('  /// The current app localizations instance')
    ..writeln('  static AppLocalizations? _current;')
    ..writeln()
    ..writeln('  /// Initialize the global localization instance')
    ..writeln('  static void init(BuildContext context) {')
    ..writeln('    _current = AppLocalizations.of(context);')
    ..writeln('  }')
    ..writeln()
    ..writeln('  /// Get the current app localizations instance')
    ..writeln('  static AppLocalizations get _tr {')
    ..writeln('    if (_current == null) {')
    ..writeln(
      "      throw Exception('L10n used before init. Call L10n.init(context) after Localizations load.');",
    )
    ..writeln('    }')
    ..writeln('    return _current!;')
    ..writeln('  }')
    ..writeln()
    ..writeln('  // Getters')
    ..writeAll(getters.map((g) => '  static String get $g => _tr.$g;\n'))
    ..writeln()
    ..writeln('  // Methods')
    ..writeAll(
      methods.entries.map((e) {
        final name = e.key;
        final pType = e.value['type']!;
        final pName = e.value['name']!;
        return '  static String $name($pType $pName) => _tr.$name($pName);\n';
      }),
    )
    ..writeln('}');

  await File(outPath).writeAsString(buffer.toString());
  stdout.writeln(
    '✅ Generated $outPath with ${getters.length} getters and ${methods.length} methods.',
  );
}

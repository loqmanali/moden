import 'dart:io';

final _versionPattern =
    RegExp(r'^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$', multiLine: true);

Future<String> bumpBuildNumber() async {
  final pubspecFile = File('pubspec.yaml');

  if (!await pubspecFile.exists()) {
    throw const ProcessException(
      'pubspec.yaml',
      [],
      'pubspec.yaml not found in the current directory.',
      1,
    );
  }

  final content = await pubspecFile.readAsString();
  final match = _versionPattern.firstMatch(content);

  if (match == null) {
    throw const ProcessException(
      'pubspec.yaml',
      [],
      'Failed to find a version line in pubspec.yaml.',
      1,
    );
  }

  final semanticVersion = match.group(1)!;
  final buildNumber = int.parse(match.group(2)!);
  final nextBuildNumber = buildNumber + 1;

  final updatedContent = content.replaceRange(
    match.start,
    match.end,
    'version: $semanticVersion+$nextBuildNumber',
  );

  await pubspecFile.writeAsString(updatedContent);
  return '$semanticVersion+$nextBuildNumber';
}

Future<String> readCurrentVersion() async {
  final pubspecFile = File('pubspec.yaml');

  if (!await pubspecFile.exists()) {
    throw const ProcessException(
      'pubspec.yaml',
      [],
      'pubspec.yaml not found in the current directory.',
      1,
    );
  }

  final content = await pubspecFile.readAsString();
  final match = _versionPattern.firstMatch(content);

  if (match == null) {
    throw const ProcessException(
      'pubspec.yaml',
      [],
      'Failed to find a version line in pubspec.yaml.',
      1,
    );
  }

  final semanticVersion = match.group(1)!;
  final buildNumber = match.group(2)!;
  return '$semanticVersion+$buildNumber';
}

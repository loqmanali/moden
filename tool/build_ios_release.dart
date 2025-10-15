import 'dart:io';

import 'build_version_utils.dart';

Future<void> main(List<String> arguments) async {
  final shouldBump = !arguments.contains('--skip-version-bump');

  try {
    final version = shouldBump
        ? await bumpBuildNumber()
        : await readCurrentVersion();

    stdout.writeln('ℹ️  Building iOS with version $version');

    await _runCommand('flutter', ['clean']);
    await _runCommand('flutter', ['pub', 'get']);
    await _runCommand('flutter', ['build', 'ipa', '--release']);

    stdout.writeln('✅ IPA built successfully in release mode.');
  } on ProcessException catch (error) {
    stderr.writeln('❌ Build failed: ${error.message}');
    exitCode = error.errorCode;
  }
}

Future<void> _runCommand(String executable, List<String> arguments) async {
  final commandDescription = '$executable ${arguments.join(' ')}';
  stdout.writeln('➡️  Running: $commandDescription');

  final process = await Process.start(
    executable,
    arguments,
    runInShell: true,
  );
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw ProcessException(
      executable,
      arguments,
      'Command exited with code $exitCode',
      exitCode,
    );
  }
}

import 'dart:io';

Future<void> main() async {
  try {
    await _runCommand('flutter', ['gen-l10n']);
    await _runCommand('dart', ['run', 'tool/generate_l10n_forwarders.dart']);
    stdout.writeln('✅ Localization assets generated successfully.');
  } on ProcessException catch (error) {
    stderr
        .writeln('❌ Failed to generate localization assets: ${error.message}');
    exitCode = error.errorCode;
  }
}

Future<void> _runCommand(String executable, List<String> arguments) async {
  final commandDescription = '$executable ${arguments.join(' ')}';
  stdout.writeln('➡️  Running: $commandDescription');

  final process = await Process.start(executable, arguments);
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

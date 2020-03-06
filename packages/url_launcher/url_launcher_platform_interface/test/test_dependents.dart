// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:http/http.dart' as http;

void main() {
  test('url_launcher tests', () async {
    String packageDir = Directory.fromUri(Platform.script).parent.path;
    File pubspecFile = File(path.join(packageDir, 'pubspec.yaml'));
    assert(pubspecFile.existsSync());
    Pubspec pubspec = Pubspec.parse(pubspecFile.readAsStringSync());

    print('Package name: ${pubspec.name} version: ${pubspec.version}');
    final Directory testDir = Directory.systemTemp.createTempSync();
    print ('Test dir is: $testDir');
    await fetchLatestVersionSync('url_launcher', testDir);

    ProcessRunner processRunner = ProcessRunner();
    await processRunner.runAndExitOnError('tar', ['-zxvf', 'package.tar.gz'], workingDir: testDir);

    File dependentPubspec = File(path.join(testDir.path, 'pubspec.yaml'));
    assert(dependentPubspec.existsSync());

    // Add a dependency override for url_launcher_platform_interface to dependentPubspec

    await processRunner.runAndStream('flutter', ['test'], workingDir: testDir);

  });
}

void fetchLatestVersionSync(String package, Directory outDir) async {
  Uri metadataUri = Uri.https('pub.dev', '/api/packages/$package');
  print('$metadataUri');
  http.Response response = await http.get(metadataUri);
  assert (response.statusCode == 200);
  Map<String, dynamic> responseMap = jsonDecode(response.body);
  String tarballUri = responseMap['latest']['archive_url'];

  response = await http.get(tarballUri);
  assert (response.statusCode == 200);
  File tarballFile = File(path.join(outDir.path, 'package.tar.gz'));
  await tarballFile.writeAsBytes(response.bodyBytes);
}


class ProcessRunner {
  const ProcessRunner();

  /// Run the [executable] with [args] and stream output to stderr and stdout.
  ///
  /// The current working directory of [executable] can be overridden by
  /// passing [workingDir].
  ///
  /// If [exitOnError] is set to `true`, then this will throw an error if
  /// the [executable] terminates with a non-zero exit code.
  ///
  /// Returns the exit code of the [executable].
  Future<int> runAndStream(
      String executable,
      List<String> args, {
        Directory workingDir,
        bool exitOnError = false,
      }) async {
    final Process process = await Process.start(executable, args,
        workingDirectory: workingDir?.path);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);
    if (exitOnError && await process.exitCode != 0) {
      final String error =
      _getErrorString(executable, args, workingDir: workingDir);
      print('$error See above for details.');
      throw Exception(await process.exitCode);
    }
    return process.exitCode;
  }

  /// Run the [executable] with [args].
  ///
  /// The current working directory of [executable] can be overridden by
  /// passing [workingDir].
  ///
  /// If [exitOnError] is set to `true`, then this will throw an error if
  /// the [executable] terminates with a non-zero exit code.
  ///
  /// Returns the [ProcessResult] of the [executable].
  Future<ProcessResult> run(String executable, List<String> args,
      {Directory workingDir,
        bool exitOnError = false,
        stdoutEncoding = systemEncoding,
        stderrEncoding = systemEncoding}) async {
    return Process.run(executable, args,
        workingDirectory: workingDir?.path,
        stdoutEncoding: stdoutEncoding,
        stderrEncoding: stderrEncoding);
  }

  /// Starts the [executable] with [args].
  ///
  /// The current working directory of [executable] can be overridden by
  /// passing [workingDir].
  ///
  /// Returns the started [Process].
  Future<Process> start(String executable, List<String> args,
      {Directory workingDirectory}) async {
    final Process process = await Process.start(executable, args,
        workingDirectory: workingDirectory?.path);
    return process;
  }

  /// Run the [executable] with [args], throwing an error on non-zero exit code.
  ///
  /// Unlike [runAndStream], this does not stream the process output to stdout.
  /// It also unconditionally throws an error on a non-zero exit code.
  ///
  /// The current working directory of [executable] can be overridden by
  /// passing [workingDir].
  ///
  /// Returns the [ProcessResult] of running the [executable].
  Future<ProcessResult> runAndExitOnError(
      String executable,
      List<String> args, {
        Directory workingDir,
      }) async {
    final ProcessResult result = await Process.run(executable, args,
        workingDirectory: workingDir?.path);
    if (result.exitCode != 0) {
      final String error =
      _getErrorString(executable, args, workingDir: workingDir);
      print('$error Stderr:\n${result.stdout}');
      throw Exception(result.exitCode);
    }
    return result;
  }

  String _getErrorString(String executable, List<String> args,
      {Directory workingDir}) {
    final String workdir = workingDir == null ? '' : ' in ${workingDir.path}';
    return 'ERROR: Unable to execute "$executable ${args.join(' ')}"$workdir.';
  }
}

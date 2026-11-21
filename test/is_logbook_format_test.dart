import 'dart:io';
import 'dart:typed_data';

import 'package:is_logbook_format/is_logbook_format.dart';
import 'package:test/test.dart';

void main() {
  group('Kind', () {
    test('parse takes what a sender may write', () {
      expect(Kind.parse('turn')?.name, 'turn');
      expect(Kind.parse('reply-chunk_2.x'), isNotNull);
      expect(Kind.parse('mission-ended'), Kind.missionEnded);
    });

    test('parse refuses started, -, an empty name and other characters', () {
      for (final bad in ['started', '-', '', 'tu/rn', 'tu rn', 'tü']) {
        expect(Kind.parse(bad), isNull, reason: bad);
      }
    });

    test('read takes started as well, and nothing else parse refuses', () {
      expect(Kind.read('started'), Kind.started);
      expect(Kind.read('turn'), Kind.parse('turn'));
      for (final bad in ['-', '', 'tu/rn']) {
        expect(Kind.read(bad), isNull, reason: bad);
      }
    });

    test('is its name', () {
      expect(
        '${Kind.usersAssignedToTrajectory}',
        'users-assigned-to-trajectory',
      );
      expect('${Kind.trajectoryClosed}', 'trajectory-closed');
    });
  });

  group('LogbookEntry', () {
    final entry = LogbookEntry(
      EntryHash.origin,
      FileSetId.fromDigest(Uint8List(32)..fillRange(0, 32, 1))!,
      ObjectId.of(Uint8List.fromList('hello'.codeUnits)),
    );

    test('encodes as previous, code and object, 32 bytes each', () {
      final bytes = entry.encode();
      expect(bytes.length, LogbookEntry.length);
      expect(bytes.sublist(0, 32), EntryHash.origin.bytes);
      expect(bytes.sublist(32, 64), List.filled(32, 1));
      expect(bytes.sublist(64), entry.object.bytes);
    });

    test('reads back what it encodes', () {
      final read = LogbookEntry.parse(entry.encode())!;
      expect(
        [read.previous, read.code, read.object],
        [entry.previous, entry.code, entry.object],
      );
    });

    test('reads nothing but 96 bytes', () {
      expect(LogbookEntry.parse(Uint8List(95)), isNull);
      expect(LogbookEntry.parse(Uint8List(97)), isNull);
    });
  });

  test("the origin is the sha256 of the format's name", () {
    final r = Process.runSync('bash', [
      '-c',
      "printf 'is_logbook/1' | shasum -a 256",
    ]);
    expect(EntryHash.origin.hex, (r.stdout as String).substring(0, 64));
  });
}

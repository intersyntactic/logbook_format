import 'dart:typed_data';

import 'package:is_content_id/is_content_id.dart';

/// The sha256 of one logbook entry.
final class EntryHash extends Sha256Name {
  EntryHash._(super.digest);

  /// [entry]'s hash.
  factory EntryHash.of(Uint8List entry) => EntryHash._(sha256(entry));

  static EntryHash? parse(String s) => switch (Sha256Name.digestOfHex(s)) {
    final d? => EntryHash._(d),
    null => null,
  };

  static EntryHash? fromDigest(Uint8List digest) =>
      digest.length == 32 ? EntryHash._(digest) : null;

  /// What the first entry names as the entry before it: the sha256 of the
  /// logbook format's name, so a logbook in another format breaks at its
  /// first entry, and anyone can compute it with
  /// `printf 'is_logbook/1' | shasum -a 256`.
  static final origin = EntryHash.of(
    Uint8List.fromList('is_logbook/1'.codeUnits),
  );
}

/// One entry of a logbook, three names: `previous │ code │ object`, 32 bytes
/// each. Whether the person approved [code] is not in it: is_logbook reads
/// that from `approved` whenever the logbook is read, so approving a hash
/// covers what it already wrote and removing it takes that back.
final class LogbookEntry {
  const LogbookEntry(this.previous, this.code, this.object);

  /// An entry's length in bytes.
  static const length = 96;

  final EntryHash previous;
  final FileSetId code;
  final ObjectId object;

  /// [bytes] as an entry, read back; null unless they are [length] bytes.
  static LogbookEntry? parse(Uint8List bytes) {
    if (bytes.length != length) return null;
    return switch ((
      EntryHash.fromDigest(Uint8List.sublistView(bytes, 0, 32)),
      FileSetId.fromDigest(Uint8List.sublistView(bytes, 32, 64)),
      ObjectId.fromDigest(Uint8List.sublistView(bytes, 64, 96)),
    )) {
      (final p?, final c?, final o?) => LogbookEntry(p, c, o),
      _ => null,
    };
  }

  /// The entry's [length] bytes, as the logbook keeps them.
  Uint8List encode() => Uint8List(length)
    ..setAll(0, previous.bytes)
    ..setAll(32, code.bytes)
    ..setAll(64, object.bytes);
}

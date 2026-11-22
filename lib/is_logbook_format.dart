/// The format an is_logbook keeps and speaks, without the code that writes
/// it: [LogbookEntry] and [EntryHash], the record the `entries` file is made
/// of, and [Kind], the first line of every entry's bytes.
///
/// A program that reads or writes a logbook through its service needs these
/// and nothing else, so depending on this package gives it no way to open
/// the logbook's directory itself.
library;

export 'package:is_content_id/is_content_id.dart';

export 'src/entry.dart';
export 'src/kind.dart';

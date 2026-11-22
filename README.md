# is_logbook_format

The format an [is_logbook](https://pub.dev/packages/is_logbook) keeps and
speaks, without the code that writes it:

- `LogbookEntry`: one 96-byte record of the `entries` file, three sha256
  names: the entry before it (`EntryHash`), the code that wrote it
  (`FileSetId`) and the bytes (`ObjectId`).
- `EntryHash`: the sha256 of an entry. `EntryHash.origin` is what the first
  entry names as the one before it: `printf 'is_logbook/1' | shasum -a 256`.
- `Kind`: the first line of an entry's bytes. `Kind.parse` takes a kind a
  sender may write. `Kind.read` also takes `started`, which only the
  service writes.

It re-exports [is_content_id](https://pub.dev/packages/is_content_id)
(`ObjectId`, `FileSetId`).

## Who depends on it

The logbook's writer and service (`is_logbook`) and every program that
talks to that service through
[is_logbook_client](https://pub.dev/packages/is_logbook_client). A
program that reads or writes through the service needs the format and
nothing else, so depending on this package, not on `is_logbook`, gives it
no way to open the logbook's directory and append past the service.

Its code is in is_logbook's code hash: it decides the bytes every entry is
written as.

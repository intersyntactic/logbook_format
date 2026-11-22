# Changelog

## 0.1.0

- `LogbookEntry`, `EntryHash` and `Kind`, moved out of is_logbook 0.3.0
  unchanged, so a program that talks to the logbook's service can depend
  on the format without depending on the writer.
- `Kind.read`: a kind an entry is recorded with, `started` included. It
  replaces `name == Kind.started.name ? Kind.started : Kind.parse(name)`,
  which the service and the client each wrote out.

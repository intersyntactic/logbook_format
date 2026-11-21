/// The kind of an entry, the first line of its bytes: a name of letters,
/// digits, `.`, `_` and `-`. Never `-`, which reads as "no previous entry".
/// A sender never writes [started], which only the service writes.
final class Kind {
  Kind._(this.name);

  final String name;

  /// The kind of the entry the service adds on every start.
  static final started = Kind._('started');

  /// The kind that roots a trajectory's chain and names the one user who
  /// may extend it.
  static final usersAssignedToTrajectory = Kind._(
    'users-assigned-to-trajectory',
  );

  /// The kind that closes every chain of a mission.
  static final missionEnded = Kind._('mission-ended');

  /// The kind that closes every chain of one trajectory.
  static final trajectoryClosed = Kind._('trajectory-closed');

  static final _name = RegExp(r'^[A-Za-z0-9._-]+$');

  /// [s] as a kind a sender may write; null unless it is one. Never
  /// [started].
  static Kind? parse(String s) =>
      s != '-' && s != started.name && _name.hasMatch(s) ? Kind._(s) : null;

  /// [s] as the kind of an entry the logbook holds: any kind [parse] takes,
  /// and [started]. Null unless it is one.
  static Kind? read(String s) => s == started.name ? started : parse(s);

  @override
  bool operator ==(Object other) => other is Kind && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

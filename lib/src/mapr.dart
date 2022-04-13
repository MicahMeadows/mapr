import '../mapr.dart';

class Mapr {
  static final Mapr _mapr = Mapr._(Mapper());

  /// Get or register mapr service
  factory Mapr() {
    return _mapr;
  }

  Mapper get I {
    return _mapper;
  }

  final Mapper _mapper;

  Mapr._(this._mapper);
}

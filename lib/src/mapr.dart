import 'map_model.dart';
import 'mapping_exception.dart';

/// Object mapping service
class Mapr {
  static final Mapr _mapper = Mapr._();

  /// Get or register mapr service
  factory Mapr() {
    return _mapper;
  }

  Mapr._();

  final List<MapModel> _maps = [];
  void addMap<TSrc, TDst>(TDst Function(TSrc source) function) {
    _maps.add(MapModel<TSrc, TDst>(function));
  }

  TDst map<TSrc, TDst>(TSrc sourceObject) {
    final rawMapModel = _maps.firstWhere((element) {
      return element.sourceType == TSrc && element.destinationType == TDst;
    }, orElse: () {
      throw MapModelNotFoundException(sourceType: TSrc, destinationType: TDst);
    });

    final mapModel = rawMapModel as MapModel<TSrc, TDst>;
    try {
      final convertResult = mapModel.convert(sourceObject);
      return convertResult;
    } catch (e) {
      throw FailedToMapException(
        sourceType: TSrc,
        destinationType: TDst,
        message: e.toString(),
      );
    }
  }
}

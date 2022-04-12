import 'map_model.dart';
import 'mapping_exception.dart';

class Mapr {
  static final Mapr _mapper = Mapr._();

  factory Mapr() {
    return _mapper;
  }

  Mapr._();

  List<MapModel> maps = [];
  void addMap<TSrc, TDst>(TDst Function(TSrc source) function) {
    maps.add(MapModel<TSrc, TDst>(function));
  }

  TDst map<TSrc, TDst>(TSrc sourceObject) {
    final sourceType = sourceObject.runtimeType;

    final rawMapModel = maps.firstWhere((element) {
      return element.sourceType == sourceType &&
          element.destinationType == TDst;
    }, orElse: () {
      // throw Exception('Mapping model for <$TSrc> to <$TDst> not found.');
      throw MapModelNotFoundException(sourceType: TSrc, destinationType: TDst);
    });

    final mapModel = rawMapModel as MapModel<TSrc, TDst>;
    try {
      final convertResult = mapModel.convert(sourceObject);
      return convertResult;
    } catch (e) {
      throw MappingFailureException(sourceType: TSrc, destinationType: TDst);
    }
  }
}

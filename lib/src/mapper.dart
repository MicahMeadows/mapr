import 'mapper_model.dart';

class Mapper {
  static final Mapper _mapper = Mapper._();

  static final Mapper mapr = Mapper();

  factory Mapper() {
    return _mapper;
  }

  Mapper._();

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
      throw Exception('Mapping model for <$TSrc> to <$TDst> not found.');
    });

    final mapModel = rawMapModel as MapModel<TSrc, TDst>;

    final convertResult = mapModel.convert(sourceObject);

    return convertResult;
  }
}

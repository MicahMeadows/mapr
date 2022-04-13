import 'map_model.dart';
import 'mapping_exception.dart';

/// Object mapping service
class Mapper {
  static final Mapper _mapper = Mapper();

  static Mapper get I {
    return _mapper;
  }

  final List<MapModel> _maps = [];

  /// Register a new map to the service.
  ///
  /// [TSrc] is the object type youre starting with.
  ///
  /// [TDst] is the object type youre requesting.
  ///
  /// [function] is the method to map TSrc to TDst
  ///
  /// Throws a [MapAlreadyExistsException] if you attempt to add a map for a signature that already Exists.
  ///
  /// ```dart
  /// // example address string format -> '278 adams pl'
  /// Mapr().addMap<String, Address>((source) {
  ///   final splitAddress = address.split(' ');
  ///   return Address(
  ///     streetNumber: int.parse(splitAddress[0]),
  ///     streetName: splitAddress.sublist(1).join(' '),
  ///   );
  /// });
  /// ```
  void addMap<TSrc, TDst>(TDst Function(TSrc source) function) {
    if (mapModelExists<TSrc, TDst>()) {
      throw MapAlreadyExistsException(sourceType: TSrc, destinationType: TDst);
    }

    _maps.add(MapModel<TSrc, TDst>(function));
  }

  /// Unregisters a map from the service
  ///
  /// [TSrc] is the source type
  ///
  /// [TDst] is the destination type
  ///
  /// [bothWays] determins if we should unregister both going
  /// from [TSrc] to [TDst] as well as from [TDst] to [TSrc] or not
  void removeMap<TSrc, TDst>({bool bothWays = false}) {
    final mapModelToRemove = getMapModel<TSrc, TDst>();
    _maps.remove(mapModelToRemove);

    if (bothWays) {
      final backwardsMapModelToRemove = getMapModel<TDst, TSrc>();
      _maps.remove(backwardsMapModelToRemove);
    }
  }

  /// Maps an object to a new object
  ///
  /// [TSrc] type of the source object
  ///
  /// [TDst] type of the destination object
  ///
  /// [sourceObject] the actual source object
  ///
  /// Throws a [MapModelNotFoundException] if no map model matching the signation is found.
  ///
  /// Throws a [FailedToMapException] if there was an error whiling converting the object.
  ///
  /// ```dart
  /// final address = Address(streetNum: 278, streetName: 'adams pl');
  /// final result = Mapr().map<Address, String>(address);
  /// // assuming that MapModel is setup for Address -> String
  /// result == '278 adams pl';
  /// ```
  TDst map<TSrc, TDst>(TSrc sourceObject) {
    final mapModel = getMapModel<TSrc, TDst>();
    if (mapModel == null) {
      throw MapModelNotFoundException(destinationType: TDst, sourceType: TSrc);
    }

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

  MapModel<TSrc, TDst>? getMapModel<TSrc, TDst>() {
    try {
      return _maps.firstWhere((element) =>
              element.sourceType == TSrc && element.destinationType == TDst)
          as MapModel<TSrc, TDst>;
    } catch (e) {
      return null;
    }
  }

  bool mapModelExists<TSrc, TDst>() {
    final existingMapModel = getMapModel<TSrc, TDst>();

    final mapModelExists = existingMapModel != null;

    return mapModelExists;
  }
}

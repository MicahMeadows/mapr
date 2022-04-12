class MapModel<TSrc, TDst> {
  final TDst Function(TSrc source) convert;
  late final Type destinationType;
  late final Type sourceType;

  MapModel(this.convert) {
    destinationType = TDst;
    sourceType = TSrc;
  }
}

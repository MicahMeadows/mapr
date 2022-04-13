class MapException implements Exception {
  final Type? sourceType;
  final Type? destinationType;
  final String? message;

  const MapException({
    this.sourceType,
    this.destinationType,
    this.message,
  });
}

class MapModelNotFoundException extends MapException {
  MapModelNotFoundException({
    required Type sourceType,
    required Type destinationType,
    String? message,
  }) : super(
          destinationType: destinationType,
          message:
              'No map model found for $sourceType -> $destinationType: $message',
          sourceType: sourceType,
        );
}

class FailedToMapException extends MapException {
  FailedToMapException({
    required Type sourceType,
    required Type destinationType,
    String? message,
  }) : super(
          destinationType: destinationType,
          sourceType: sourceType,
          message:
              'Failed to map Type<$sourceType> to Type<$destinationType>: $message',
        );
}

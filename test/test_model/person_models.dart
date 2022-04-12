import 'package:equatable/equatable.dart';

class DtoPerson extends Equatable {
  final String name;
  final String age;
  final String email;
  final String streetNumber;
  final String streetName;

  const DtoPerson({
    required this.name,
    required this.age,
    required this.email,
    required this.streetName,
    required this.streetNumber,
  });

  @override
  List<Object?> get props => [
        name,
        age,
        email,
        streetName,
        streetNumber,
      ];
}

class Person extends Equatable {
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final Address address;

  const Person({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.address,
  });

  @override
  List<Object?> get props => [firstName, lastName, age, email, address];
}

class Address extends Equatable {
  final int streetNumber;
  final String streetName;

  const Address({
    required this.streetName,
    required this.streetNumber,
  });

  @override
  List<Object?> get props => [
        streetName,
        streetNumber,
      ];
}

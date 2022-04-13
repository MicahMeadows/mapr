import 'package:flutter_test/flutter_test.dart';

import 'package:mapr/mapr.dart';

import 'test_model/person_models.dart';

void main() {
  group('Given I want to convert types', () {
    group('When I want to convert PersonDto and Person', () {
      const dtoPerson = DtoPerson(
        name: 'bob isaacs',
        age: '12',
        email: 'bob@gmail.com',
        streetName: 'lauren ln',
        streetNumber: '123',
      );

      const person = Person(
        address: Address(
          streetName: 'lauren ln',
          streetNumber: 123,
        ),
        age: 12,
        email: 'bob@gmail.com',
        firstName: 'bob',
        lastName: 'isaacs',
      );

      void createMaps() {
        Mapr().addMap<DtoPerson, Person>((source) {
          final splitName = source.name.split(' ');
          final firstName = splitName[0];
          final lastName = splitName[1];

          final streetNum = int.parse(source.streetNumber);

          return Person(
            firstName: firstName,
            lastName: lastName,
            age: int.parse(source.age),
            email: source.email,
            address: Address(
              streetName: source.streetName,
              streetNumber: streetNum,
            ),
          );
        });

        Mapr().addMap<Person, DtoPerson>((source) {
          final name = '${source.firstName} ${source.lastName}';
          return DtoPerson(
            name: name,
            age: source.age.toString(),
            email: source.email,
            streetName: source.address.streetName,
            streetNumber: source.address.streetNumber.toString(),
          );
        });
      }

      test('Then a valid DtoPerson will become a valid Person', () {
        createMaps();

        var result = Mapr().map<DtoPerson, Person>(dtoPerson);

        expect(person, result);
      });

      test('Then a valid Person will become a valid DtoPerson', () {
        createMaps();

        var result = Mapr().map<Person, DtoPerson>(person);

        expect(dtoPerson, result);
      });

      test('Then a valid Person to a DtoPerson and back remains the same.', () {
        createMaps();

        var step1Result = Mapr().map<Person, DtoPerson>(person);
        var step2Result = Mapr().map<DtoPerson, Person>(step1Result);
        expect(person, step2Result);
      });

      test('Then a valid DtoPerson to a Person and back remains the same.', () {
        createMaps();

        var step1Result = Mapr().map<DtoPerson, Person>(dtoPerson);
        var step2Result = Mapr().map<Person, DtoPerson>(step1Result);
        expect(dtoPerson, step2Result);
      });
    });
    group('When I want to convert a String int with int', () {
      void createMaps() {
        Mapr().addMap<String, int>((src) => int.parse(src));
        Mapr().addMap<int, String>((src) => src.toString());
      }

      test('Then no map setup will throw MapModelNotFoundException', () {
        final method = Mapr().map<String, int>;
        expect(
          () => method("123"),
          throwsA(isA<MapModelNotFoundException>()),
        );
      });

      test('Then a valid String int returns an int', () {
        createMaps();
        const origional = "12312312";
        final result = Mapr().map<String, int>(origional);
        const expected = 12312312;
        expect(result, expected);
      });

      test('Then an int returns a String int', () {
        createMaps();
        const origional = 123456789;
        final result = Mapr().map<int, String>(origional);
        const expected = "123456789";
        expect(result, expected);
      });

      test('Then an invalid string throws a mapping error', () {
        createMaps();
        const origional = '%@!&(*';
        final function = Mapr().map<String, int>;
        expect(
          () => function(origional),
          throwsA(isA<FailedToMapException>()),
        );
      });
    });
  });
}

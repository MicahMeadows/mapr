import 'package:flutter_test/flutter_test.dart';

import 'package:mapr/mapr.dart';

import 'test_model/person_models.dart';

void main() {
  group('Given I want to convert types', () {
    group('When I want to convert PersonDto and Person', () {
      void createMaps() {
        Mapr().addMap<DtoPerson, Person>((source) {
          final splitName = source.name.split(' ');
          final firstName = splitName[0];
          final lastName = splitName[1];

          final splitAddress = source.streetName.split(' ');
          final streetNum = int.parse(splitAddress[0]);
          final streetName = splitAddress.sublist(1).join();

          return Person(
            firstName: firstName,
            lastName: lastName,
            age: int.parse(source.age),
            email: source.email,
            address: Address(
              streetName: streetName,
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
        const input = DtoPerson(
          name: 'bob isaacs',
          age: '12',
          email: 'bob@gmail.com',
          streetName: 'lauren ln',
          streetNumber: '123',
        );

        var result = Mapr().map<DtoPerson, Person>(input);

        const expected = Person(
          address: Address(streetName: 'lauren ln', streetNumber: 123),
          age: 12,
          email: 'bob@gmail.com',
          firstName: 'bob',
          lastName: 'isaacs',
        );

        expect(expected, result);
      });

      test('Then a valid Person will become a valid DtoPerson', () {
        createMaps();
        const input = Person(
          address: Address(streetName: 'lauren ln', streetNumber: 123),
          age: 12,
          email: 'bob@gmail.com',
          firstName: 'bob',
          lastName: 'isaacs',
        );

        var result = Mapr().map<Person, DtoPerson>(input);

        const expected = DtoPerson(
          name: 'bob isaacs',
          age: '12',
          email: 'bob@gmail.com',
          streetName: 'lauren ln',
          streetNumber: '123',
        );

        expect(expected, result);
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
          throwsA(isA<MappingFailureException>()),
        );
      });
    });
  });
}

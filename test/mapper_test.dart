import 'package:flutter_test/flutter_test.dart';
import 'package:mapr/src/mapr.dart';
import 'package:mapr/src/mapping_exception.dart';

import 'test_model/person_models.dart';

void main() {
  group('Given I want to convert types', () {
    group('When I request the singleton instance.', () {
      test('Then I get the singleton.', () {
        final instance = Mapr.I;
        final instance2 = Mapr.I;

        final bothInstancesSameObject = instance == instance2;

        expect(bothInstancesSameObject, true);
      });
      test(
          'Then I can use previously registered mapping models when I get the service again',
          () {
        final instance1 = Mapr.I;
        instance1.addMap<bool, int>((source) => 1);
        final instance2 = Mapr.I;
        expect(
          () => instance2.addMap<bool, int>((source) => 1),
          throwsA(isA<MapAlreadyExistsException>()),
        );
      });
    });
    group('When I want to remove a map model', () {
      late Mapr mapper;
      setUp(() {
        mapper = Mapr();
        mapper.addMap<int, double>((source) => 22.2);
      });
      tearDown(() {
        mapper.removeMap<int, double>(bothWays: true);
      });
      test(
          'Then if there is no map model registered with signature nothing happens.',
          () {
        mapper.removeMap<bool, double>();
      });
      test('Then a registered map will be removed.', () {
        mapper.removeMap<int, double>();
        expect(mapper.mapModelExists<int, double>(), false);
      });
      test(
          'Then removing with bothWays enabled when other direction doesnt exist is fine.',
          () {
        mapper.removeMap<int, double>(bothWays: true);
      });
    });
    group('When I want to add a map model', () {
      test('Then if the map model already exists an exception is thrown.', () {
        final mapper = Mapr();

        mapper.addMap<String, int>((source) => 123);

        expect(
          () => mapper.addMap<String, int>((source) => 123),
          throwsA(isA<MapAlreadyExistsException>()),
        );
      });
    });
    group('When I want to convert PersonDto and Person', () {
      late Mapr mapper;
      setUp(() {
        mapper = Mapr();
        mapper.addMap<DtoPerson, Person>((source) {
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

        mapper.addMap<Person, DtoPerson>((source) {
          final name = '${source.firstName} ${source.lastName}';
          return DtoPerson(
            name: name,
            age: source.age.toString(),
            email: source.email,
            streetName: source.address.streetName,
            streetNumber: source.address.streetNumber.toString(),
          );
        });
      });

      tearDown(() {
        mapper.removeMap<Person, DtoPerson>(bothWays: true);
      });

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

      test('Then a valid DtoPerson will become a valid Person', () {
        var result = mapper.map<DtoPerson, Person>(dtoPerson);

        expect(person, result);
      });

      test('Then a valid Person will become a valid DtoPerson', () {
        var result = mapper.map<Person, DtoPerson>(person);

        expect(dtoPerson, result);
      });

      test('Then a valid Person to a DtoPerson and back remains the same.', () {
        var step1Result = mapper.map<Person, DtoPerson>(person);
        var step2Result = mapper.map<DtoPerson, Person>(step1Result);
        expect(person, step2Result);
      });

      test('Then a valid DtoPerson to a Person and back remains the same.', () {
        var step1Result = mapper.map<DtoPerson, Person>(dtoPerson);
        var step2Result = mapper.map<Person, DtoPerson>(step1Result);
        expect(dtoPerson, step2Result);
      });
    });
    group('When I want to convert a String int with int', () {
      late Mapr mapper;
      setUp(() {
        mapper = Mapr();
        mapper.addMap<String, int>((src) => int.parse(src));
        mapper.addMap<int, String>((src) => src.toString());
      });

      tearDown(() {
        mapper.removeMap<String, int>(bothWays: true);
      });

      test('Then no map setup will throw MapModelNotFoundException', () {
        final method = mapper.map<int, double>;
        expect(
          () => method(3),
          throwsA(isA<MapModelNotFoundException>()),
        );
      });

      test('Then a valid String int returns an int', () {
        const origional = "12312312";
        final result = mapper.map<String, int>(origional);
        const expected = 12312312;
        expect(result, expected);
      });

      test('Then an int returns a String int', () {
        const origional = 123456789;
        final result = mapper.map<int, String>(origional);
        const expected = "123456789";
        expect(result, expected);
      });

      test('Then an invalid string throws a mapping error', () {
        const origional = '%@!&(*';
        final function = mapper.map<String, int>;
        expect(
          () => function(origional),
          throwsA(isA<FailedToMapException>()),
        );
      });
    });
  });
}

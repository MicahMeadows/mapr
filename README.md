## Mapr
---

This is a helper package for simplifying adding mapping between objects.

## Usage
https://pub.dev/packages/mapr

```yaml
dependencies:
    mapr: ^0.0.1
```


## Example mapping a dto to an object
### Object definitions
```dart
const dtoPerson = DtoPerson(
    name: 'bob isaacs',
    age: '12',
    streetName: 'lauren ln',
    streetNumber: '123',
);

const person = Person(
    address: Address(
        streetName: 'lauren ln',
        streetNumber: 123,
    ),
    age: 12,
    firstName: 'bob',
    lastName: 'isaacs',
);
```

### Setup maps
```dart
Mapr.I.addMap<DtoPerson, Person>((source) {
    final splitName = source.name.split(' ');
    final firstName = splitName[0];
    final lastName = splitName[1];

    final streetNum = int.parse(source.streetNumber);

    return Person(
        firstName: firstName,
        lastName: lastName,
        age: int.parse(source.age),
        address: Address(
            streetName: source.streetName,
            streetNumber: streetNum,
        ),
    );
});

Mapr.I.addMap<Person, DtoPerson>((source) {
    final name = '${source.firstName} ${source.lastName}';
    return DtoPerson(
        name: name,
        age: source.age.toString(),
        streetName: source.address.streetName,
        streetNumber: source.address.streetNumber.toString(),
    );
});
```

### Map objects
```dart
/// Create <DtoPerson> to map
const dtoPerson = DtoPerson(
    name: 'bob isaacs',
    age: '12',
    email: 'bob@gmail.com',
    streetName: 'lauren ln',
    streetNumber: '123',
);

/// Map <DtoPerson> to <Person>
Mapr.I.map<DtoPerson, Person>(dtoPerson);

/// This will create an object <Person> equal to
const person = Person(
    address: Address(
        streetName: 'lauren ln',
        streetNumber: 123,
    ),
    age: 12,
    firstName: 'bob',
    lastName: 'isaacs',
);

/// if both objects are equatable or have equality overriden then
/// person == dtoPerson -> true 
```
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItineraryCollection on Isar {
  IsarCollection<Itinerary> get itinerarys => this.collection();
}

const ItinerarySchema = CollectionSchema(
  name: r'Itinerary',
  id: 4812991064429836529,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _itineraryEstimateSize,
  serialize: _itinerarySerialize,
  deserialize: _itineraryDeserialize,
  deserializeProp: _itineraryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'activities': LinkSchema(
      id: 230441635094059149,
      name: r'activities',
      target: r'Activity',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _itineraryGetId,
  getLinks: _itineraryGetLinks,
  attach: _itineraryAttach,
  version: '3.1.0+1',
);

int _itineraryEstimateSize(
  Itinerary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _itinerarySerialize(
  Itinerary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
}

Itinerary _itineraryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Itinerary(
    date: reader.readDateTime(offsets[0]),
  );
  object.id = id;
  return object;
}

P _itineraryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itineraryGetId(Itinerary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itineraryGetLinks(Itinerary object) {
  return [object.activities];
}

void _itineraryAttach(IsarCollection<dynamic> col, Id id, Itinerary object) {
  object.id = id;
  object.activities
      .attach(col, col.isar.collection<Activity>(), r'activities', id);
}

extension ItineraryQueryWhereSort
    on QueryBuilder<Itinerary, Itinerary, QWhere> {
  QueryBuilder<Itinerary, Itinerary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItineraryQueryWhere
    on QueryBuilder<Itinerary, Itinerary, QWhereClause> {
  QueryBuilder<Itinerary, Itinerary, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ItineraryQueryFilter
    on QueryBuilder<Itinerary, Itinerary, QFilterCondition> {
  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ItineraryQueryObject
    on QueryBuilder<Itinerary, Itinerary, QFilterCondition> {}

extension ItineraryQueryLinks
    on QueryBuilder<Itinerary, Itinerary, QFilterCondition> {
  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition> activities(
      FilterQuery<Activity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'activities');
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', length, true, length, true);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, true, 0, true);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, false, 999999, true);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', 0, true, length, include);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'activities', length, include, 999999, true);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterFilterCondition>
      activitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'activities', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ItineraryQuerySortBy on QueryBuilder<Itinerary, Itinerary, QSortBy> {
  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension ItineraryQuerySortThenBy
    on QueryBuilder<Itinerary, Itinerary, QSortThenBy> {
  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Itinerary, Itinerary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ItineraryQueryWhereDistinct
    on QueryBuilder<Itinerary, Itinerary, QDistinct> {
  QueryBuilder<Itinerary, Itinerary, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension ItineraryQueryProperty
    on QueryBuilder<Itinerary, Itinerary, QQueryProperty> {
  QueryBuilder<Itinerary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Itinerary, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }
}

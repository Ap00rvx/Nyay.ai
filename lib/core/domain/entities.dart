import 'package:equatable/equatable.dart';
import 'case_category.dart';

class ClientCase extends Equatable {
  final String id;
  final String description;
  final double budget;
  final String location; // city/region
  final CaseCategory? predictedCategory;
  final String? assignedLawyerId;
  final List<CaseUpdate> updates;

  const ClientCase({
    required this.id,
    required this.description,
    required this.budget,
    required this.location,
    this.predictedCategory,
    this.assignedLawyerId,
    this.updates = const [],
  });

  ClientCase copyWith({
    String? id,
    String? description,
    double? budget,
    String? location,
    CaseCategory? predictedCategory,
    String? assignedLawyerId,
    List<CaseUpdate>? updates,
  }) => ClientCase(
    id: id ?? this.id,
    description: description ?? this.description,
    budget: budget ?? this.budget,
    location: location ?? this.location,
    predictedCategory: predictedCategory ?? this.predictedCategory,
    assignedLawyerId: assignedLawyerId ?? this.assignedLawyerId,
    updates: updates ?? this.updates,
  );

  @override
  List<Object?> get props => [
    id,
    description,
    budget,
    location,
    predictedCategory,
    assignedLawyerId,
    updates,
  ];
}

class CaseUpdate extends Equatable {
  final DateTime time;
  final String message;
  const CaseUpdate(this.time, this.message);

  @override
  List<Object?> get props => [time, message];
}

class Lawyer extends Equatable {
  final String id;
  final String name;
  final List<CaseCategory> expertise;
  final int years;
  final double fee; // base consult fee or hourly
  final double rating; // 0-5
  final String location;
  final String about;

  const Lawyer({
    required this.id,
    required this.name,
    required this.expertise,
    required this.years,
    required this.fee,
    required this.rating,
    required this.location,
    required this.about,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    expertise,
    years,
    fee,
    rating,
    location,
    about,
  ];
}

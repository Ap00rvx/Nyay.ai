import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/domain/case_category.dart';
import '../../../core/domain/entities.dart';

part 'case_state.dart';

class CaseCubit extends Cubit<CaseState> {
  CaseCubit() : super(const CaseState.initial());

  void updateDescription(String desc) =>
      emit(state.copyWith(description: desc));
  void updateBudget(double budget) => emit(state.copyWith(budget: budget));
  void updateLocation(String location) =>
      emit(state.copyWith(location: location));

  // Mock classifier: very naive keyword-based classifier for demo
  void classify() {
    final text = state.description.toLowerCase();
    CaseCategory category = CaseCategory.civil;
    if (text.contains('theft') ||
        text.contains('fir') ||
        text.contains('assault')) {
      category = CaseCategory.criminal;
    } else if (text.contains('divorce') ||
        text.contains('custody') ||
        text.contains('alimony')) {
      category = CaseCategory.family;
    } else if (text.contains('property') ||
        text.contains('land') ||
        text.contains('tenancy')) {
      category = CaseCategory.property;
    }
    emit(state.copyWith(predicted: category));
  }

  ClientCase toEntity() {
    return ClientCase(
      id: const Uuid().v4(),
      description: state.description,
      budget: state.budget,
      location: state.location,
      predictedCategory: state.predicted,
    );
  }
}

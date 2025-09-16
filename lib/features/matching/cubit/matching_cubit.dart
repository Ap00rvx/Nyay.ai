import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/mock_lawyer_repository.dart';
import '../../../core/domain/entities.dart';

part 'matching_state.dart';

class MatchingCubit extends Cubit<MatchingState> {
  final MockLawyerRepository repo;
  MatchingCubit(this.repo) : super(const MatchingState.initial());

  void rank(ClientCase c) {
    emit(state.copyWith(status: MatchingStatus.loading));
    final ranked = repo.match(c);
    emit(state.copyWith(status: MatchingStatus.success, results: ranked));
  }
}

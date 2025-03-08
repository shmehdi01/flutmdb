// Package imports:
import 'package:bloc/bloc.dart';

part 'toggle_state.dart';

class ToggleViewCubit extends Cubit<ToggleViewState> {
  ToggleViewCubit({bool currentState = false})
      : super(ToggleViewState(showListView: currentState));

  void toggleState() {
    emit(ToggleViewState(showListView: !state.showListView));
  }

  void changeState(bool? state) {
    if (state == null) return;
    emit(ToggleViewState(showListView: state));
  }
}
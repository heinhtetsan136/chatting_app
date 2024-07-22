import 'package:blca_project_app/repo/message.dart';
import 'package:equatable/equatable.dart';

abstract class ChattingState extends Equatable {
  List<Message> message;
  ChattingState(this.message);
  @override
  List<Object?> get props => message;
}

class ChattingInitialState extends ChattingState {
  ChattingInitialState(super.message);
}

class ChattingLoadingState extends ChattingState {
  ChattingLoadingState(super.message);
}

class ChattingSoftLoadingState extends ChattingState {
  ChattingSoftLoadingState(super.message);
}

class ChattingLoadedState extends ChattingState {
  ChattingLoadedState(super.message);
}

class ChattingErrorState extends ChattingState {
  final String error;
  ChattingErrorState(super.message, this.error);
  @override
  List<Object?> get props => [...super.message, error];
}
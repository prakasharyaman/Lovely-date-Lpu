part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  @override
  List<Object> get props => [];
}

class MessagingInitialState extends MessagingState {}

class MessagingLoadingState extends MessagingState {}

class MessagingLoadedState extends MessagingState {
  final Stream<QuerySnapshot> messageStream;

  MessagingLoadedState({required this.messageStream});

  @override
  List<Object> get props => [messageStream];
}

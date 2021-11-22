part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object> get props => [];
}

class MessageInitialState extends MessageState {}

class ChatLoadingState extends MessageState {}

class ChatLoadedState extends MessageState {
  final Stream<QuerySnapshot> chatStream;

  ChatLoadedState({required this.chatStream});

  @override
  List<Object> get props => [chatStream];
}

part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class ChatStreamEvent extends MessageEvent {
  final String currentUserId;

  ChatStreamEvent({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

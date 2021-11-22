part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessagingEvent {
  final Message message;

  SendMessageEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageStreamEvent extends MessagingEvent {
  final String currentUserId, selectedUserId;

  MessageStreamEvent(
      {required this.currentUserId, required this.selectedUserId});

  @override
  List<Object> get props => [currentUserId, selectedUserId];
}

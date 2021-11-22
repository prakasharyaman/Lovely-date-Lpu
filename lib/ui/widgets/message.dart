import 'package:flutter/material.dart';
import 'package:lovely/models/messages.dart';
import 'package:lovely/repositories/messaging.dart';
import 'package:lovely/ui/widgets/photo.dart';

import 'package:timeago/timeago.dart' as timeago;

class MessageWidget extends StatefulWidget {
  final String messageId, currentUserId;

  const MessageWidget({required this.messageId, required this.currentUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();

  Message? _message;

  Future getDetails() async {
    _message = await _messagingRepository.getMessageDetail(
        messageId: widget.messageId);

    return _message;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          _message = snapshot.data as Message?;
          return Column(
            crossAxisAlignment: _message!.senderId == widget.currentUserId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              _message!.text != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        _message!.senderId == widget.currentUserId
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(
                                  timeago.format(
                                    _message!.timestamp!.toDate(),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.7),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _message!.senderId == widget.currentUserId
                                        ? Colors.pink[100]
                                        : Colors.pink[200],
                                borderRadius: _message!.senderId ==
                                        widget.currentUserId
                                    ? BorderRadius.only(
                                        topLeft:
                                            Radius.circular(size.height * 0.02),
                                        topRight:
                                            Radius.circular(size.height * 0.02),
                                        bottomLeft:
                                            Radius.circular(size.height * 0.02),
                                      )
                                    : BorderRadius.only(
                                        topLeft:
                                            Radius.circular(size.height * 0.02),
                                        topRight:
                                            Radius.circular(size.height * 0.02),
                                        bottomRight:
                                            Radius.circular(size.height * 0.02),
                                      ),
                              ),
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Text(
                                _message!.text as String,
                                style: TextStyle(
                                    color: _message!.senderId ==
                                            widget.currentUserId
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                        _message!.senderId == widget.currentUserId
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(timeago
                                    .format(_message!.timestamp!.toDate())),
                              )
                      ],
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        _message!.senderId == widget.currentUserId
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(timeago
                                    .format(_message!.timestamp!.toDate())),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: size.width * 0.7,
                                maxHeight: size.width * 0.8),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.02),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.02),
                                child: PhotoWidget(
                                  photoLink: _message!.photoUrl as String,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _message!.senderId == widget.currentUserId
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: Text(timeago
                                    .format(_message!.timestamp!.toDate())),
                              )
                      ],
                    )
            ],
          );
        }
      },
    );
  }
}

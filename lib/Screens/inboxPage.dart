import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/messagingObjects.dart';
import 'package:bizitme/Screens/conversationPage.dart';
import 'package:bizitme/Views/listWidgets.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  InboxPage({Key key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView.builder(
          itemCount: AppConstants.currentUser.conversations.length,
          itemExtent: MediaQuery.of(context).size.height / 9,
          itemBuilder: (context, index) {
            Conversation currentConversation =
                AppConstants.currentUser.conversations[index];
            return InkResponse(
              child: ConversationListTile(
                conversation: currentConversation,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationPage(
                      conversation: currentConversation,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

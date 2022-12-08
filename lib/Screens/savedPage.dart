import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Screens/viewPostingPage.dart';
import 'package:bizitme/Views/gridWidgets.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  SavedPage({Key key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: AppConstants.currentUser.savedPostings.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 2 / 3),
        itemBuilder: (context, index) {
          Posting currentPosting =
              AppConstants.currentUser.savedPostings[index];
          return Stack(
            children: [
              InkResponse(
                enableFeedback: true,
                child: PostingGridTile(
                  posting: currentPosting,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPostingPage(
                        posting: currentPosting,
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        AppConstants.currentUser
                            .removeSavedPosting(currentPosting)
                            .whenComplete(() {
                          setState(() {});
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

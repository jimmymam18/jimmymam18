import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Views/calendarWidgets.dart';
import 'package:bizitme/Views/listWidgets.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  BookingsPage({Key key}) : super(key: key);

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<DateTime> _bookedDates = [];
  List<DateTime> _allBookedDates = [];
  Posting _selectedPosting;

  List<DateTime> _getSelectedDates() {
    return [];
  }

  void _selectDate(DateTime date) {}

  void _selectedAPosting(Posting posting) {
    _selectedPosting = posting;
    this._bookedDates = posting.getAllBookedDates();
    setState(() {});
  }

  void _clearSelectedPosting() {
    this._bookedDates = _allBookedDates;
    this._selectedPosting = null;
    setState(() {});
  }

  @override
  void initState() {
    this._bookedDates = AppConstants.currentUser.getAllBookedDates();
    this._allBookedDates = AppConstants.currentUser.getAllBookedDates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 35.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Sun'),
                  Text('Mon'),
                  Text('Tue'),
                  Text('Wed'),
                  Text('Thu'),
                  Text('Fri'),
                  Text('Sat'),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.9,
              child: PageView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return CalendarMonthWidget(
                      monthIndex: index,
                      bookedDates: this._bookedDates,
                      selectDate: _selectDate,
                      getSelectedDates: _getSelectedDates,
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Filter by Posting',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MaterialButton(
                      onPressed: _clearSelectedPosting,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.currentUser.myPostings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: InkResponse(
                      onTap: () {
                        _selectedAPosting(
                            AppConstants.currentUser.myPostings[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedPosting ==
                                    AppConstants.currentUser.myPostings[index]
                                ? Colors.yellowAccent
                                : Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: MyPostingListTile(
                          posting: AppConstants.currentUser.myPostings[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

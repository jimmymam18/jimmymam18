import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Models/postingObjects.dart';
import 'package:bizitme/Models/reviewObjects.dart';
import 'package:bizitme/Screens/bookPostingPage.dart';
import 'package:bizitme/Screens/viewProfilePage.dart';
import 'package:bizitme/Views/formWidgets.dart';
import 'package:bizitme/Views/listWidgets.dart';
import 'package:bizitme/Views/textWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoder/geocoder.dart';


class ViewPostingPage extends StatefulWidget {
  static final String routeName = '/viewPostingPageRoute';
  final Posting posting;
  ViewPostingPage({this.posting, Key key}) : super(key: key);

  @override
  _ViewPostingPageState createState() => _ViewPostingPageState();
}

class _ViewPostingPageState extends State<ViewPostingPage> {
  Posting _posting;
  LatLng _centerLatLong = LatLng(47.6062, -122.3321);
  Completer<GoogleMapController> _completer;

  Future<void> _calculateLateAndLng() async {

    _centerLatLong = LatLng(47.6062, -122.3321);


    final query = _posting.getFullAddress();
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");

    setState(() {
      _centerLatLong = LatLng(
          first.coordinates.latitude, first.coordinates.longitude);
    });

  }

  @override
  void initState() {
    this._posting = widget.posting;

    this._posting.getAllImagesFromStorage().whenComplete(() {
      setState(() {});
    });
    this._posting.getHostFromFirestore().whenComplete(() {
      setState(() {});
    });
    _completer = Completer();
    _calculateLateAndLng();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarText(text: 'Posting Information'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              AppConstants.currentUser.addSavedPosting(this._posting);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3 / 2,
              child: PageView.builder(
                  itemCount: _posting.displayImages.length,
                  itemBuilder: (context, index) {
                    MemoryImage currentImage = _posting.displayImages[index];
                    return Image(image: currentImage, fit: BoxFit.fill);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: AutoSizeText(
                              _posting.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ), // TextStyle
                              maxLines: 2,
                            ),
                          ),
                          // Padding(
                          //padding: const EdgeInsets.only(top: 4.0),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.deepOrange,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookPostingPage(
                                    posting: this._posting,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '\$${_posting.price} / night',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0, bottom: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: AutoSizeText(
                            _posting.description,
                            style: TextStyle(),
                            minFontSize: 18.0,
                            maxFontSize: 21.0,
                            maxLines: 5,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 12.5,
                              backgroundColor: Colors.black,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProfilePage(
                                        contact: _posting.host,
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  //backgroundImage: _posting.host.displayImage,
                                  radius:
                                      MediaQuery.of(context).size.width / 13,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                _posting.host.getFullName(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        PostingInfoTile(
                          iconData: Icons.business,
                          category: _posting.type,
                          categoryInfo: '${_posting.getNumGuests()} guests',
                        ),
                        PostingInfoTile(
                            iconData: Icons.local_parking,
                            category: 'Beds',
                            categoryInfo: _posting.getBedroomText()),
                        PostingInfoTile(
                          iconData: Icons.location_city,
                          category: 'Bathrooms',
                          categoryInfo: _posting.getBathroomText(),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 1,
                      children: List.generate(
                        _posting.amenities.length,
                        (index) {
                          String currentAmenity = _posting.amenities[index];
                          return Text(
                            currentAmenity,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    'The Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Text(
                      _posting.getFullAddress(),
                      style: TextStyle(
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          _completer.complete(controller);
                        },
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: _centerLatLong,
                          zoom: 14,
                        ),
                        markers: <Marker>{
                          Marker(
                              markerId: MarkerId('Business Location'),
                              position: _centerLatLong,
                              icon: BitmapDescriptor.defaultMarker),
                        },
                      ),
                    ),
                  ),
                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ReviewForm(
                      posting: this._posting,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                                  'postings/${this._posting.id}/reviews')
                              .snapshots(),
                          builder: (context, snapshots) {
                            switch (snapshots.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                return ListView.builder(
                                  itemCount: snapshots.data.documents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Review currentReview = Review();
                                    currentReview.getReviewInfoFromFirestore(
                                        snapshots.data);
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: ReviewListTile(
                                          review: currentReview,
                                        ));
                                  },
                                );
                            }
                          })),
                  // ListView.builder(itemBuilder: null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostingInfoTile extends StatelessWidget {
  final IconData iconData;
  final String category;
  final String categoryInfo;

  PostingInfoTile({Key key, this.iconData, this.category, this.categoryInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        this.iconData,
        size: 20.0,
      ),
      title: Text(
        category,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      subtitle: Text(
        categoryInfo,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

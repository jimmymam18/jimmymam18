import 'package:bizitme/Models/CategoryModel.dart';
import 'package:bizitme/Models/PostingModel.dart';
import 'package:bizitme/Models/appConstants.dart';
import 'package:bizitme/Screens/global.dart';
import 'package:bizitme/Utils/SHDF.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bizitme/Screens/CategoryDeatails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizitme/Models/custom_progress_dialog.dart';

import 'ListCursorSliderPage.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ProgressDialog _progressDialog = new ProgressDialog();
  List<CategoryModel> categoryList = new List();

  TextEditingController _controller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  Stream _stream = FirebaseFirestore.instance.collection('postings').snapshots();
  String _searchType = "";
  bool _isNameButtonSelected = false;
  bool _isCityButtonSelected = false;
  bool _isTypeButtonSelected = false;
  List<PostingModel> postList = new List();
  final db = FirebaseFirestore.instance;
  String userId = "";


  void _searchByField() {
    if (_searchType.isEmpty) {
      _stream = FirebaseFirestore.instance.collection('postings').snapshots();
    } else {
      String text = _controller.text;
      _stream = FirebaseFirestore.instance
          .collection('postings')
          .where(_searchType, isEqualTo: text)
          .snapshots();
    }

    setState(() {});
  }

  void _pressSearchByButton(String searchType, bool isNameSelected,
      bool isCitySelected, bool isTypeSelected) {
    _searchType = searchType;
    _isNameButtonSelected = isNameSelected;
    _isCityButtonSelected = isCitySelected;
    _isTypeButtonSelected = isTypeSelected;
    setState(() {});
  }

  @override
  void initState() {
    CategoryList();
    allPostList();
    Future.delayed(Duration.zero, ()async{
      userId = await SHDFClass.readSharedPrefString(AppConstants.UserId, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 2,
        leading: Padding(padding: EdgeInsets.only(left: 15,right: 0,bottom: 12,top: 12),
          child: Image.asset('assets/Images/B_logo.png' ),),
        title: Text('Bizit Me',textAlign: TextAlign.start,style: TextStyle(fontSize: 20,fontFamily: "Montserrat_Medium",
            fontWeight: FontWeight.bold),),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.all(10.0),
        //     child: Image.asset('assets/Images/notification.png' ,height: 18,width: 20,),
        //   ),
        // ],
        backgroundColor: Color(0xff4996f3),
      ),

      body:  SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
          children: [

            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child:Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                    // color: Colors.white,
                    elevation: 10,
                    child:TextFormField(
                      onChanged: (value){
                        setState(() {});
                      },
                      controller: searchController,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Search by title',
                        hintStyle: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.w100,fontSize: 14),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 19,right: 8),
                          child: Image.asset('assets/Images/search.png' ,height: 0,width: 0,),
                        ),
                      ),
                      //controller: _controller,
                      //onEditingComplete: _searchByField,
                    ),
                  ),
                ),

                Container(padding: EdgeInsets.only(left: 12, top: 5),
                  width: MediaQuery.of(context).size.width,
                  child: Text('Browse Categories',style: TextStyle(color: Colors.black,
                      fontSize: 16,fontFamily: 'Montserrat_ExtraBold',fontWeight: FontWeight.bold),),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  child: gridViewTaskList(),
                )
              ],
            ),

            searchController.text != ""
           ? Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
              child:  Container(
                  padding: const EdgeInsets.all(1.0),
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    ),

                    child:StreamBuilder<QuerySnapshot>(
                      stream: db.collection('all_post').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var doc = snapshot.data.docs;

                          return new ListView.builder(
                            itemCount: postList.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                           // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int position) {
                              print("title : "+postList[position].categoryName);
                              if (postList[position]
                                  .title

                                  .toLowerCase()
                                  .contains(searchController.text) ) {
                                return  userId != postList[position].userId
                                    ?Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child:  Container(
                                    margin: EdgeInsets.only(left: 3,right: 3),
                                    child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child:  Row(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context).size.width * 0.10,
                                              width: MediaQuery.of(context).size.width * 0.90,
                                              child: Column(
                                                children: [
                                                  Flexible(
                                                    child:
                                                    Container(
                                                      //  width: MediaQuery.of(context).size.width*0.75,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 3),
                                                            child:  Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width * 0.80,
                                                                  child: Text( ('${postList[position].title.toLowerCase()}'),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black,
                                                                        fontFamily: "MontSerrat_Medium"),),
                                                                ),

                                                                // Image.asset('assets/Images/favourite_off.png',height: 28,width: 28,),

                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ) ,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        String title = postList[position].title;
                                        String description = postList[position].description;
                                        String location = postList[position].address;
                                        String amountDay = postList[position].priceDay;
                                        String amountWeek = postList[position].priceWeek;
                                        String amountHour = postList[position].priceHour;
                                        String categoryName = postList[position].categoryName;
                                        String postingDate = postList[position].postingDate;
                                        String latitude = postList[position].latitude;
                                        String longitude = postList[position].longitude;
                                        String latlng = postList[position].latlng;
                                        String addPostUserId = postList[position].userId;
                                        String stripeAccountLink = postList[position].stripeAccountLink;
                                        String deviceToken = postList[position].deviceToken;
                                        String documentIdAdd = postList[position].documentId;
                                        String userId = postList[position].userId;
                                        String subCategories = postList[position].subCategories;
                                        String  receiverDeviceToken = postList[position].deviceToken;
                                        List<String> imageList = postList[position].names;

                                        print(doc[position].id);
                                        String documnetId = doc[position].id;

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) =>
                                                ListCusrsolPage(title: title, description: description,documentId:documnetId,
                                                    location: location, priceDay: amountDay, priceHour: amountHour, priceWeek: amountWeek,categoryName:categoryName, names: imageList,
                                                    postingDate:postingDate,latitude:latitude, longitude:longitude, latlng:latlng ,addPostUserId:addPostUserId,
                                                    stripeAccountLink:stripeAccountLink, deviceToken:deviceToken,receiverDeviceToken:receiverDeviceToken,
                                                    documentIdAdd:documentIdAdd,userId:userId,subCategories:subCategories)));
                                        setState(() {});

                                        //   sendFcmMessage("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                                        //  sendNotf("Bizit-Me", "yOUR POST BOOKED BY SOMEONE");
                                      },
                                    ),
                                  ),):Container();
                              }else{
                                return Container();
                              }

                            },
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    ),
                  )
              ),
          )
                :Container()

          ],
        ),
          ],
        ),
      ),

    );
  }


  GridView gridViewTaskList() {
    return GridView.builder(
      itemCount: categoryList.length,
      padding: EdgeInsets.zero,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: (){
             String title = categoryList[position].name;
             Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryDeatails(titleName: title,)));
             setState(() {});
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 1.0,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.only(left:8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 /* Image.network(categoryList[position].image,
                    height: 55,
                    width: 53,
                  ),*/
                  CachedNetworkImage(
                    imageUrl: categoryList[position].image,
                    height: 55,
                    width: 53,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                 Container(
                   margin: EdgeInsets.only(top: 5),
                   child: Text(categoryList[position].name,
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         fontSize: 12,
                         color: Colors.black,
                       fontWeight: FontWeight.w700,
                       fontFamily: "Montserrat"),
                   ),
                 )
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> CategoryList() async {
    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }


    Query query = FirebaseFirestore.instance.collection('category');
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);
        CategoryModel categoryModel = new CategoryModel();


        String name = values['category_name'];
        String image = values['category_image'];


        categoryModel.name = name;
        categoryModel.image = image;

        categoryList.add(categoryModel);
      });

      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      print(categoryList.length.toString());
      setState(() {});
    });
  }


  Future<void> allPostList() async {

    if (progressDialog == false) {
      progressDialog = true;
      _progressDialog.showProgressDialog(context,
          textToBeDisplayed: 'loading...', dismissAfter: null);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    print(user.uid);

    Query query = FirebaseFirestore.instance
        .collection('all_post');
    print("query   "+query.toString());
    await query.get().then((querySnapshot) async {
      // categoryList.clear();
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> values = document.data();
        print(values);

        PostingModel posting = PostingModel();

        String address = values['address'];
        String title = values['title'];
        String description = values['description'];
        String categoryName = values['categoryName'];
        String priceDay = values['priceDay'];
        String priceHour = values['priceHour'];
        String priceWeek = values['priceWeek'];
        String postingDate = values['postingDate'];
        String latitude = values['latitude'];
        String longitude = values['longitude'];
        String latlng = values['latlng'];
        String wishList = values['wishList'];
        String bookingStatus = values['bookingStatus'];
        String userId = values['userId'];
        String stripeAccountLink = values['stripeAccountLink'];
        String deviceToken = values['deviceToken'];
        String documentID = values['documentId'];
        String subCategories = values['subCategories'];

        posting.names = List.from(document['imageNames']);
        print("images list "+posting.names.length.toString());

        posting.address = address;
        posting.title = title;
        posting.description = description;
        posting.categoryName = categoryName;
        posting.priceDay = priceDay;
        posting.priceHour = priceHour;
        posting.priceWeek = priceWeek;
        posting.postingDate = postingDate;
        posting.latitude = latitude;
        posting.longitude = longitude;
        posting.latlng = latlng;
        posting.wishList = wishList;
        posting.bookingStatus = bookingStatus;
        posting.userId = userId;
        posting.stripeAccountLink = stripeAccountLink;
        posting.deviceToken = deviceToken;
        posting.documentId = documentID;
        posting.subCategories = subCategories;
        posting.addedFav = false;


        postList.add(posting);

      });
      _progressDialog.dismissProgressDialog(context);
      progressDialog = false;

      // postFirebaseList();
    });

  }


  Widget SearchBar(){
    return Card(

    );
  }


}

// import 'package:fab_circular_menu/fab_circular_menu.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
//
// class UploadPhotosNext extends StatefulWidget {
//   @override
//   _UploadPhotosNextState createState() => _UploadPhotosNextState();
// }
//
// class _UploadPhotosNextState extends State<UploadPhotosNext> {
//
//
//   static const historyLength = 5;
//
//   List<String> _searchHistory = [
//     'fuchsia',
//     'flutter',
//     'widgets',
//     'resocoder',
//   ];
//   List<String> filteredSearchHistory;
//
//   String selectedTerm;
//
//   List<String> filterSearchTerms({
//     @required String filter,
//   }) {
//     if (filter != null && filter.isNotEmpty) {
//       // Reversed because we want the last added items to appear first in the UI
//       return _searchHistory.reversed
//           .where((term) => term.startsWith(filter))
//           .toList();
//     } else {
//       return _searchHistory.reversed.toList();
//     }
//   }
//
//   void addSearchTerm(String term) {
//     if (_searchHistory.contains(term)) {
//       // This method will be implemented soon
//       putSearchTermFirst(term);
//       return;
//     }
//     _searchHistory.add(term);
//     if (_searchHistory.length > historyLength) {
//       _searchHistory.removeRange(0, _searchHistory.length - historyLength);
//     }
//     // Changes in _searchHistory mean that we have to update the filteredSearchHistory
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }
//
//   void deleteSearchTerm(String term) {
//     _searchHistory.removeWhere((t) => t == term);
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }
//
//   void putSearchTermFirst(String term) {
//     deleteSearchTerm(term);
//     addSearchTerm(term);
//   }
//
//   //FloatingSearchBarController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = FloatingSearchBarController();
//     filteredSearchHistory = filterSearchTerms(filter: null);
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   // Widget cardaction(){
//   //   return  Card(
//   //     color: Colors.white,
//   //     elevation: 10.0,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(10.0),
//   //     ),
//   //     child:
//   //     Container(
//   //       height: 300,
//   //       width: 320,
//   //       child: Column(
//   //         children: [
//   //
//   //           ListTile(
//   //             leading: Text("2020 Fort Hunter",style: TextStyle(fontFamily: "Montserrat"),),
//   //             trailing: Icon(Icons.arrow_forward,color: Colors.black,size: 18,),
//   //           ),
//   //           Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Divider(
//   //             height: 0.5,
//   //             thickness: 0.5,
//   //             color: Colors.grey,
//   //           ),),
//   //           ListTile(
//   //             leading: Text("2020 Fort Hunter",style: TextStyle(fontFamily: "Montserrat"),),
//   //             trailing: Icon(Icons.arrow_forward,color: Colors.black,size: 18,),
//   //           ),
//   //           Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Divider(
//   //             height: 0.5,
//   //             thickness: 0.5,
//   //             color: Colors.grey,
//   //           ),),
//   //
//   //
//   //         ],
//   //       ),
//   //     ),
//   //
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FloatingSearchBar(
//         controller: controller,
//         body: FloatingSearchBarScrollNotifier(
//           child: SearchResultsListView(
//             searchItem: null,
//           ),
//         ),
//
//         transition: CircularFloatingSearchBarTransition(),
// // Bouncing physics for the search history
//         physics: BouncingScrollPhysics(),
// // Title is displayed on an unopened (inactive) search bar
//         title: Text(
//           selectedTerm ?? 'The Search App',
//           style: Theme.of(context).textTheme.headline6,
//         ),
// // Hint gets displayed once the search bar is tapped and opened
//         hint: 'Search and find out...',
//
//         actions: [
//           FloatingSearchBarAction.searchToClear(),
//         ],
//         onQueryChanged: (query) {
//           setState(() {
//             filteredSearchHistory = filterSearchTerms(filter: query);
//           });
//         },
//
//         onSubmitted: (query) {
//           setState(() {
//             addSearchTerm(query);
//             selectedTerm = query;
//           });
//           controller.close();
//         },
//         builder: (context, transition) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Material(
//               color: Colors.white,
//               elevation: 4,
//               child: Builder(
//                 builder: (context) {
//                   if (filteredSearchHistory.isEmpty &&
//                       controller.query.isEmpty) {
//                     return Container(
//                     height: 56,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     child: Text(
//                     'Start searching',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.caption,
//                     ),
//                     );
//                     }
//                   else if (filteredSearchHistory.isEmpty) {
//                     return ListTile(
//                       title: Text(controller.query),
//                       leading: const Icon(Icons.search),
//                       onTap: () {
//                         setState(() {
//                           addSearchTerm(controller.query);
//                           selectedTerm = controller.query;
//                         });
//                         controller.close();
//                       },
//                     );
//                   }else {
//           return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: filteredSearchHistory
//               .map(
//           (term) => ListTile(
//           title: Text(
//           term,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           ),
//           leading: const Icon(Icons.history),
//           trailing: IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//           setState(() {
//           deleteSearchTerm(term);
//           });
//           },
//           ),
//           onTap: () {
//           setState(() {
//           putSearchTermFirst(term);
//           selectedTerm = term;
//           });
//           controller.close();
//           },
//           ),
//           )
//               .toList(),
//           );
//           }
//                   }
//                   ),
//             ),
//           );
//
//         },
//
//
//       ),
//     );
//   }
//   }
//
// class SearchResultsListView extends StatelessWidget{
//   final String searchItem;
//
//   const SearchResultsListView({Key key, this.searchItem}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
//
//

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   GoogleMapController _controller;
//   bool isMapCreated = false;
//   static final LatLng myLocation = LatLng(37.42796133580664, -122.085749655962);

//   @override
//   void initState() {
//     super.initState();
//     // getJsonFile("assets/map.json");
//   }

//   final CameraPosition _kGooglePlex = CameraPosition(
//     target: myLocation,
//     zoom: 14.4746,
//   );

//   // Set<Marker> _createMarker() {
//   //   return <Marker>[
//   //     Marker(
//   //         markerId: MarkerId("marker_1"),
//   //         position: myLocation,
//   //         icon: BitmapDescriptor.defaultMarkerWithHue(
//   //           BitmapDescriptor.hueOrange,
//   //         )),
//   //   ].toSet();
//   // }

//   changeMapMode() {
//     getJsonFile("assets/map.json");
//   }

//   Future<String> getJsonFile(String path) async {
//     return await rootBundle.loadString(path);
//   }

//   void setMapStyle(String mapStyle) {
//     _controller.setMapStyle(mapStyle);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isMapCreated) {
//       changeMapMode();
//     }
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 1.0),
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             GoogleMap(
//               mapType: MapType.normal,
//               zoomGesturesEnabled: true,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               // markers: _createMarker(),
//               initialCameraPosition: _kGooglePlex,
//               onMapCreated: (GoogleMapController controller) {
//                 setState(() {
//                   _controller = controller;
//                   isMapCreated = true;
//                   changeMapMode();
//                 });
//               },
//             ),
//             IgnorePointer(
//               child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         text: "google Office\n",
//                         style: Theme.of(context).textTheme.title.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                         children: [
//                           TextSpan(
//                               text: "Shoreline Amphitheatre, Mountain View, CA",
//                               style: Theme.of(context).textTheme.subtitle,
//                               children: []),
//                         ]),
//                   )),
//             )
//           ],
//         ),
//       ),
//       // title: "Locate Us",
//     );
//   }
// }
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/constans/reuse_widget.dart';
import 'package:maps/logics/maps_cubit/maps_states.dart';
import 'package:maps/screens/choose_language.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class MapsCubit extends Cubit<MapsStates> {
  MapsCubit() : super(MapsInitialStates());

  static MapsCubit get(context) => BlocProvider.of(context);

  Position? position;
  CameraPosition? cameraPosition;
  var myMarker = Set<Marker>();

  // to check if gps is enabled and check for permission.
  //*****************************************************************************
  bool? isGpsEnabled;

  Future getPosition(context) async {
    isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    print(isGpsEnabled);
    if (isGpsEnabled == false) {
      AwesomeDialog(context: context, desc: 'open your GPS to get location')
        ..show();
    }
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AwesomeDialog(context: context, desc: 'your access still denied')
          ..show();
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) getPositionStream();
  }

  //*****************************************************************************

  //to get your position on map and your markers for one time.

  // getCurrentLatLang() {
  //   emit(GetCurrentLoadingLatLang());
  //   Geolocator.getCurrentPosition().then((value) {
  //     position = value;
  //     cameraPosition = CameraPosition(
  //         target: LatLng(position!.latitude, position!.longitude), zoom: 12);
  //     myMarker.add(Marker(
  //         markerId: MarkerId('1'),
  //         position: LatLng(position!.latitude, position!.longitude),
  //         infoWindow: InfoWindow(title: 'my location')));
  //     myMarker.add(Marker(markerId: MarkerId('2')));
  //     emit(GetCurrentSuccessLatLang());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(GetCurrentErrorLatLang());
  //   });
  // }

//*****************************************************************************
//get markers
  LatLng? secondMarkLatLng;

  getSecondMarkers(LatLng latLng) {
    secondMarkLatLng = latLng;
    myMarker.remove(Marker(markerId: MarkerId('2')));
    myMarker.add(Marker(
      markerId: MarkerId('2'),
      position: secondMarkLatLng!,
      infoWindow: InfoWindow(
        title: 'second mark',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    emit(GetSecondMarkersSuccess());
  }

  //***************************************************************************
//to get positionStream
  getPositionStream() {
    Geolocator.getPositionStream().listen((Position value) {
      position = value;
      cameraPosition = CameraPosition(
          target: LatLng(position!.latitude, position!.longitude), zoom: 12);
      myMarker.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(position!.latitude, position!.longitude),
        infoWindow: InfoWindow(title: 'my location'),
      ));
      emit(GetPositionStreamSuccess());
    });
  }

//****************************************************************************
//to do polyline
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBspKHdNHtePiX4hitDYY8suaa3syH4Mik";

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;

    emit(AddPolyLineSuccess());
  }

  List<Placemark>? placeMarks;

  getPolyline() async {
    await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(position!.latitude, position!.longitude),
        PointLatLng(secondMarkLatLng!.latitude, secondMarkLatLng!.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);

    polylineCoordinates
        .add(LatLng(position!.latitude, position!.longitude)); //start
    polylineCoordinates.add(
        LatLng(secondMarkLatLng!.latitude, secondMarkLatLng!.longitude)); //end
    if (polylineCoordinates.length > 2) {
      polylineCoordinates.clear();
      polylineCoordinates
          .add(LatLng(position!.latitude, position!.longitude)); //start
      polylineCoordinates
          .add(LatLng(secondMarkLatLng!.latitude, secondMarkLatLng!.longitude));
    }
    addPolyLine();
    placeMarks = await placemarkFromCoordinates(
        secondMarkLatLng!.latitude, secondMarkLatLng!.longitude);
    emit(GetPolyLineSuccess());
  }

//****************************************************************************
//url luncher
  Future<void>? launched;

  String insta = 'https://www.instagram.com/dola_mohsen/';
  String faceBook = 'https://www.facebook.com/adelmohsen002/';
  String linkedIn = 'https://www.linkedin.com/in/adel-mohsen/';

  Future<void> launchUniversalLinkForInsta() async {
    if (await canLaunch(insta)) {
      final bool nativeAppLaunchSucceeded = await launch(
        insta,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          insta,
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> launchUniversalLinkForFacebook() async {
    if (await canLaunch(faceBook)) {
      final bool nativeAppLaunchSucceeded = await launch(
        faceBook,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          faceBook,
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> launchUniversalLinkForLinkedIn() async {
    if (await canLaunch(linkedIn)) {
      final bool nativeAppLaunchSucceeded = await launch(
        linkedIn,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          linkedIn,
          forceSafariVC: true,
        );
      }
    }
  }

//****************************************************************************
//signOut
  signOut(context) {
    FirebaseAuth.instance.signOut();
    navigateAndRemove(context, ChooseLanguage());
  }

//****************************************************************************
//language
  languageFun(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: MaterialButton(
                    height: 50.0,
                    minWidth: double.infinity,
                    onPressed: () {
                      context.setLocale(Locale('ar'));
                    },
                    child: Text('العربيه'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    height: 50.0,
                    minWidth: double.infinity,
                    onPressed: () {
                      context.setLocale(Locale('en'));
                    },
                    child: Text('English'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

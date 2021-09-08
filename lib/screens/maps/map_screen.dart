import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/logics/maps_cubit/maps_cubit.dart';
import 'package:maps/logics/maps_cubit/maps_states.dart';
import 'package:easy_localization/easy_localization.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsCubit()
        ..getPosition(context)
        ..getPositionStream(),
      child: BlocConsumer<MapsCubit, MapsStates>(
        listener: (context, state) {
          if (state is GetSecondMarkersSuccess)
            MapsCubit.get(context).getPolyline();
        },
        builder: (context, state) {
          var cubit = MapsCubit.get(context);
          GoogleMapController? controller;
          return Scaffold(
            drawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250.0,
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/image/drawerHeader.jpeg'),
                          width: double.infinity,
                          height: 250.0,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                child: Image(
                                  image: AssetImage('assets/image/man.jpg'),
                                  height: 100.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              Text(
                                'Adel Mohsen',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '01099293903',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {cubit.languageFun(context);},
                    title: Text('language'.tr()),
                    trailing: Icon(Icons.language),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    onTap: () {
                      cubit.signOut(context);
                    },
                    title: Text('logout'.tr()),
                    trailing: Icon(Icons.logout),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 8.0, bottom: 8.0),
                    child: Text(
                      'contact us'.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.launchUniversalLinkForInsta();
                          },
                          icon: Image.asset('assets/image/instagram.png')),
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.launchUniversalLinkForFacebook();
                          },
                          icon: Image.asset('assets/image/facebook.png')),
                      const SizedBox(
                        width: 10.0,
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.launchUniversalLinkForLinkedIn();
                          },
                          icon: Image.asset('assets/image/linkedin.png')),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text('maps'.tr()),
            ),
            body: cubit.position == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      GoogleMap(
                        polylines: Set<Polyline>.of(cubit.polylines.values),
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: cubit.cameraPosition!,
                        onMapCreated: (googleMapController) =>
                            controller = googleMapController,
                        markers: cubit.myMarker,
                        onTap: (LatLng latLang) =>
                            cubit.getSecondMarkers(latLang),
                      ),
                      if (cubit.placeMarks != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50.0,
                            alignment: Alignment.topLeft,
                            child: Center(
                              child: Text(
                                '${cubit.placeMarks!.last.name}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        )
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller!.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(cubit.position!.latitude,
                            cubit.position!.longitude),
                        zoom: 14)));
              },
              child: Icon(Icons.location_on),
            ),
          );
        },
      ),
    );
  }
}

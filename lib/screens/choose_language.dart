import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maps/constans/reuse_widget.dart';
import 'authentications_screens/login_screen.dart';

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/earth.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                child: Text(
                  'choose language / اختار اللغه',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MaterialButton(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                minWidth: MediaQuery.of(context).size.width / 2,
                height: 50.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  context.setLocale(Locale('ar'));
                  navigateAndRemove(context, LoginScreen());
                },
                child: Text(
                  'العربيه',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MaterialButton(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                minWidth: MediaQuery.of(context).size.width / 2,
                height: 50.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: () {
                  context.setLocale(Locale('en'));
                  navigateAndRemove(context, LoginScreen());
                },
                child: Text(
                  'English',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

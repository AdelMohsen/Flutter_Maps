import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/constans/reuse_widget.dart';
import 'package:maps/logics/auth_cubit/auth_cubit.dart';
import 'package:maps/logics/auth_cubit/auth_states.dart';
import 'package:maps/screens/authentications_screens/login_screen.dart';
import 'package:maps/screens/maps/map_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController pinCodeController = TextEditingController();
  String phoneNumber;

  OtpScreen(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is SubmitOtpSuccessfully)
            navigateAndRemove(context, MapScreen());
          if (state is SubmitOtpError)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.error.toString()}'),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 5),
            ));
        },
        builder: (context, state) {
          var authCubit = AuthCubit.get(context);
          return Scaffold(
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'verify your phone number'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: RichText(
                          text: TextSpan(
                              text: 'enter your 6 digit code numbers sent to'
                                  .tr(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '+02-$phoneNumber',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4))
                              ]),
                        ),
                      ),
                      buildPinCode(context, pinCodeController),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 70.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: MaterialButton(
                            height: 50.0,
                            minWidth: 100.0,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await authCubit
                                    .submitOTP(pinCodeController.text);
                              }
                            },
                            child: Text(
                              'verify'.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0),
                            ),
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                        ),
                      ),
                      Text(
                        "didn't recieve a verification code".tr(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.2),
                      ),
                      reSendVerificationCode(context, authCubit),
                    ],
                  ),
                ),
              ),
            )),
          );
        },
      ),
    );
  }

  buildPinCode(context, TextEditingController pinCodeController) {
    return PinCodeTextField(
      controller: pinCodeController,
      validator: (value) {
        if (value!.isEmpty)
          return 'check your mail!';
        else if (value.length < 6)
          return 'enter right number';
        else
          return null;
      },
      keyboardType: TextInputType.number,
      cursorHeight: 35,
      cursorColor: Colors.black,
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.blue[100],
        selectedFillColor: Colors.white,
        inactiveColor: Colors.grey,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: true,
      onChanged: (String value) {},
    );
  }

  reSendVerificationCode(context, AuthCubit authCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              authCubit.verificationMethod(phoneNumber: phoneNumber);
            },
            child: Text(
              'resend code'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w400,
                  height: 1.2),
            )),
        Text(
          '|',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextButton(
            onPressed: () {
              navigateAndRemove(context, LoginScreen());
            },
            child: Text(
              'change number'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w400,
                  height: 1.2),
            )),
      ],
    );
  }
}

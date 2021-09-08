import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:maps/constans/reuse_widget.dart';
import 'package:maps/logics/auth_cubit/auth_cubit.dart';
import 'package:maps/logics/auth_cubit/auth_states.dart';
import 'package:maps/screens/authentications_screens/otp_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is CodeSentSuccessfully)
            navigateTo(context, OtpScreen(phoneController.text));
          if (state is OnVerificationFailed)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.error.toString()}'),
              duration: Duration(seconds: 7),
              backgroundColor: Colors.black,
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
                            'your phone number?'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Text(
                          'please enter your phone number to verify your account.'.tr(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1.2),
                        ),
                      ),
                      buildPhoneFormField(
                        phoneController,
                      ),
                      Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              state is! VerificationLoadingState,
                          widgetBuilder: (context) => Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    height: 50.0,
                                    minWidth: 100.0,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        authCubit.verificationMethod(
                                            phoneNumber: phoneController.text);
                                      }
                                    },
                                    child: Text(
                                      'next'.tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0),
                                    ),
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                  ),
                                ),
                              ),
                          fallbackBuilder: (context) {
                            SizedBox(
                              height: 50.0,
                            );
                            return Center(child: CircularProgressIndicator());
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildPhoneFormField(
    TextEditingController phoneController,
  ) {
    return Container(
      height: 50.0,
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 20.0),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Center(
                      child: Text(
                    "${buildCountryIcon()}${'  +02'}",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  controller: phoneController,
                  autofocus: true,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'phone must not be empty';
                    else if (value.length < 11)
                      return 'phone number is too short';
                    else if (value.startsWith('0' + '[1-9]'))
                      return 'number must start with 0';
                    else
                      return null;
                  },
                ))
          ],
        ),
      ),
    );
  }

  String buildCountryIcon() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }
}

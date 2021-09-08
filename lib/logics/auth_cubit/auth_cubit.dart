import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/constans/reuse_widget.dart';
import 'package:maps/constans/strings.dart';
import 'package:maps/logics/auth_cubit/auth_states.dart';
import 'package:maps/screens/authentications_screens/login_screen.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(MainInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> verificationMethod({required String phoneNumber}) async {
    emit(VerificationLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 15),
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  verificationCompleted(PhoneAuthCredential credential) async {
    emit(VerificationLoadingState());
    await FirebaseAuth.instance.signInWithCredential(credential);
    emit(OnVerificationCompleted());
  }

  verificationFailed(FirebaseAuthException e) async {
    emit(VerificationLoadingState());
    print(e.toString());
    emit(OnVerificationFailed(e.toString()));
  }

  codeSent(String verificationId, int? resendToken) async {
    sendId = verificationId;
    print('verificationId : $verificationId');
    print('this.verificationId : $sendId');
    emit(CodeSentSuccessfully());
  }

  Future<void> submitOTP(String otpCode) async {
    emit(VerificationLoadingState());
    print('sendId : $sendId');
    print('otpCode : $otpCode');

    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: sendId, smsCode: otpCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(SubmitOtpSuccessfully());
    } catch (error) {
      print(error.toString());
      emit(SubmitOtpError(error.toString()));
    }
  }

  codeAutoRetrievalTimeout(String verificationId) {
    sendId = verificationId;
    emit(CodeAutoRetrievalTimeout());
  }

  logOut(context) {
    FirebaseAuth.instance.signOut();
    navigateAndRemove(context,LoginScreen());
    emit(SignOutSuccessfully());
  }
}

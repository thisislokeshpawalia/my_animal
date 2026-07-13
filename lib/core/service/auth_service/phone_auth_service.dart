import 'package:firebase_auth/firebase_auth.dart';


class PhoneAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {


    await _auth.verifyPhoneNumber(

      phoneNumber: phoneNumber,


      verificationCompleted:
          (PhoneAuthCredential credential) async {

        await _auth.signInWithCredential(
          credential,
        );

      },


      verificationFailed:
          (FirebaseAuthException e) {

        onError(
          e.message ?? "OTP failed",
        );

      },


      codeSent:
          (String verificationId, int? resendToken) {

        onCodeSent(
          verificationId,
        );

      },


      codeAutoRetrievalTimeout:
          (String verificationId) {},

    );

  }



  Future<User?> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {


    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );


    UserCredential result =
    await _auth.signInWithCredential(
      credential,
    );


    return result.user;

  }

}
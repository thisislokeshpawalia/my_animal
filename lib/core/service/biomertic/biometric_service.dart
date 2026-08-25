import "package:flutter/foundation.dart";
import 'package:local_auth/local_auth.dart';


class BiometricService {


  final LocalAuthentication auth =
  LocalAuthentication();



  Future<bool> authenticate() async {

    try {


      // Check device support

      final isSupported =
      await auth.isDeviceSupported();


      final canCheck =
      await auth.canCheckBiometrics;



      if(!isSupported || !canCheck){

        debugPrint("Biometric not supported");

        return false;

      }



      // Check available biometrics

      final biometrics =
      await auth.getAvailableBiometrics();



      debugPrint(
        "Available biometrics: $biometrics",
      );



      if(biometrics.isEmpty){

        debugPrint(
          "No fingerprint/face registered",
        );

        return false;

      }



      final result =
      await auth.authenticate(

        localizedReason:
        "Verify your identity to enable biometric login",


        options:
        const AuthenticationOptions(

          biometricOnly: true,

          stickyAuth: true,

        ),

      );



      debugPrint(
        "Authentication result: $result",
      );


      return result;


    }

    catch(e){

      debugPrint(
        "Biometric error: $e",
      );


      return false;

    }


  }


}
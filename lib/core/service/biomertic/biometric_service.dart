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

        print("Biometric not supported");

        return false;

      }



      // Check available biometrics

      final biometrics =
      await auth.getAvailableBiometrics();



      print(
        "Available biometrics: $biometrics",
      );



      if(biometrics.isEmpty){

        print(
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



      print(
        "Authentication result: $result",
      );


      return result;


    }

    catch(e){

      print(
        "Biometric error: $e",
      );


      return false;

    }


  }


}
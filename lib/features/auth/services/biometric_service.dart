import 'package:local_auth/local_auth.dart';

class BiometricService {

  final LocalAuthentication auth = LocalAuthentication();


  Future<bool> authenticate() async {

    try {

      bool supported =
      await auth.isDeviceSupported();

      bool canCheck =
      await auth.canCheckBiometrics;


      if (!supported || !canCheck) {
        return false;
      }


      return await auth.authenticate(
        localizedReason:
        "Authenticate to login",

        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );


    } catch (e) {

      return false;

    }
  }
}
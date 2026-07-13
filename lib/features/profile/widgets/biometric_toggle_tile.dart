import 'package:flutter/material.dart';

import '../../../core/service/biomertic/biometric_preference_service.dart';
import '../../../core/service/biomertic/biometric_service.dart';


class BiometricToggleTile extends StatefulWidget {

  const BiometricToggleTile({
    super.key,
  });


  @override
  State<BiometricToggleTile> createState() =>
      _BiometricToggleTileState();

}



class _BiometricToggleTileState
    extends State<BiometricToggleTile> {


  bool enabled = false;

  bool loading = true;



  final BiometricService biometricService =
  BiometricService();



  final BiometricPreferenceService preferenceService =
  BiometricPreferenceService();



  @override
  void initState() {

    super.initState();

    loadStatus();

  }



  Future<void> loadStatus() async {

    final status =
    await preferenceService.isEnabled();


    if(mounted){

      setState(() {

        enabled = status;

        loading = false;

      });

    }

  }



  Future<void> toggleBiometric(bool value) async {


    if(value){


      // Ask fingerprint / face authentication

      final success =
      await biometricService.authenticate();



      if(success){


        await preferenceService
            .setEnabled(true);



        if(mounted){

          setState(() {

            enabled = true;

          });

        }



        if(mounted){

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(
              content: Text(
                "Biometric login enabled",
              ),
            ),

          );

        }



      }
      else{


        if(mounted){

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(
              content: Text(
                "Biometric authentication failed",
              ),
            ),

          );

        }


      }


    }

    else{


      await preferenceService
          .setEnabled(false);



      if(mounted){

        setState(() {

          enabled = false;

        });

      }


      if(mounted){

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Biometric login disabled",
            ),
          ),

        );

      }

    }


  }




  @override
  Widget build(BuildContext context) {


    if(loading){

      return const ListTile(

        title: Text(
          "Biometric Login",
        ),

        trailing:
        SizedBox(

          width:20,

          height:20,

          child:
          CircularProgressIndicator(
            strokeWidth:2,
          ),

        ),

      );

    }



    return SwitchListTile(

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal:16,
      ),



      title: const Text(

        "Biometric Login",

        style: TextStyle(

          fontWeight:
          FontWeight.w600,

        ),

      ),



      subtitle: const Text(

        "Use Face ID or Fingerprint to login",

      ),



      secondary: Icon(

        enabled

            ? Icons.fingerprint

            : Icons.fingerprint_outlined,


        size:28,

      ),



      value: enabled,



      onChanged: toggleBiometric,


    );

  }

}
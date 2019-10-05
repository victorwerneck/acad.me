import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatefulWidget {
  final String nomeButton;
  final VoidCallback testeqrcode;

  CustomButton({@required this.nomeButton, this.testeqrcode});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  String result = "Olá";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        
        setState(() {
          result = "Camera permission was denied";
        });
      }
      else{
        setState(() {
          result = "Error";
        });
      }
    } on FormatException{
      setState(() {
          result = "Fez porra nenhuma nessa merda! Burrão";
        });
    } catch(ex){
      setState(() {
          result = "Erro desconhecido";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: MaterialButton(
          child: Text(
            widget.nomeButton,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          minWidth: double.infinity,
          height: 42,
          color: Color(0xff22CDB4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          onPressed: _scanQR),
    );
  }
}

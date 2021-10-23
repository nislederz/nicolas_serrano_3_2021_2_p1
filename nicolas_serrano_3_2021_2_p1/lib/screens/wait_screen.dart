import 'package:flutter/material.dart';
import 'package:nicolas_serrano_3_2021_2_p1/components/loader_component.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderComponent(text: 'Por favor espere...',),
    );
  }
}
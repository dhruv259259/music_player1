import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'first_page.dart';

void main()
{
  runApp(GetMaterialApp(home:first(),debugShowCheckedModeBanner: false,));
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

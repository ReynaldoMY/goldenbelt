import 'package:flutter/material.dart';

class gbLoginController {

  late BuildContext context;

  TextEditingController usrController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

  Future? init(BuildContext context)  async {
    this.context = context;
  }

  void login() async
  {
    String usr = usrController.text.trim();
    String pwd = pwdController.text.trim();
  }
}


import 'package:flutter/material.dart';
import 'package:uber_admin_panel/methods/common_methods.dart';
import 'package:uber_admin_panel/widgets/users_data_list.dart';

class UserPage extends StatefulWidget {
  static const String id = "\webPageUsers";
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  CommonMethods commonMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Kullanıcı Yönetimi",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //commonMethods.header(2, "USERS ID"),
                  commonMethods.header(1, "AD SOYAD"),
                  commonMethods.header(1, "E-POSTA"),
                  commonMethods.header(1, "TELEFON"),
                  commonMethods.header(1, "İŞLEMLER"),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              UsersDataList()
            ],
          ),
        ),
      ),
    );
  }
}

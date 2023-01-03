import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learncoding/ui/widgets/header.dart';
import 'package:learncoding/utils/color.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  Widget _container(IconData leading, String title, IconData trailing) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              blurRadius: 10,
              offset: Offset(1, 1),
              color: Color.fromARGB(54, 104, 104, 104))
        ],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          highlightColor: Color.fromARGB(132, 135, 208, 245),
          splashColor: Color.fromARGB(61, 231, 231, 231),
          borderRadius: BorderRadius.circular(radius),
          child: ListTile(
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.circular(radius)),
              child: Icon(
                leading,
                color: maincolor,
                size: 18,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              trailing,
              color: Colors.grey,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Header(title: "Settings"),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Column(
                children: [
                  _container(
                    Icons.cleaning_services,
                    'Clear data',
                    Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _container(
                    FontAwesomeIcons.ad,
                    'ad',
                    Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _container(
                    FontAwesomeIcons.coins,
                    'How do you earn coin',
                    Icons.arrow_forward_ios,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _container(
                    Icons.logout,
                    'Logout',
                    Icons.arrow_forward_ios,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

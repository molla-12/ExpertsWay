import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learncoding/models/course.dart';
import 'package:learncoding/services/api_controller.dart';
import 'package:learncoding/theme/box_icons_icons.dart';
import 'package:learncoding/ui/widgets/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:learncoding/ui/widgets/course_card.dart';
import 'package:learncoding/utils/color.dart';
import 'package:learncoding/utils/constants.dart';
import '../../db/course_database.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
    required this.controller,
    required this.expanded,
    required this.onMenuTap,
  }) : super(key: key);

  final TextEditingController controller;
  final bool expanded;
  final onMenuTap;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int tab = 0;
  late List<Section> section = [];
  late List<CourseElement> course = [];
  bool isLoading = false;

  @override
  void dispose() {
    CourseDatabase.instance.close();

    super.dispose();
  }

  @override
  void initState() {
    refreshCourse();
    super.initState();
  }

  Future refreshCourse() async {
    setState(() => isLoading = true);

    course = await CourseDatabase.instance.readAllCourse();
    section = await CourseDatabase.instance.readAllSection();
    print("....note length Course...." + course.length.toString());
    print("....note length Section...." + section.length.toString());
    for (var i = 0; i < section.length; i++) {
      print(
          ' section id  ${section[i].sec_id} +    course id  ${section[i].course_id} \nSection  ${section[i].section} Level  ${section[i].level} ');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      width: MediaQuery.of(context).size.width,
      height: widget.expanded
          ? MediaQuery.of(context).size.height * 0.35
          : MediaQuery.of(context).size.height * 0.19,
      child: Column(
        //  physics: NeverScrollableScrollPhysics(),
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Hi, Akshay.",
                    style: TextStyle(
                        color: Color(0xFF343434),
                        fontSize: 24,
                        fontFamily: 'Red Hat Display',
                        fontWeight: material.FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: material.CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    onTap: widget.onMenuTap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CupertinoTextField(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: material.Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: Offset(0, 10),
                      color: Color(0x1A636363),
                    ),
                  ]),
              padding: EdgeInsets.all(10),
              style: TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 18,
                  fontFamily: 'Red Hat Display'),
              enableInteractiveSelection: true,
              controller: widget.controller,
              expands: false,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              keyboardType: TextInputType.text,
              suffix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  BoxIcons.bx_search,
                  color: Color(0xFFADADAD),
                ),
              ),
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              placeholder: "Search",
              placeholderStyle: TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 18,
                  fontFamily: 'Red Hat Display'),
            ),
          ),
          widget.expanded
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.165,
                  child: course.isEmpty
                      ? FutureBuilder<Course>(
                          future: ApiProvider().retrieveCourses(),
                          builder: (context, snapshot) {
                            List<Section> sec = [];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: maincolor,
                                  ),
                                );
                              }
                            }
                            if (snapshot.data!.courses.isEmpty) {
                              return const Center(
                                  child: Text(
                                "There is no Course",
                                style: TextStyle(
                                    color: Color.fromARGB(184, 138, 138, 138)),
                              ));
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                "Unabel to get the data",
                                style: TextStyle(
                                    color: Color.fromARGB(184, 138, 138, 138)),
                              ));
                            }
                            if (snapshot.hasData) {
                              for (var i = 0;
                                  i < snapshot.data!.courses.length;
                                  i++) {
                                final courseData = snapshot.data!.courses[i];
                                print(List<dynamic>.from(courseData.sections!
                                    .map((x) => x.toJson())).toList()
                                   );
                                 CourseDatabase.instance.create(courseData, i);
                              }
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              refreshCourse();
                            });
                            return Container();
                          })
                      : buildCard())
              : Container(),
        ],
      ),
    );
  }

  Widget buildCard() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: course.length,
      itemBuilder: (context, index) {
        // return Container();
        return CourseCard(courseElement: course[index], index: index);
      },
    );
  }
}

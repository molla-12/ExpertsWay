import 'package:learncoding/models/lesson.dart';
import 'package:learncoding/theme/box_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:learncoding/theme/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LessonPage extends StatefulWidget {
  final List<LessonElement?> lessonData;
  final String section;
  final String lesson;
  const LessonPage({
    super.key,
    required this.section,
    required this.lesson,
    required this.lessonData,
  });

  @override
  State<LessonPage> createState() => _LessonState();
}

class _LessonState extends State<LessonPage> {
  String? lessonContent(lessonData, lesson, section) {
    for (var element in lessonData) {
      if (element.title == lesson && element.section == section) {
        final String lessonHtml = element.content.join();
        return lessonHtml;
      }
    }
    return null;
  }

  int index(lessonData, lesson, section) {
    int lessonIndex = 0;
    for (var element in lessonData) {
      lessonIndex++;
      if (element.title == lesson && element.section == section) {
        return lessonIndex;
      }
    }
    return lessonIndex;
  }

  int totalLesson(lessonData) {
    int lessonCount = 0;
    for (var element in lessonData) {
      lessonCount++;
    }
    return lessonCount;
  }

  @override
  Widget build(BuildContext context) {
    String? lessonHtml =
        lessonContent(widget.lessonData, widget.lesson, widget.section);
    int lessonIndex = index(widget.lessonData, widget.lesson, widget.section);
    int totalLessonCount = totalLesson(widget.lessonData);
    double progress = lessonIndex / totalLessonCount;
    int remainingHearts = 3;
    return CupertinoPageScaffold(
      backgroundColor: config.Colors().secondColor(1),
      navigationBar: CupertinoNavigationBar(
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
        padding: const EdgeInsetsDirectional.only(
          start: 0,
          end: 20,
        ),
        previousPageTitle: "Back",
        backgroundColor: config.Colors().secondColor(1),
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.black87,
            size: 30,
          ),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                BoxIcons.bxs_heart,
                color: Color.fromARGB(255, 246, 33, 82),
                size: 25,
              ),
              const SizedBox(width: 5),
              Text(
                "$remainingHearts",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.green,
                  value: progress,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 4, 67, 33)),
                  minHeight: 18,
                ),
              ),
            ),
            Html(
              data: lessonHtml,
            ),
          ],
        ),
      ),
    );
  }
}

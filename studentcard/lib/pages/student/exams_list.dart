import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/pages/student/exam_tile.dart';
import 'package:studentcard/models/course.dart';



class ExamList extends StatefulWidget {
  final String uid;
  const ExamList({super.key, required this.uid});

  @override
  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  @override
  Widget build(BuildContext context) {
    final exams = Provider.of<List<ExamData>>(context) ?? [];
    final filteredExams = exams.where((exam) => exam.students.contains(widget.uid) == true).toList();
    return ListView.builder(
        itemCount: filteredExams.length,
        itemBuilder: (context, index) {

          return ExamTile(exam: filteredExams[index]);

        });
  }
}

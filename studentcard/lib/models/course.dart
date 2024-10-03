class Course{
  final String uid;
  final String coursename;

  Course({required this.uid, required this.coursename});
}


class ExamData{
  final String courseuid;
  final String date;
  final String examhours;
  final List<dynamic> students;
  final String time;
  final String venue;

  ExamData({required this.courseuid, required this.date,
            required this.examhours, required this.students,
            required this.time, required this.venue});
}


class AttendanceData{
  final String uid;
  final String week;
  final String date;
  final String time;
  final String courseid;
  final String coursename;
  final String classsection;
  final List<dynamic> students;
  final String currentDate;

  AttendanceData({required this.uid, required this.week,
                  required this.date, required this.time,
                  required this.courseid, required this.coursename,
                  required this.classsection, required this.students,
                  required this.currentDate});


}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/model/student_mode.dart';
import 'package:students_app_provider/provider/student_details_p.dart';
import 'package:students_app_provider/provider/student_list_p.dart';
import 'package:students_app_provider/screens/edit/student_edit.dart';
import 'package:students_app_provider/screens/home/home_list.dart';
import 'package:students_app_provider/screens/widgets/delete_dialogue.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 320,
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentEdit(student: student),
                    ),
                  ).then((_) => Navigator.pop(context));
                },
                label: const Text(
                  'EDIT',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                thickness: 1,
                width: 20,
                indent: 10,
                endIndent: 10,
              ),
              TextButton.icon(
                onPressed: () {
                  _deleteDialog(context);
                },
                label: const Text(
                  'DELETE',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _deleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        onCancel: () {
          Navigator.pop(context);
        },
        onDelete: () {
          Provider.of<StudentDetailProvider>(context, listen: false)
              .deleteStudent(student.id)
              .then((_) {
            // Navigate back to HomeList page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeList()),
              (Route<dynamic> route) => false,
            );
            // Optionally, you can refresh the student list here
            Provider.of<StudentListProvider>(context, listen: false)
                .refreshStudentList();
          });
        },
      ),
    );
  }
}

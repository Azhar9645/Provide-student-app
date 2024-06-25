import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/constant/color.dart';
import 'package:students_app_provider/provider/student_list_p.dart';
import 'package:students_app_provider/screens/add/student_add.dart';
import 'package:students_app_provider/screens/profile/student_profile.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<StudentListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color1,
        title: const Text(
          "STUDENTS LIST",
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoSearchTextField(
              onChanged: (query) {
                homeProvider.filterStudents(query);
              },
              backgroundColor: Colors.cyan.shade100,
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: homeProvider.filteredStudents.isEmpty
            ? const Center(
                child: Text(
                  'No students found',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: homeProvider.filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = homeProvider.filteredStudents[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentProfile(student: student),
                        ),
                      ).then(
                        (value) => homeProvider.refreshStudentList(),
                      ),
                      child: Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(237, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.0, // Adjust the radius to fit the container
                              backgroundImage:
                                  FileImage(File(student.profileimg)),
                              onBackgroundImageError: (_, __) {
                                // Handle image loading error
                                print('Error loading image');
                              },
                            ),
                            title: Text(
                              student.name,
                              style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                            subtitle: Text(
                              student.school,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            trailing: Text(
                              "Age: ${student.age.toString()}",
                              style: GoogleFonts.crimsonPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blueGrey,
                              ),
                            ),
                            minVerticalPadding: 10,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color1,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  StudentAdd()),
          ).then((value) => homeProvider.refreshStudentList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

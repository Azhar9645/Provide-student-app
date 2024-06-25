import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/constant/color.dart';
import 'package:students_app_provider/database/database.dart';
import 'package:students_app_provider/model/student_mode.dart';
import 'package:students_app_provider/provider/edit_student_p.dart';
import 'package:students_app_provider/screens/widgets/textfield_widget.dart';

class StudentEdit extends StatelessWidget {
  final Student student;

  StudentEdit({super.key, required this.student});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final schoolnameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final editStudent = Provider.of<EditStudentProvider>(context);

    nameController.text = student.name;
    ageController.text = student.age.toString();
    schoolnameController.text = student.school;
    phoneController.text = student.phone.toString();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(17, 63, 103, 1),
        title: const Text(
          'STUDENT EDIT',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    kheight2,
                    GestureDetector(
                      onTap: () async {
                        XFile? img = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        editStudent.setImage(img);
                      },
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage: editStudent.profileimg != null
                            ? FileImage(File(editStudent.profileimg!))
                            : FileImage(File(student.profileimg)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextfieldWidget(
                      prefixIcon: const Icon(Icons.person),
                      hint: "Name",
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    kheight,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextfieldWidget(
                            prefixIcon: const Icon(Icons.numbers),
                            hint: "Age",
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              } else if (int.tryParse(value) == null ||
                                  value.length > 2 ||
                                  int.parse(value) == 0) {
                                return 'Please enter a valid age';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextfieldWidget(
                            prefixIcon: const Icon(Icons.school),
                            hint: "School",
                            controller: schoolnameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a school name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    kheight,
                    TextfieldWidget(
                      prefixIcon: const Icon(Icons.phone_android),
                      hint: 'Phone',
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    kheight,
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 15.0,
                        ),
                        backgroundColor: const Color.fromRGBO(34, 101, 151, 1),
                        minimumSize: const Size(250, 50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final name = nameController.text;
                          final age = int.parse(ageController.text);
                          final school = schoolnameController.text;
                          final phone = int.parse(phoneController.text);

                          final updateStudent = Student(
                            id: student.id,
                            name: name,
                            school: school,
                            age: age,
                            phone: phone,
                            profileimg:
                                editStudent.profileimg ?? student.profileimg,
                          );
                          DatabaseHelper datahelp = DatabaseHelper();
                          datahelp.updateStudent(updateStudent).then(
                            (id) {
                              if (id > 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Student updated successfully')),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Failed to update student')),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

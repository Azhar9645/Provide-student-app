import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/constant/color.dart';
import 'package:students_app_provider/database/database.dart';
import 'package:students_app_provider/model/student_mode.dart';
import 'package:students_app_provider/provider/add_student.dart';
import 'package:students_app_provider/screens/home/home_list.dart';
import 'package:students_app_provider/screens/widgets/textfield_widget.dart';

class StudentAdd extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final schoolnameController = TextEditingController();
  final phoneController = TextEditingController();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  StudentAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(17, 63, 103, 1),
        title: const Text(
          'STUDENT FORM',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<AddStudentProvider>(
                builder: (context, addStudent, _) {
                  return Column(
                    children: [
                      kheight2,
                      GestureDetector(
                        onTap: () async {
                          XFile? img = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          context.read<AddStudentProvider>().setImage(img);
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(135, 192, 205, 1),
                          radius: 90,
                          backgroundImage: addStudent.profilePicturePath != null
                              ? FileImage(File(addStudent.profilePicturePath!))
                              : null,
                          child: addStudent.profilePicturePath == null
                              ? const Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.white)
                              : null,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeList(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 15.0,
                                ),
                                backgroundColor:
                                    const Color.fromRGBO(34, 101, 151, 1),
                                minimumSize: const Size(100, 50)),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 15.0,
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(34, 101, 151, 1),
                              minimumSize: const Size(250, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final student = Student(
                                  id: 0,
                                  name: nameController.text,
                                  school: schoolnameController.text,
                                  age: int.parse(ageController.text),
                                  phone: int.parse(phoneController.text),
                                  profileimg:
                                      addStudent.profilePicturePath ?? '',
                                );
                                databaseHelper.insertStudent(student).then(
                                  (id) {
                                    if (id > 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Student added successfully')),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Failed to add student')),
                                      );
                                    }
                                  },
                                );
                                context.read<AddStudentProvider>().clearImage();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

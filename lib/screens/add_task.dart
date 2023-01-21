import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // ignore: non_constant_identifier_names
  late String task, description;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                onChanged: (value) {
                  task = value;
                },
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                onChanged: (value) {
                  description = value;
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (() {
                  addtasktofirebase();
                  //create('Tasks',  task, description);
                }),
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.purpleAccent;
                  }
                  return Colors.purple;
                })),
                child: Text(
                  "Add Task",
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

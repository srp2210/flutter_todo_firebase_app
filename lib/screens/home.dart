import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_todo/screens/add_task.dart';
import 'package:flutter_firebase_crud_todo/screens/description.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? uid;
  @override
  void initState() {
    getuid();

    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              }),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          //imp
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, stSnapshot) {
            if (stSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final stDocs = stSnapshot.data?.docs;
              return ListView.builder(
                  itemCount: stDocs!.length,
                  itemBuilder: (context, index) {
                    var time =
                        (stDocs[index]['timestamp'] as Timestamp).toDate();
                    return InkWell(
                      onTap: () {
                        //data
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Description(
                                      title: stDocs[index]['title'],
                                      description: stDocs[index]['description'],
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Title: ${stDocs[index]['title']}',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Description: ${stDocs[index]['description']}',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Created at: ${DateFormat.yMd().add_jm().format(time)}',
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                                //deleting tasks
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(stDocs[index]['time'])
                                      .delete();
                                },
                                child: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
        //color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const AddTask()),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

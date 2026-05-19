import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:himmah_app/models/course.dart';
import 'package:himmah_app/screens/lectures_page.dart';
import 'package:himmah_app/widgets/main_layout.dart';

class StudentHomePage extends StatelessWidget {
  final String specialty;
  final String year;
  const StudentHomePage({super.key, required this.specialty, required this.year});

  @override
  Widget build(BuildContext context) {
    print('=== StudentHomePage ===');
    print('specialty: [$specialty]');
    print('year: [$year]');

    return MainLayout(
      title: 'المواد الدراسية',
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .where('specialty', isEqualTo: specialty)
            .where('year', isEqualTo: year)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(child: Text('لا توجد مواد. التخصص: [$specialty], السنة: [$year]'));
          }
          final courses = docs.map((d) => Course.fromFirestore(d)).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LecturesPage(course: courses[index]))),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Color(0xFFFF3131)),
                    title: Text(courses[index].name),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

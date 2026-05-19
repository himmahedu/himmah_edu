import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    print('=== signInWithEmail ===');
    print('Email: $email');
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Success: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<UserCredential?> createUserWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    print('=== getUserData ===');
    print('UID: $uid');
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      print('Exists: ${doc.exists}');
      if (doc.exists) {
        print('Data: ${doc.data()}');
        return doc.data() ?? {};
      }
      return {};
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

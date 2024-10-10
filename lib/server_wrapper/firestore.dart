import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreWrapper {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }

  static Future<void> updateDocument(String collection, String document, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).doc(document).update(data);
  }

  static Future<void> deleteDocument(String collection, String document) async {
    await FirebaseFirestore.instance.collection(collection).doc(document).delete();
  }

  static Future<DocumentSnapshot> getDocument(String collection, String document) async {
    return await FirebaseFirestore.instance.collection(collection).doc(document).get();
  }

  static Future<QuerySnapshot> getDocuments(String collection) async {
    return await FirebaseFirestore.instance.collection(collection).get();
  }

  static Future<QuerySnapshot> getDocumentsWhere(String collection, String field, dynamic value) async {
    return await FirebaseFirestore.instance.collection(collection).where(field, isEqualTo: value).get();
  }

  static Future<QuerySnapshot> getDocumentsOrderBy(String collection, String field, {bool descending = false}) async {
    return await FirebaseFirestore.instance.collection(collection).orderBy(field, descending: descending).get();
  }
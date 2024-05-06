import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeafService {
  Future<List<DocumentSnapshot>> getLeafInfo() async {
    try {
      QuerySnapshot leafDocs =
          await FirebaseFirestore.instance.collection('leaf').get();
      return leafDocs.docs;
    } catch (e) {
      print("Error retrieving leaf documents: $e");
      return [];
    }
  }

  Future<String> leafStore(
    String? uid,
    double leafAccuracy,
    String leafName,
    String leafImageBase64,
    double leafArea,
    double latitude,
    double longitude,
    String leafShape,
    String leafImageCalculated,
  ) async {
    String docId = FirebaseFirestore.instance.collection('leaf').doc().id;

    try {
      await FirebaseFirestore.instance.collection('leaf').doc(docId).set({
        'uid': uid,
        'leafAccuracy': leafAccuracy,
        'leafName': leafName,
        'leafImage': leafImageBase64,
        'leafArea': leafArea,
        'latitude': latitude,
        'longitude': longitude,
        'leafShape': leafShape,
        'leafImageCalculated': leafImageCalculated,
      });
      return "Leaf data added successfully with ID: $docId";
    } catch (error) {
      return "Error adding leaf data: $error";
    }
  }

  Future<List<DocumentSnapshot>> getLeafInfoByUid(String? uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leaf')
          .where('uid', isEqualTo: uid)
          .get();

      List<DocumentSnapshot> leafDocs = querySnapshot.docs;

      if (leafDocs.isNotEmpty) {
        return leafDocs;
      } else {
        print("No leaf documents found with uid: $uid");
        return [];
      }
    } catch (e) {
      print("Error retrieving leaf documents by uid: $e");
      return [];
    }
  }
}

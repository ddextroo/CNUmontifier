import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeafService {
  Future<DocumentSnapshot?> getLeafInfo(String uid) async {
    try {
      DocumentSnapshot leafDoc =
          await FirebaseFirestore.instance.collection('leaf').doc(uid).get();
      if (leafDoc.exists) {
        return leafDoc;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> leafStore(String? uid, String leafImageBase64, double leafArea,
      double latitude, double longitude, String leafShape) async {
    CollectionReference users = FirebaseFirestore.instance.collection('leaf');
    return users
        .doc(uid)
        .set({
          'uid': uid,
          'leafImage': leafImageBase64,
          'leafArea': leafArea,
          'latitude': latitude,
          'longitude': longitude,
          'leafShape': leafShape,
        })
        .then((value) => debugPrint("Leaf data added"))
        .catchError((error) => debugPrint("Error adding leaf data: $error"));
  }
}

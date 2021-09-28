import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {

  static Future getFirestoreData(String collection, String document) async {
    // SSONG TODO: 타임아웃, 예외 처리
    var docRef = FirebaseFirestore.instance.collection(collection).doc(document);
    return docRef.get().then((DocumentSnapshot documentSnapshot)  {
      print("documentSnapshot.data(): ${documentSnapshot.data()}");
      return documentSnapshot.data();
    });
  }


}
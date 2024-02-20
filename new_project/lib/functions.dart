import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {
  final _firestore = FirebaseFirestore.instance;
  Future<void> readUsers() async {
    print("===========");
    try {
      await _firestore
          .collection("users")
          .get()
          .then((value) => print("READ"))
          .catchError((error) => print(error));
    } catch (e) {
      print(e);
    }
  }

  Future<void> readUsersCollectionSkipFirst() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .orderBy(FieldPath.documentId)
          .limit(2) // Read 2 documents
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot lastDocument = querySnapshot.docs.last;
        // Get the ID of the last document to use for startAfter
        String lastDocumentId = lastDocument.id;

        QuerySnapshot newQuerySnapshot = await firestore
            .collection('users')
            .orderBy(FieldPath.documentId)
            .startAfter([lastDocumentId]) // Start after the first document
            .get();

        if (newQuerySnapshot.docs.isNotEmpty) {
          // Loop through documents skipping the first
          for (QueryDocumentSnapshot documentSnapshot
              in newQuerySnapshot.docs.skip(1)) {
            String documentId = documentSnapshot.id;
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;

            // Process the data or access specific fields as needed
            print('Document ID: $documentId');
            print('Document Data: $data');
          }
        } else {
          print('No documents found after skipping the first');
        }
      } else {
        print('No documents found in the collection');
      }
    } catch (e) {
      print('Error reading collection: $e');
    }
  }
}

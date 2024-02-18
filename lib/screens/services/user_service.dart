import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leadee/models/user_model.dart';

enum StateRegistration {
  complete, // User is registered
  inProgress, // User is being registered
  notnull, // default value
}

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<UserModel> get user {
    return _auth.authStateChanges().asyncMap(
          (user) => UserModel(
            uid: user!.uid,
            email: user.email!,
          ),
        );
  }

  Future<UserModel> auth(UserModel userModel) async {
    late final UserCredential userCredential;

    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } catch (e) {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      await mailinglist(
        userModel.email,
        stateRegistration: StateRegistration.complete,
      );
    }

    userModel.setUid = userCredential.user!.uid;

    return userModel;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<StateRegistration> mailinglist(
    String email, {
    StateRegistration stateRegistration = StateRegistration.notnull,
  }) async {
    DocumentReference documentReference =
        _firebaseFirestore.collection("mailinglist").doc(email);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (stateRegistration != StateRegistration.notnull) {
      await documentReference.set({"state": stateRegistration.toString()});

      return stateRegistration;
    }

    if (documentSnapshot.exists) {
      String state = documentSnapshot.get("state");

      return StateRegistration.values
          .firstWhere((element) => element.toString() == state);
    }

    await documentReference
        .set({"state": StateRegistration.inProgress.toString()});

    return StateRegistration.inProgress;
  }
}

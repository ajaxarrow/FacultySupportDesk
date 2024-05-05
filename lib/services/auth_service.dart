import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/models/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:facultysupportdesk/firebase_options.dart';


final _firebase = FirebaseAuth.instance;
final CollectionReference users = FirebaseFirestore.instance.collection('users');

class AuthService with DisplayMixin{

  Future<void> signInWithGoogle() async {
    try {
      if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.windows) {

      }
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          clientId: '1031424794749-d7ih8en1unk5q10gnb96ktfl9hsqrt6e.apps.googleusercontent.com'
      ).signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      handleSignIn(userCredential);

    } on FirebaseException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }
  }

  Future<void> signInWithGithub() async {
    try {
      final provider = GithubAuthProvider();
      provider.addScope('repo');
      final result = await FirebaseAuth.instance.signInWithPopup(provider);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(result.credential!);
      handleSignIn(userCredential);
    } on FirebaseException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }
  }

  Future<void> handleSignIn(UserCredential userCredential) async {
    QuerySnapshot querySnapshot = await users.where('id', isEqualTo: userCredential.user?.uid).get();

    if (querySnapshot.docs.isEmpty) {
      await users.add({
        'id': userCredential.user!.uid,
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
      });
    }
  }




}
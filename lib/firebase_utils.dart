import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/my_user.dart';
import 'package:todo/models/task_model.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUserCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var tasksCollection = getTasksCollection(uId);
    DocumentReference<Task> taskDocRef = tasksCollection.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(String task, String uId) {
    return getTasksCollection(uId).doc(task).delete();
  }

  static Future<void> editIsDone(Task task, String uId) {
    return getTasksCollection(uId)
        .doc(task.id)
        .update({'isDone': !task.isDone});
  }

  static Future<void> editTask(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update(task.toFireStore());
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toFireStore(),
        );
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readFromFirestore(String uId) async {
    var querySnapshot = await getUserCollection().doc(uId).get();
    return querySnapshot.data();
  }
}

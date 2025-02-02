import 'package:appwrite/appwrite.dart';
import 'package:household_buddy/models/task.dart';

class TaskService {
  final Databases databases;

  // Provide the database ID and client during initialization
  TaskService(Client client) : databases = Databases(client);

  final String databaseId = '67991d3c00289fa240f1';
  final String collectionId = '679e82fb00220324f4ed';

  Future<String?> createTask(
      String userId, String householdId, Task task) async {
    try {
      return (await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'name': task.name,
            'type': task.type.toString().split('.').last,
            'difficulty': task.difficulty.toString().split('.').last,
            'householdId': householdId
          },
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
            Permission.delete(Role.user(userId))
          ])).$id;
    } catch (e) {
      print('Error creating household: $e');
      return null;
    }
  }

  Future<List<Task>> getTasks(String householdId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('householdId', householdId), // Fetch documents where userId matches
        ],
      );
      return result.documents.map((document) => Task.fromMap(document.$id, document.data)).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> completeTask(String documentId) async {
    try {
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: {
          'dateCompleted': DateTime.now().toIso8601String()
        }
      );
    } catch (e) {
      print('Error completing the task: $e');
    }
  }
}

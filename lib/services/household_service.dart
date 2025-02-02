import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class HouseholdService {
  final Databases databases;

  // Provide the database ID and client during initialization
  HouseholdService(Client client) : databases = Databases(client);

  final String databaseId = '67991d3c00289fa240f1';
  final String collectionId = '67991d61001125bffba4';

  // Create a Household
  Future<void> createHousehold(String userId, String householdName, int buddyId,
      String buddyName) async {
    try {
      await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'userId': userId,
            'householdName': householdName,
            'createdAt': DateTime.now().toIso8601String(),
            'buddyId': buddyId,
            'buddyName': buddyName,
            'gold': 0
          },
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
          ]);
      print('Household created successfully.');
    } catch (e) {
      print('Error creating household: $e');
    }
  }

  // Fetch all households for a user
  Future<List<Document>> getHouseholds(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('userId', userId), // Fetch documents where userId matches
        ],
      );
      return result.documents;
    } catch (e) {
      print('Error fetching households: $e');
      return [];
    }
  }

  Future<bool> hasHousehold(String userId) async {
    var households = await getHouseholds(userId);
    return households.isNotEmpty;
  }

  Future<void> setGold(String householdId, int gold) async {
    await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: householdId,
        data: {'gold': gold});
  }

  // Delete a Household
  Future<void> deleteHousehold(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      print('Household deleted successfully.');
    } catch (e) {
      print('Error deleting household: $e');
    }
  }
}

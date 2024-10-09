import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:internship_frontend/data/services/member_service.dart';
import 'package:internship_frontend/data/services/user_service.dart';

import '../../core/config/app_config.dart';
import '../../core/config/environment.dart';
import '../../core/utils/toast.dart';
import '../models/contribution.dart';
import '../models/group.dart';
import '../models/member.dart';

class GroupService {
  final String baseUrl = AppConfig.groupUrl;
  final MemberService _memberService = MemberService();
  final UserService _userService = UserService();
  // Create a new group
  Future<http.Response?> createGroup(Group group, String token,BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(group.toJson()),
      );
      if (!context.mounted) return null;
      // Check the status code and handle conditions with toast messages
      if (response.statusCode == 201) {
        showSuccessToast(context, "Group created successfully!");
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else {
        showWarningToast(context, "Failed to create the group. Please try again later.");
      }
      return response;
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
      //throw Exception("Failed to create group: $e");
    }
    return null;
  }

  // Update an existing group
  Future<http.Response?> updateGroup(int id,Group group, String token,BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(group.toJson()),
      );
      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, "Group updated successfully!");
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request.");
      } else if (response.statusCode == 403) {
        showErrorToast(context, "You are not authorized to update this group.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "Group not found.");
      } else {
        showErrorToast(context, "An unexpected error occurred. Please try again.");
      }
      return response;
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
      //throw Exception("Failed to update group: $e");
    }
    return null;
  }

  Future<void> deleteGroup(int id, String token, BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: Environment.getJsonHeaders(token),
      );
      if (!context.mounted) return;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 204) {
        showDeleteToast(context, "Group deleted successfully!");
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 403) {
        showErrorToast(context, "You are not authorized to delete this group.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "Group not found. Please check the group ID.");
      } else {
        showWarningToast(context, "Failed to delete the group. Please try again later.");
      }
    } catch (e) {
      // Handle any exceptions and show error toast
      showErrorToast(context, "An error occurred. Please check your connection.");
      //throw Exception("Failed to delete group: $e");
    }
  }
  // -------------------------------- USER IN THE GROUP
  // Function to check if the user is in the group
  Future<bool> isUserInGroup(int groupId, int userId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/membership/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // if (!context.mounted) return false;
      if (response.statusCode == 200) {
        bool isInGroup = jsonDecode(response.body) as bool;
        print(" IS USER IN GROUP : >>>>>>>>>>>>>>> $isInGroup");
        print("+++++++++++++++++++++++++++++++++++++++++++++++");
        return isInGroup;
      } else {
        if (response.statusCode == 404) {
          showWarningToast(context,'Group or User not found');
        } else if (response.statusCode == 400) {
          showErrorToast(context,'Invalid token or bad request');
        } else {
          showWarningToast(context,'Unexpected error: ${response.statusCode}');
        }
      }
    } catch (e) {
      showErrorToast(context,'An error occurred: $e');
    }
    return false;
  }

  // Retrieve all groups
  Future<http.Response> getAllGroups(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Retrieve a single group by ID
  Future<http.Response?> getGroupById(int groupId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "Group not found. Please check the group ID.");
      } else {
        showWarningToast(context, "Failed to retrieve the group . Please try again later.");
      }
    }
    catch(e){
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // Handle inactive members
  Future<http.Response> handleInactiveMembers(
      int groupId, Map<String, dynamic> requestDTO, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-inactive'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(requestDTO),
    );
    return response;
  }

  // Handle active members
  Future<http.Response> handleActiveMembers(
      int groupId, Map<String, dynamic> requestDTO, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/handle-active'),
      headers: Environment.getJsonHeaders(token),
      body: jsonEncode(requestDTO),
    );
    return response;
  }

  // Get members by group
  Future<http.Response?> getMembersByGroup(int groupId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view members of this group.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve members. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  Future<http.Response?> getMemberByUsername(String token, int groupId, int userId, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else if (response.statusCode == 404) {
        showWarningToast(context, "Member not found. Please check the member username.");
      } else {
        showWarningToast(context, "Failed to retrieve the member . Please try again later.");
      }
    }
    catch(e){
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // =============================== CONTRIBUTIONS =======================================
  // Create a new contribution
  Future<http.Response?> createContribution(int groupId,Contribution contribution, String token,BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$groupId/contributions'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(contribution.toJson()),
      );

      if (!context.mounted) return null;
      // Check the status code and handle conditions with toast messages
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Invalid token or bad request. Please try again.");
      } else {
        showWarningToast(context, "Failed to create the contribution. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // Get contributions by group
  Future<http.Response?> getContributionsByGroup(int groupId, String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/contributions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view contributions of this group.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve contributions. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }
  // Get contributions by group and member
  Future<http.Response?> getContributionsByGroupAndMember(int groupId, int memberId,String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members/$memberId/contributions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view contributions of this member.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group or member not found. Please check the IDs.');
      } else {
        showWarningToast(context, 'Failed to retrieve contributions. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Calculate total contributions for a group
  Future<http.Response?> calculateTotalContributions(int groupId, String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/contributions/total'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;

      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        //showSuccessToast(context, 'Total contributions retrieved successfully');
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view the total contributions.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve total contributions. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // =================================== TRANSACTIONS ==========================
  // Get transactions by group
  Future<http.Response?> getAllTransactionsByGroup(int groupId, String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;

      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view transactions of this group.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve transactions. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Get transactions by group and member
  Future<http.Response?> getTransactionsByGroupAndMember(int groupId, int memberId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members/$memberId/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view transactions of this member.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group or member not found. Please check the IDs.');
      } else {
        showWarningToast(context, 'Failed to retrieve transactions. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // =================================== LOANS ==========================
  // Get loans by group
  Future<http.Response?> getLoansByGroup(int groupId,String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/loans'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view loans for this group.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve loans. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Get loans by group and member
  Future<http.Response?> getLoansByGroupAndMember(int groupId, int memberId,String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members/$memberId/loans'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view loans for this member.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group or member not found. Please check the IDs.');
      } else {
        showWarningToast(context, 'Failed to retrieve loan history. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Calculate total loans for a group
  Future<http.Response?> getTotalLoanAmount(int groupId, String token,BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/loans/total'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;
      // Check the status code and show appropriate toast messages
      if (response.statusCode == 200) {
        showSuccessToast(context, 'Success');
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view the total loan amount.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the group ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve total loan amount. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or parsing issues
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }



  // Automate disbursement
  Future<http.Response> automateDisbursement(int groupId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$groupId/automate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  // Function to add a new member before the rotation starts
  Future<http.Response?> addNewMemberBeforeRotation(
      int groupId,Member member, String token, BuildContext context) async {
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('$baseUrl/$groupId/add-new-member/before'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(member.toJson()),
      );

      // Check the response and handle it based on status codes
      if (!context.mounted) return null;
      if (response.statusCode == 201) {
        return response;  // Return the response on successful creation
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Member already exists or bad request.");
      } else if (response.statusCode == 403) {
        showErrorToast(context, "You are not authorized to add this member.");
      } else if (response.statusCode == 404) {
        showErrorToast(context, "Group not found.");
      } else {
        showWarningToast(context, "Failed to add the new member. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  // Function to add a new member after the rotation has started
  Future<http.Response?> addNewMemberAfterRotation(
      int groupId, Member member, String token, BuildContext context) async {
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('$baseUrl/$groupId/add-new-member/after'),
        headers: Environment.getJsonHeaders(token),
        body: jsonEncode(member.toJson()),
      );

      // Check the response and handle it based on status codes
      if (!context.mounted) return null;
      if (response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 400) {
        showErrorToast(context, "Member already exists or bad request.");
      } else if (response.statusCode == 403) {
        showErrorToast(context, "You are not authorized to add this member.");
      } else if (response.statusCode == 404) {
        showErrorToast(context, "Group not found.");
      } else {
        showWarningToast(context, "Failed to add the new member. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }

  Future<List<String>?> getAvailableMonths(int groupId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/available-months'),
        headers: Environment.getJsonHeaders(token),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((month) => month.toString()).toList(); // Convert dynamic to String
      } else {
        showErrorToast(context, "Failed to fetch available months. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      showErrorToast(context, "An error occurred: $e");
      return null;
    }
  }

  // Get members who have received disbursement
  Future<http.Response?> getMembersWhoReceived(int groupId, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members-who-received'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        //showSuccessToast(context, 'Successfully retrieved members who received.');
        return response; // Handle the response as needed
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view these members.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve members. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Get members who have not received disbursement
  Future<http.Response?> getMembersWhoNotReceived(int groupId,String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/members-who-not-received'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        //showSuccessToast(context, 'Successfully retrieved members who have not received.');
        return response; // Handle the response as needed
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view these members.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve members. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

  // Get current recipient of the disbursement
  Future<http.Response?> getCurrentRecipient(int groupId,String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$groupId/current-recipient'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        //showSuccessToast(context, 'Successfully retrieved current recipient.');
        return response; // Handle the response as needed
      } else if (response.statusCode == 400) {
        showErrorToast(context, 'Invalid token. Please log in again.');
      } else if (response.statusCode == 403) {
        showErrorToast(context, 'Unauthorized. You don’t have permission to view the current recipient.');
      } else if (response.statusCode == 404) {
        showWarningToast(context, 'Group not found. Please check the ID.');
      } else {
        showWarningToast(context, 'Failed to retrieve current recipient. Please try again later.');
      }
    } catch (e) {
      showErrorToast(context, 'An error occurred. Please check your connection.');
    }
    return null;
  }

}

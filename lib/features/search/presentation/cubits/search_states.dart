import 'package:connect_if/features/profile/domain/entities/profile_user.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<ProfileUser> users;

  SearchLoaded({required this.users});
}

class SearchError extends SearchStates {
  final String message;

  SearchError(this.message);
}
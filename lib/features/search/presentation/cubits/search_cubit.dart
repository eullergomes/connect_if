import 'package:connect_if/features/search/domain/search_repo.dart';
import 'package:connect_if/features/search/presentation/cubits/search_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchStates>{
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users: users));
    } catch (e) {
      emit(SearchError("Erro ao buscar usuários: $e"));
    }
  }

}
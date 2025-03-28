import 'package:connect_if/features/profile/presentation/components/user_title.dart';
import 'package:connect_if/features/search/presentation/cubits/search_cubit.dart';
import 'package:connect_if/features/search/presentation/cubits/search_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) {
        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return const Center(child: Text("Nenhum usuário encontrado"));
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return UserTitle(user: user);
            },
          );
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Digite algo para buscar..."));
        }
      },
    );
  }
}

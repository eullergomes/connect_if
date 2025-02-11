import 'package:connect_if/features/profile/presentation/components/user_title.dart';
import 'package:connect_if/features/search/presentation/cubits/search_cubit.dart';
import 'package:connect_if/features/search/presentation/cubits/search_states.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Buscar usuários",
            hintStyle: TextStyle(color: AppThemeCustom.black),
          ),
        ),
      ),

      // SearchResult
      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no users
            if (state.users.isEmpty) {
              return const Center(child: Text("Nenhum usuário encontrado"));
            }

            // users...
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTitle(user: user);
              },
            );
          }

          // loading
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          else if (state is SearchError) {
            return Center(child: Text(state.message));
          }

          // default
          return const Center(child: Text("Digite algo para buscar..."));
        }),
    );
  }
}
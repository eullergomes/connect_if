import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final void Function(String query) onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController searchController = TextEditingController();

  void onSearchChanged() {
    widget.onSearchChanged(searchController.text);
    setState(() {}); // atualiza o botão de limpar dinamicamente
  }

  void clearSearch() {
    searchController.clear();
    widget.onSearchChanged('');
    setState(() {});
    FocusScope.of(context).unfocus(); // fecha o teclado também
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
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Buscar usuários...",
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppThemeCustom.green100,
            prefixIcon: Icon(Icons.search, color: AppThemeCustom.black),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: AppThemeCustom.black),
                    onPressed: clearSearch,
                  )
                : null,
          ),
          style: TextStyle(color: AppThemeCustom.black),
          textAlignVertical: TextAlignVertical.center, // Centraliza verticalmente
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:studygram/services/settings_model.dart';
import 'package:studygram/services/user_search_bar_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({super.key});

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  List<dynamic> suggestions = [];
  final SearchController controller = SearchController();
  final int suggestionsLimit = 5;
  final Map textSizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

  @override
  Widget build(BuildContext context) {
    final UserSearchBarModel userSearchBarModel =
        Provider.of<UserSearchBarModel>(context, listen: false);
    return Consumer<UserSearchBarModel>(
      builder: (context, searchBarModel, child) {
        return Consumer<Settings>(
          builder: (context, settings, child) {
            return SearchAnchor(
              searchController: controller,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  hintText: "Search for users...",
                  leading: const Icon(Icons.search),
                  // onTap: () {
                  //   controller.openView();
                  // },
                  onChanged: (input) async {
                    controller.openView();
                    // Updating the suggestions list if the input isn't empty
                    if (input.trim().isNotEmpty) {
                      // Gets the new suggestions
                      List<dynamic> newSuggestions = await userSearchBarModel
                          .search(input.trim().toLowerCase(), suggestionsLimit);
                      // Updates the suggestions list
                      setState(
                        () {
                          suggestions = newSuggestions;
                        },
                      );
                    }
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(
                  suggestions.length,
                  (int index) {
                    String username = suggestions[index];
                    return ListTile(
                      title: Text(
                        username,
                        style: TextStyle(fontSize: textSizes[settings.size]),
                      ),
                      onTap: () {
                        context.go('/profile', extra: username);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

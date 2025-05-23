import 'package:flutter/material.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/models/user_search_bar_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

/// Search bar for the users in the server.
/// When searching, it will give suggestions of usernames
/// with the prefix of the input.
class UserSearchBar extends StatelessWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchController controller = SearchController();
    const int suggestionsLimit = 5;
    final Map textSizes = {
      Size.small: 12.0,
      Size.medium: 14.0,
      Size.large: 16.0
    };
    return Consumer<UserSearchBarModel>(
      builder: (context, searchBarModel, child) {
        List<dynamic> suggestions = searchBarModel.suggestions;
        return Consumer<Settings>(
          builder: (context, settings, child) {
            return SearchAnchor(
              searchController: controller,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  hintText: "Search for users...",
                  leading: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  onChanged: (input) async {
                    controller.openView();
                    // Updating the suggestions list if the input isn't empty
                    if (input.trim().isNotEmpty) {
                      // Gets the new suggestions
                      List<dynamic> newSuggestions = await searchBarModel
                          .search(input.trim().toLowerCase(), suggestionsLimit);
                      // Updates the suggestions list
                      searchBarModel.setSuggestions(newSuggestions);
                    }
                  },
                );
              },
              // Builds a ListTile for every suggestion that will navigate
              // the user to their profile when clicked on
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(
                  suggestions.length,
                  (int index) {
                    String username = suggestions[index];
                    return ListTile(
                      title: Text(
                        username,
                        style: TextStyle(
                            fontSize: textSizes[settings.size],
                            color: Theme.of(context).colorScheme.onSurface),
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

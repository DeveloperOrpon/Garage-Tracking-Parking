import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/adminProvider.dart';
import '../../../../utils/const.dart';

class UserSearchClass extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final filteredList = query.isEmpty
        ? provider.allUserList
        : provider.allUserList
            .where((user) =>
                user.name!.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: movieListGradient[index % 10],
          ),
          child: ListTile(
            onTap: () {
              query = item.uid;
              close(context, query);
            },
            title: Text(item.name!),
            leading: item.profileUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(item.profileUrl!),
                  )
                : TextAvatar(
                    size: 35,
                    backgroundColor: Colors.white,
                    textColor: Colors.white,
                    fontSize: 14,
                    upperCase: true,
                    numberLetters: 1,
                    shape: Shape.Rectangle,
                    text: item.name!,
                  ),
          ),
        );
      },
    );
  }
}

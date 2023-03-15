import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:parking_koi/pages/admin/models/searchModel.dart';
import 'package:provider/provider.dart';

import '../../../provider/adminProvider.dart';
import '../../../provider/mapProvider.dart';
import '../../../utils/const.dart';

class FullSearchDelegate extends SearchDelegate<List<SearchModel>> {
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
        close(context, []);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, []);
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);
    List<SearchModel> allSearchList = [];
    List<SearchModel> userSearchList = List.generate(
        provider.allUserList.length,
        (index) => SearchModel(
            title: provider.allUserList[index].name ??
                provider.allUserList[index].phoneNumber,
            id: provider.allUserList[index].uid,
            imageUrl: provider.allUserList[index].profileUrl,
            type: "userModel"));
    List<SearchModel> parkingSearchList = List.generate(
        mapProvider.parkingList.length,
        (index) => SearchModel(
            title: mapProvider.parkingList[index].title,
            id: mapProvider.parkingList[index].parkId,
            imageUrl: mapProvider.parkingList[index].parkImageList[0],
            type: "parkingModel"));
    List<SearchModel> garageSearchList = List.generate(
        mapProvider.garageList.length,
        (index) => SearchModel(
            title: mapProvider.garageList[index].name,
            id: mapProvider.garageList[index].gId,
            imageUrl: mapProvider.garageList[index].coverImage,
            type: "garageModel"));
    allSearchList.addAll(userSearchList);
    allSearchList.addAll(parkingSearchList);
    allSearchList.addAll(garageSearchList);
    allSearchList.shuffle();

    final filteredList = query.isEmpty
        ? allSearchList
        : allSearchList
            .where((user) =>
                user.title.toLowerCase().contains(query.toLowerCase()))
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
              query = item.title;
              close(context, [item]);
            },
            title: Text(item.title),
            leading: item.imageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      item.imageUrl!,
                    ),
                  )
                : TextAvatar(
                    size: 35,
                    backgroundColor: Colors.white,
                    textColor: Colors.white,
                    fontSize: 14,
                    upperCase: true,
                    numberLetters: 1,
                    shape: Shape.Rectangle,
                    text: item.title,
                  ),
            trailing: Text(item.type == "garageModel"
                ? "Garage"
                : item.type == "userModel"
                    ? "User"
                    : "Parking Post"),
          ),
        );
      },
    );
  }
}

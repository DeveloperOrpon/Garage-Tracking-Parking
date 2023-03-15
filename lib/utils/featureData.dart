class FeatureClass {
  String title;
  String imageUrl;

  FeatureClass({required this.title, required this.imageUrl});
}

List<FeatureClass> featureDemoData = [
  FeatureClass(title: "Parking Map", imageUrl: "asset/image/add-location.png"),
  FeatureClass(title: "Ads In Calendar", imageUrl: "asset/image/calendar.png"),
  FeatureClass(title: "Search", imageUrl: "asset/image/road.png"),
  FeatureClass(title: "All Garages", imageUrl: "asset/image/folder.png"),
  FeatureClass(title: "About Info", imageUrl: "asset/image/about.png"),
];

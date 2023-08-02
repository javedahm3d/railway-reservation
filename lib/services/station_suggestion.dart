class GetStations {
  final List<String> stations = [
    'kochi',
    'manglore',
    'margao',
    'pune',
    'mumbai',
    "ahemdabad",
    'jaipur',
    'delhi'
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(stations);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

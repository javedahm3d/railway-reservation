class GetStations {
  final List<String> stations = [
    'kochi',
    'manglore',
    'margao',
    'pune',
    'mumbai',
    "ahemdabad",
    'jaipur',
    'delhi',
    'vasco',
    'dharwar',
    'banglore',
    'goa',
    'jaipur',
    'belgaum',
    'kota',
    'agra',
    'amritsar',
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(stations);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

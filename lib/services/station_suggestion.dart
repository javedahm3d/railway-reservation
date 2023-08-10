class GetStations {
  final List<String> stations = [
    'kochi',
    'mangalore',
    'margao',
    'pune',
    'mumbai',
    "ahemdabad",
    'jaipur',
    'delhi',
    'vasco',
    'dharwar',
    'bangalore',
    'goa',
    'surat',
    'belgaum',
    'kota',
    'agra',
    'amritsar',
    'haveri'
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(stations);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

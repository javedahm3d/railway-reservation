class Passenger {
  final String name;
  final String seatNo;

  Passenger({required this.name, required this.seatNo});
}

class TicketData {
  final String trainName;
  final String fromStation;
  final String toStation;
  final String transactionId;
  final String trainId;
  final List<Passenger> passengers;

  TicketData({
    required this.trainName,
    required this.fromStation,
    required this.toStation,
    required this.transactionId,
    required this.trainId,
    required this.passengers,
  });
}

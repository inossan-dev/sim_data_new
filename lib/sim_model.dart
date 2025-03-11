class SimData {
  final List<SimCard> cards;

  const SimData({required this.cards});

  factory SimData.fromJson(Map<String, dynamic> json) {
    final cardsList = json['cards'];

    if (cardsList != null && cardsList is List) {
      final cards = cardsList
          .map<SimCard>((card) => SimCard.fromJson(card))
          .toList();
      return SimData(cards: cards);
    }

    return const SimData(cards: []);
  }
}

class SimCard {
  final String carrierName;
  final String countryCode;
  final String displayName;
  final bool isDataRoaming;
  final bool isNetworkRoaming;
  final int mcc;
  final int mnc;
  final int slotIndex;
  final String serialNumber;
  final int subscriptionId;
  final String phoneNumber;

  const SimCard({
    required this.carrierName,
    required this.countryCode,
    required this.displayName,
    required this.isNetworkRoaming,
    required this.isDataRoaming,
    required this.mcc,
    required this.mnc,
    required this.slotIndex,
    required this.serialNumber,
    required this.subscriptionId,
    required this.phoneNumber,
  });

  factory SimCard.fromJson(Map<String, dynamic> json) {
    return SimCard(
      carrierName: json['carrierName'] ?? '',
      countryCode: json['countryCode'] ?? '',
      displayName: json['displayName'] ?? '',
      isDataRoaming: json['isDataRoaming'] ?? false,
      isNetworkRoaming: json['isNetworkRoaming'] ?? false,
      mcc: json['mcc'] ?? 0,
      mnc: json['mnc'] ?? 0,
      slotIndex: json['slotIndex'] ?? 0,
      serialNumber: json['serialNumber'] ?? '',
      subscriptionId: json['subscriptionId'] ?? 0,
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  @override
  String toString() {
    return 'SimCard(carrier: $carrierName, number: $phoneNumber)';
  }
}
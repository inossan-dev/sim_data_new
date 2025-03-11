import 'package:flutter_test/flutter_test.dart';
import 'package:sim_data_new/sim_data.dart';

void main() {
  group('SimData model', () {
    test('fromJson creates empty list when cards is null', () {
      // Arrange
      final Map<String, dynamic> json = {'cards': null};

      // Act
      final SimData simData = SimData.fromJson(json);

      // Assert
      expect(simData.cards, isEmpty);
    });

    test('fromJson creates empty list when cards is not a list', () {
      // Arrange
      final Map<String, dynamic> json = {'cards': 'not a list'};

      // Act
      final SimData simData = SimData.fromJson(json);

      // Assert
      expect(simData.cards, isEmpty);
    });

    test('fromJson creates list of SimCard objects from valid JSON', () {
      // Arrange
      final Map<String, dynamic> json = {
        'cards': [
          {
            'carrierName': 'Test Carrier',
            'countryCode': 'FR',
            'displayName': 'Test SIM',
            'isDataRoaming': false,
            'isNetworkRoaming': true,
            'mcc': 208,
            'mnc': 15,
            'phoneNumber': '+33612345678',
            'serialNumber': '1234567890ABCDEF',
            'slotIndex': 0,
            'subscriptionId': 1
          }
        ]
      };

      // Act
      final SimData simData = SimData.fromJson(json);

      // Assert
      expect(simData.cards, hasLength(1));
      expect(simData.cards[0].carrierName, 'Test Carrier');
      expect(simData.cards[0].countryCode, 'FR');
      expect(simData.cards[0].displayName, 'Test SIM');
      expect(simData.cards[0].isDataRoaming, false);
      expect(simData.cards[0].isNetworkRoaming, true);
      expect(simData.cards[0].mcc, 208);
      expect(simData.cards[0].mnc, 15);
      expect(simData.cards[0].phoneNumber, '+33612345678');
      expect(simData.cards[0].serialNumber, '1234567890ABCDEF');
      expect(simData.cards[0].slotIndex, 0);
      expect(simData.cards[0].subscriptionId, 1);
    });

    test('SimCard handles missing fields', () {
      // Arrange
      final Map<String, dynamic> json = {
        'carrierName': 'Test Carrier',
        'displayName': 'Test SIM'
        // Other fields are missing
      };

      // Act
      final SimCard card = SimCard.fromJson(json);

      // Assert
      expect(card.carrierName, 'Test Carrier');
      expect(card.displayName, 'Test SIM');
      expect(card.countryCode, '');
      expect(card.mcc, 0);
      expect(card.mnc, 0);
      expect(card.phoneNumber, '');
      expect(card.isDataRoaming, false);
      expect(card.isNetworkRoaming, false);
    });
  });
}
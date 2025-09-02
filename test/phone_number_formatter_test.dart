import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/utils/phone_number_formatter.dart';

void main() {
  group('PhoneNumberFormatter', () {
    group('formatPhoneNumber', () {
      test('removes +267 prefix and formats 7-digit number', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('+2676843242'), '684 3242');
      });

      test('formats 7-digit number without prefix', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('6843242'), '684 3242');
      });

      test('handles 7-digit number with spaces', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('684 3242'), '684 3242');
      });

      test('does not format non-7-digit numbers', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('12345678'), '12345678');
        expect(PhoneNumberFormatter.formatPhoneNumber('123456'), '123456');
        expect(PhoneNumberFormatter.formatPhoneNumber('123'), '123');
      });

      test('handles "no contact" cases', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('No contact'), 'No contact');
        expect(PhoneNumberFormatter.formatPhoneNumber('no contact available'), 'no contact available');
        expect(PhoneNumberFormatter.formatPhoneNumber('NO CONTACT'), 'NO CONTACT');
      });

      test('handles empty string', () {
        expect(PhoneNumberFormatter.formatPhoneNumber(''), '');
      });

      test('handles non-numeric strings', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('Call us'), 'Call us');
        expect(PhoneNumberFormatter.formatPhoneNumber('abc123def'), 'abc123def');
      });

      test('removes +267 prefix from longer numbers', () {
        expect(PhoneNumberFormatter.formatPhoneNumber('+26712345678'), '12345678');
      });
    });

    group('getDialableNumber', () {
      test('adds +267 prefix to 7-digit numbers', () {
        expect(PhoneNumberFormatter.getDialableNumber('6843242'), '+2676843242');
        expect(PhoneNumberFormatter.getDialableNumber('684 3242'), '+2676843242');
      });

      test('keeps +267 prefix when already present', () {
        expect(PhoneNumberFormatter.getDialableNumber('+2676843242'), '+2676843242');
        expect(PhoneNumberFormatter.getDialableNumber('+267 6843242'), '+2676843242');
      });

      test('does not modify non-7-digit numbers', () {
        expect(PhoneNumberFormatter.getDialableNumber('12345678'), '12345678');
        expect(PhoneNumberFormatter.getDialableNumber('123456'), '123456');
      });

      test('handles "no contact" cases', () {
        expect(PhoneNumberFormatter.getDialableNumber('No contact'), 'No contact');
        expect(PhoneNumberFormatter.getDialableNumber('no contact available'), 'no contact available');
      });

      test('handles empty string', () {
        expect(PhoneNumberFormatter.getDialableNumber(''), '');
      });

      test('removes spaces from phone numbers', () {
        expect(PhoneNumberFormatter.getDialableNumber('684 324 2'), '6843242');
        expect(PhoneNumberFormatter.getDialableNumber(' 684 324 2 '), '6843242');
      });
    });
  });
}
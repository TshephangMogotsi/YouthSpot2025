/// Utility class for formatting phone numbers according to specific requirements
class PhoneNumberFormatter {
  
  /// Formats a phone number by:
  /// 1. Removing "+267" prefix if present
  /// 2. Adding space after first 3 digits for 7-digit numbers
  /// 
  /// Examples:
  /// - "+2676843242" → "684 3242"
  /// - "6843242" → "684 3242"
  /// - "12345678" → "12345678" (no change for non-7-digit numbers)
  /// - "No contact" → "No contact" (no change for non-numeric strings)
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;
    
    // Handle "no contact" cases
    if (phoneNumber.toLowerCase().contains('no contact')) {
      return phoneNumber;
    }
    
    // Remove whitespace and normalize
    String cleaned = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    
    // Remove "+267" prefix if present
    if (cleaned.startsWith('+267')) {
      cleaned = cleaned.substring(4);
    }
    
    // Check if it's exactly 7 digits
    if (cleaned.length == 7 && RegExp(r'^\d{7}$').hasMatch(cleaned)) {
      // Add space after first 3 digits
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3)}';
    }
    
    // Return as-is if not a 7-digit number
    return cleaned;
  }
  
  /// Returns the original unformatted phone number for dialing purposes
  /// This removes formatting but keeps the number intact for phone calls
  static String getDialableNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;
    
    // Handle "no contact" cases
    if (phoneNumber.toLowerCase().contains('no contact')) {
      return phoneNumber;
    }
    
    // Remove whitespace
    String cleaned = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    
    // If it doesn't start with +267 and is 7 digits, add the +267 prefix
    if (cleaned.length == 7 && RegExp(r'^\d{7}$').hasMatch(cleaned)) {
      return '+267$cleaned';
    }
    
    // If it already starts with +267, keep as is
    if (cleaned.startsWith('+267')) {
      return cleaned;
    }
    
    // Return as-is for other formats
    return cleaned;
  }
}
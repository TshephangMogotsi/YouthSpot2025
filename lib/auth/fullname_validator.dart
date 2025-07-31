class FullNameValidator {
  static String? validate(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) {
      return 'Please enter your full name';
    }
    
    // Check if the name contains at least two words (first name and last name)
    List<String> nameParts = fullName.trim().split(' ');
    if (nameParts.length < 2) {
      return 'Please enter both first and last name';
    }
    
    // Check for minimum length per name part
    for (String part in nameParts) {
      if (part.trim().length < 2) {
        return 'Each name must be at least 2 characters long';
      }
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    RegExp namePattern = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!namePattern.hasMatch(fullName)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null; // No error
  }
}
# Token-Based Password Reset Implementation

## Overview
Implemented a token-based password reset flow for mobile apps that don't have a domain yet. This circumvents the issue of broken reset links by using tokens that users can enter manually.

## New Flow
1. **Email Entry**: User enters their email address
2. **Email Sent**: Shows confirmation that token was sent, with "Proceed" button
3. **Token Entry**: User enters the 6-digit token from their email
4. **New Password**: User sets a new password and confirms it
5. **Reset Complete**: Confirmation that password was successfully reset

## Changes Made

### AuthService (`lib/auth/auth_service.dart`)
- Added `verifyResetToken()` method to verify the token using Supabase's verifyOTP
- Added `updatePasswordWithToken()` method to update password after token verification
- Both methods include proper error handling and timeout management

### Reset Password Page (`lib/auth/reset_password.dart`)
- Added enum `ResetPasswordState` with 5 states: emailEntry, emailSent, tokenEntry, newPasswordForm, resetComplete
- Added controllers for token, new password, and confirm password
- Added separate form keys for each step
- Modified UI to show different content based on current state
- Changed "Back to login" button to "Proceed" after email is sent
- Added token entry form with validation
- Added new password form with password visibility toggles
- Added completion screen

### Email Template Update
- Updated text to mention "token" instead of "link"
- The Supabase email template should already be configured to send `{{ .Token }}`

## Features
- **Back Navigation**: Users can go back to previous steps
- **Input Validation**: Each form has appropriate validation
- **Password Visibility**: Toggle visibility for password fields
- **Error Handling**: Proper error messages for each step
- **Loading States**: Loading indicators during API calls

## Testing
Created `token_reset_password_test.dart` with basic widget tests to validate the implementation.

## Email Template
The Supabase email template has been configured to send tokens instead of links:
```html
<div class="token-box">{{ .Token }}</div>
```

This implementation provides a seamless mobile-first password reset experience without requiring domain-based reset links.
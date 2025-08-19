#!/bin/bash

# Password Reset Testing Script
# Use this script to test password reset functionality on different build types

echo "YouthSpot Password Reset Testing Script"
echo "========================================"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter not found in PATH"
    echo "Please install Flutter and ensure it's in your PATH"
    exit 1
fi

# Function to build and test
test_password_reset() {
    local build_type=$1
    local device_id=$2
    
    echo ""
    echo "Testing password reset for $build_type build..."
    echo "Device: $device_id"
    
    # Clean previous builds
    flutter clean
    flutter pub get
    
    if [ "$build_type" == "debug" ]; then
        echo "Building debug APK..."
        flutter build apk --debug
        
        if [ $? -eq 0 ]; then
            echo "Debug build successful"
            if [ -n "$device_id" ]; then
                echo "Installing on device $device_id..."
                flutter install --device-id="$device_id"
            fi
        else
            echo "Debug build failed"
            return 1
        fi
        
    elif [ "$build_type" == "release" ]; then
        echo "Building release APK..."
        flutter build apk --release
        
        if [ $? -eq 0 ]; then
            echo "Release build successful"
            if [ -n "$device_id" ]; then
                echo "Installing on device $device_id..."
                adb -s "$device_id" install build/app/outputs/flutter-apk/app-release.apk
            fi
        else
            echo "Release build failed"
            return 1
        fi
    fi
    
    echo ""
    echo "Build completed. To test password reset:"
    echo "1. Open the app on the device"
    echo "2. Go to login screen"
    echo "3. Tap 'Forgot Password'"
    echo "4. Enter a valid email address"
    echo "5. Check for diagnostic logs in device logs:"
    echo "   adb -s $device_id logcat | grep 'YouthSpot'"
    echo ""
}

# Function to show device logs
show_logs() {
    local device_id=$1
    echo "Showing YouthSpot logs for device: $device_id"
    echo "Press Ctrl+C to stop log monitoring"
    echo "=========================================="
    adb -s "$device_id" logcat | grep --color=always "YouthSpot"
}

# Main menu
echo ""
echo "Available options:"
echo "1. Test debug build"
echo "2. Test release build"
echo "3. Show device logs"
echo "4. List connected devices"
echo "5. Exit"
echo ""

# Get connected devices
devices=$(adb devices | grep -v "List" | grep "device" | cut -f1)
device_count=$(echo "$devices" | wc -l)

if [ $device_count -eq 0 ]; then
    echo "No devices connected. Please connect a device and enable USB debugging."
    exit 1
elif [ $device_count -eq 1 ]; then
    selected_device=$devices
    echo "Using device: $selected_device"
else
    echo "Multiple devices found:"
    echo "$devices"
    echo ""
    read -p "Enter device ID: " selected_device
fi

read -p "Select option (1-5): " choice

case $choice in
    1)
        test_password_reset "debug" "$selected_device"
        ;;
    2)
        test_password_reset "release" "$selected_device"
        ;;
    3)
        show_logs "$selected_device"
        ;;
    4)
        echo "Connected devices:"
        adb devices
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
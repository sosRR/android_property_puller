#!/bin/bash

## make_variables.sh script for Android devices, by sosRR
## Make the script executable by running: `chmod +x make_variables.sh`.
## Let me know what is not right so i can rewrite

# Connect to the Android device via ADB
device=$(adb devices)
echo "Device ID $device is connected" 

# Create the .mk file
output_file="device_variables.mk"
echo "Creating $output_file..."

# Execute `getprop` command and store the output in a variable
prop_output=$(adb shell getprop)

# Start writing the .mk file
echo "# Device variables" > $output_file

# Process each line of the `getprop` output
while IFS= read -r line; do
  # Skip empty lines
  if [[ -z "$line" ]]; then
    continue
  fi

  # Extract the property name and value
  property=$(echo "$line" | cut -d'[' -f1 | tr -d ' ')
  value=$(echo "$line" | cut -d'[' -f2- | cut -d']' -f1)

  # Write the property and value to the .mk file
  echo "$property := $value" >> $output_file
done <<< "$prop_output"

echo "File $output_file created successfully!"

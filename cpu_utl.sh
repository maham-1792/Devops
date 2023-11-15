#!/bin/bash

# Email configuration
recipient="mahamasif606@gmail.com"
subject_low="CPU Utilization Low"
subject_high="CPU Utilization High"

# Set thresholds for CPU utilization
threshold_low=10
threshold_high=75

# Function to send email
send_email() {
    local subject="$1"
    local message="$2"
    echo -e "Subject:$subject\n$message" | ssmtp "$recipient"
}

# Main monitoring loop
while true; do
    # Get CPU utilization using mpstat
    cpu_utilization=$(mpstat 1 1 | awk '$12 ~ /[0-9.]+/ {print 100 - $12}' | tr -d '\n')

    # Check if CPU utilization is below 10%
    if [ "$(printf "%.0f" "$cpu_utilization")" -lt "$threshold_low" ]; then
        if [ "$notify_low" != "yes" ]; then
            # Send email for low CPU utilization
            send_email "$subject_low" "CPU utilization is below $threshold_low%: $cpu_utilization%"
            notify_low="yes"
            notify_high="no"
        fi
    elif [ "$(printf "%.0f" "$cpu_utilization")" -gt "$threshold_high" ]; then
        if [ "$notify_high" != "yes" ]; then
            # Send email for high CPU utilization
            send_email "$subject_high" "CPU utilization is above $threshold_high%: $cpu_utilization%"
            notify_high="yes"
            notify_low="no"
        fi
    else
        # Reset notification flags when CPU utilization is between thresholds
        notify_low="no"
        notify_high="no"
    fi

    # Sleep for a specific interval before checking again
    sleep 300  # Adjust the interval as needed
done

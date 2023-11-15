#!/bin/bash

if [ "$#" -ne 2 ];then

	echo "Please provide both: <website> <email>"
	exit 1
fi

check_certificate_expiry(){
	local website=$1
	local expiry_date
	local openssl_cmd="/usr/bin/openssl"
	expiry_date=$("$openssl_cmd" s_client -servername "$website" -connect "$website":443 2>&1 | "$openssl_cmd" x509 -noout -enddate)

	if [ "$?" -ne 0 ]; then
		echo "Unable to retrieve certificate information for $website."
		exit 1
	fi

	local not_after
	not_after=$(echo "$expiry_date" | awk -F= '/notAfter/ {print $2}' | tr -d '\n' | sed 's/ GMT//')

	if [ -z "$not_after" ]; then
		echo "Error in parsing certificate expiration date for $website"
		exit 1
	fi
	#expiry_date=${expiry_date#*=}
	local expiry_time
	expiry_time=$(date -d "$not_after" +"%s")

	if ["$?" -ne 0 ]; then
		echo "Error: converting certificate expiration date for $website"
		exit 1
	fi
	local current_time
	current_time=$(date +"%s")
	local expiry_diff=$((expiry_time - current_time))
	local expiry_days=$((expiry_diff / 86400))
	echo "$expiry_days"
}

email()
{
	local to_email=$1
	local website=$2
	local days_left=$3
	local from_email="mahamasif606@gmail.com"
	local subject="SSL Certificate Expiry Alert for $website"
	local message="SSl Crtificate for $website will expie in $days_left days"
	echo "$message" | /usr/bin/mail -s "$subject" -a "From: $from_email" "$to_email"
}

website="$1"
to_email="$2"
days_left=$(check_certificate_expiry "$website")
if [ -n "$days_left" ] && [ "$days_left" -le 60 ]; then
	email "$to_email" "$website" "$days_left"
	echo "Email sent: SSL certificte for $website will expire in $days_left days."
else
	echo "SSl certificate for $website will expire in $days_left days. No Email sent"
fi


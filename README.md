Create a bash script to monitor CPU utilization and send email notifications
1. Sign up for a free account at SendGrid. You do not need any credit/debit card to create a
free account https://sendgrid.com/. Learn what is the use of SendGrid. You can use
SendGrid API to send emails programmatically.
2. Create a simple script to monitor CPU utilization and send an email whenever CPU
utilization is less than 10% or more than 75%.
3. Your script should not send too many emails. Send emails only when the CPU threshold
is as per the specific values, and do not keep sending emails for the same threshold
repeatedly. For example, if the CPU utilization is 10% continuously, you must send the
email only once. But if the utilization remains greater than 10% for some and then goes
below 10% again, then your script should send an email again.
Task 3: SSL Certificate Expiry Date Checker
1. Create a simple bash script to check the SSL certificate expiry date for the given website
passed as a command line argument.
2. If the SSL certificate expires within 2 months, send an email. The email is passed as a
second parameter.
3. The script will run like:
./check_ssl.sh www.waheediqbal.info test@gmail.com
here www.waheediqbal.info is a website passed as first argument and test@gmail.com
as email address for the.

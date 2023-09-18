#! /bin/bash
set -e

echo -e "\n~~~~~ MY SALON ~~~~~\n"


echo -e "\nWelcome to My Salon, how can I help you?"

while true; do
	query_result=$(psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "SELECT * FROM services")
	echo -e $query_result
	read SERVICE_ID_SELECTED

	query_result=$(psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "SELECT name FROM services where service_id = $SERVICE_ID_SELECTED")
	if [[ -z "$query_result" ]]; then
		# Improper service id entered
		echo -e "\nI could not find that service. What would you like today?"
	else
		service_name=$query_result
		break
	fi
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

query_result=$(psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "SELECT name FROM customers where phone = '$CUSTOMER_PHONE'")
if [[ -z "$query_result" ]]; then
	# New customer
	echo -e "\nI don't have a record for that phone number, what's your name?"
	read CUSTOMER_NAME

	psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
fi

customer_id=$(psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "SELECT customer_id FROM customers where phone = '$CUSTOMER_PHONE'")
customer_name=$(psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "SELECT name FROM customers where phone = '$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your $service_name, $customer_name?"
read SERVICE_TIME

psql --username=freecodecamp --dbname=salon --quiet --no-align --tuples-only --field-separator $') ' --command "INSERT INTO appointments (customer_id, service_id, time) VALUES ($customer_id, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "\nI have put you down for a $service_name at $SERVICE_TIME, $customer_name."
#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN() {
  
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Get all services
  SERVICES=$($PSQL "select * from services;")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
  # Display services as #) <service>
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # Read a service id
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
  
  # Check if service exists
  if [[ -z $SERVICE_NAME ]]
  then

    # Goto main if doesn't exists
    MAIN "I could not find that service. What would you like today?"
  
  else
  
    echo -e "\nWhat's your phone number?"
    # Read phone number
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")

    # Create customer if doesn't exists
    if [[ -z $CUSTOMER_NAME ]]
    then
      
      echo -e "\nI don't have a record for that phone number, what's your name?"
      # Read customer name
      read CUSTOMER_NAME

      # Insert customer
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
    
    fi

    # Get customer id
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
    
    echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    # Read service time
    read SERVICE_TIME
    
    # Insert appointment
    INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    
    # Display appointment
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"
  
  fi
}

MAIN "Welcome to My Salon, how can I help you?"
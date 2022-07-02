#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

FAILED_SEARCH() {
  echo "I could not find that element in the database."
}

ELEMENT_PRINT() {
  echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

ATOMIC_NUMBER_QUERY() {
  ELEMENTS_QUERY=$($PSQL "select * from elements where atomic_number=$1;")
  if [[ ! -z $ELEMENTS_QUERY ]]
    then
      echo "$ELEMENTS_QUERY" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
      do
        PROPERTIES_QUERY=$($PSQL "select * from properties where atomic_number=$1;")
        echo "$PROPERTIES_QUERY" | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE_ID
          do
            TYPE=$($PSQL "select type from types where type_id=$TYPE_ID;")
            ELEMENT_PRINT $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELT_POINT $BOIL_POINT
          done
      done
    else 
      FAILED_SEARCH
  fi
}

SYMBOL_QUERY() {
  ELEMENTS_QUERY=$($PSQL "select * from elements where symbol ilike '$1';")
  if [[ ! -z $ELEMENTS_QUERY ]]
    then
      echo "$ELEMENTS_QUERY" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
      do
        PROPERTIES_QUERY=$($PSQL "select * from properties where atomic_number=$ATOMIC_NUMBER;")
        echo "$PROPERTIES_QUERY" | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE_ID
          do
            TYPE=$($PSQL "select type from types where type_id=$TYPE_ID;")
            ELEMENT_PRINT $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELT_POINT $BOIL_POINT
          done
      done
    else 
      FAILED_SEARCH
  fi
}

NAME_QUERY() {
   ELEMENTS_QUERY=$($PSQL "select * from elements where name ilike '$1';")
  if [[ ! -z $ELEMENTS_QUERY ]]
    then
      echo "$ELEMENTS_QUERY" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
      do
        PROPERTIES_QUERY=$($PSQL "select * from properties where atomic_number=$ATOMIC_NUMBER;")
        echo "$PROPERTIES_QUERY" | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE_ID
          do
            TYPE=$($PSQL "select type from types where type_id=$TYPE_ID;")
            ELEMENT_PRINT $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELT_POINT $BOIL_POINT
          done
      done
    else 
      FAILED_SEARCH
  fi
}

INPUT_PARSING() {
if [[ $1 =~ ^[0-9]+$ ]]
  then 
    ATOMIC_NUMBER_QUERY $1
  elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
    then 
      SYMBOL_QUERY $1
    elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
      then 
        NAME_QUERY $1
  else 
    FAILED_SEARCH
fi
}

if [[ -z $1 ]]
  then 
    echo Please provide an element as an argument.
  else 
    INPUT_PARSING $1
fi

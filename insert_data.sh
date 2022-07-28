#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != 'year' ]]
  then
    #insert team names to teams
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER') ON CONFLICT (name) DO NOTHING")"
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT') ON CONFLICT (name) DO NOTHING")"
    
    #insert data to games
    echo "$($PSQL "INSERT INTO games (year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES ($YEAR ,(SELECT team_id FROM teams WHERE name = '$WINNER'),(SELECT team_id FROM teams WHERE name = '$OPPONENT'),$WINNER_GOALS,$OPPONENT_GOALS,'$ROUND')")"



  fi
done
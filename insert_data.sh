#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams")
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # If team not in teams table, put it in
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $INSERT_TEAM_RESULT $WINNER into teams
  fi
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $INSERT_TEAM_RESULT $OPPONENT into teams
  fi

  # Insert game into games
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES
  ($YEAR,
  '$ROUND',
  (SELECT team_id FROM teams WHERE name='$WINNER'),
  (SELECT team_id FROM teams WHERE name='$OPPONENT'),
  $WINNER_GOALS,
  $OPPONENT_GOALS)")
  echo $INSERT_GAME_RESULT $YEAR game into games
done
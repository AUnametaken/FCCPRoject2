#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals+opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals+opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT GREATEST(MAX(winner_goals),MAX(opponent_goals)) FROM games")" # Logically pointless to consider the opponent_goals, but it does proof the query against incorrect data entry.

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals>2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games JOIN teams ON games.winner_id=teams.team_id WHERE round ILIKE 'final' AND year=2018")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT winners.name FROM games JOIN teams AS winners ON games.winner_id=winners.team_id WHERE round ILIKE 'eighth-final' AND year=2014 UNION SELECT opps.name FROM games JOIN teams AS opps ON games.opponent_id=opps.team_id WHERE round ILIKE 'eighth-final' AND year=2014 ORDER BY name ASC")" # wew

echo -e "\nList of unique winning team names in the whole data set:"
echo  "$($PSQL "SELECT DISTINCT(name) FROM games JOIN teams ON games.winner_id=teams.team_id ORDER BY name ASC")" # No condition required. Order by required to satisfy expected output.

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year,name FROM games JOIN teams ON games.winner_id=teams.team_id WHERE round ILIKE 'final' ORDER BY year ASC")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games") 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT  WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != 'winner' ]]
then 
# get team from WINNER
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
# if TEAM_ID  doesn't exist
if [[ -z $WINNER_ID ]]
# insert team
then
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")
if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
then
  echo Inserted into teams, $WINNER 
fi
# get new TEAM_ID 
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

fi

# get team from OPPONENT 
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
# if TEAM_ID  doesn't exist
if [[ -z $OPPONENT_ID ]]
# insert team
then
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
    # get new TEAM_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
    fi
# read 
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
  then
    echo Inserted into games, $YEAR $ROUND
  fi
fi
done 
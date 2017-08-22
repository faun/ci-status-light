#!/bin/bash
: ${CIRCLE_URL:?"You must specify CIRCLE_URL"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trap '{ echo "Resetting LED." ; reset_colors; exit; }' INT

set_color() {
  python3 "$DIR/set_color.py" $1 $2 $3
}

red() {
  set_color 128 0 0
}

green() {
  set_color 0 128 0
}

blue() {
  set_color 0 0 128
}

orange() {
  set_color 255 140 0
}

purple() {
  set_color 128 0 128
}

fuscia() {
  set_color 255 128 255
}

reset_colors () {
  set_color 0 0 0
}

while :
do
  unset CI_STATUS
  CI_STATUS=$(wget  -qO- "$CIRCLE_URL" | jq -r '.[].status')
  echo "Status: $CI_STATUS"
  if [[ "$CI_STATUS" = "success" ]] || [[ "$CI_STATUS" = "fixed" ]] 
  then
    green
    if [[ "$POST_TO_SLACK" = "true" ]]
    then
      echo "Posting to slack channel"
      "$DIR/post_to_slack.sh" fixed
    fi
  elif [[ "$CI_STATUS" = "failed" ]]
  then
    red
    if [[ "$POST_TO_SLACK" = "true" ]]
    then
      echo "Posting to slack channel"
      "$DIR/post_to_slack.sh" failed
    fi
  elif [[ "$CI_STATUS" = "canceled" ]]
  then
    orange
  elif [[ "$CI_STATUS" = "running" ]]
  then
    blue
  elif [[ "$CI_STATUS" = "queued" ]]
  then
    purple
  else
    fuscia
  fi
  sleep ${TIMEOUT:-30}
done


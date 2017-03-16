#!/bin/bash
: ${CIRCLE_URL:?"You must specify CIRCLE_URL"}

# Enable GPIO.22 (BCM 6) output mode (red LED)
gpio mode 22 out

# Enable GPIO.25 (BCM 26) output mode (blue LED)
gpio mode 25 out

# Enable GPIO.23 (BCM 13) output mode (green LED)
gpio mode 23 out

trap '{ echo "Resetting LED." ; reset_colors; exit; }' INT

led_color () {
  reset_colors
  if [[ "$1" == "red" ]]
  then
    red
  elif [[ "$1" = "blue" ]]
  then
    blue
  elif [[ "$1" = "green" ]]
  then
    green
  elif [[ "$1" = "orange" ]]
  then
    red
    green
  elif [[ "$1" = "purple" ]]
  then
    red
    blue
  else
    echo "Usage: led_color color"
    echo "Colors: red, blue, green, orange, purple"
    exit 1
  fi
  echo "Changing color: $1"
}

red () {
  # Turn on the red led
  gpio write 22 on
}

blue () {
  # Turn on the blue led
  gpio write 25 on
}

green () {
  # Turn on the green led
  gpio write 23 on
}

reset_colors () {
  # Turn off the red led
  gpio write 22 off

  # Turn off the green led
  gpio write 23 off

  # Turn off the blue led
  gpio write 25 off
}

while :
do
  unset CI_STATUS
  CI_STATUS=$(wget  -qO- "$CIRCLE_URL" | jq -r '.[].status')
  echo "Status: $CI_STATUS"
  if [[ "$CI_STATUS" = "success" ]] || [[ "$CI_STATUS" = "fixed" ]] 
  then
    led_color green
    if [[ "$POST_TO_SLACK" = "true" ]]
    then
      echo "Posting to slack channel"
      ./post_to_slack.sh fixed
    fi
  elif [[ "$CI_STATUS" = "failed" ]]
  then
    led_color red
    if [[ "$POST_TO_SLACK" = "true" ]]
    then
      echo "Posting to slack channel"
      ./post_to_slack.sh failed
    fi
  elif [[ "$CI_STATUS" = "canceled" ]]
  then
    led_color orange
  elif [[ "$CI_STATUS" = "running" ]] || [[ "$CI_STATUS" = "queued" ]]
  then
    led_color blue
	else
    led_color purple
  fi
  sleep ${TIMEOUT:-30}
done


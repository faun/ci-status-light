#!/usr/bin/env bash
: ${CIRCLE_CI_BRANCH_URL:?"You must specify CIRCLE_CI_BRANCH_URL"}
: ${SLACK_WEBHOOK_URL:?"You must specify SLACK_WEBHOOK_URL"}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$1" = "fixed" ]]
then
  if [[ -f "$DIR/.failed-build" ]]
  then
    MESSAGE="The build on the Hellblazer master branch has been fixed. Hooray!"
    MESSAGE_COLOR="good"
    rm "$DIR/.failed-build"
  else
    echo "Already notified slack"
    exit
  fi
elif [[ "$1" = "failed" ]]
then
  if [[ -f "$DIR/.failed-build" ]]
  then
    echo "Already notified slack"
    exit
  else
    MASTER_BRANCH_LINK="<$CIRCLE_CI_BRANCH_URL|Fix it ➡️>"
    MESSAGE_COLOR="danger"
    MESSAGE="A build has failed on the Hellblazer master branch. $MASTER_BRANCH_LINK"
    touch "$DIR/.failed-build"
  fi
fi

if [[ "${SEND_MESSAGE:-x}" != "true" ]]
then
  WEBHOOK_PAYLOAD="payload={\"text\": \"$MESSAGE\", \"color\": \"$MESSAGE_COLOR\"}"
  wget -qO- --post-data="$WEBHOOK_PAYLOAD" "$SLACK_WEBHOOK_URL" &> /dev/null
  echo "Notified slack"
  unset SEND_MESSAGE
fi

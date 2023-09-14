#!/bin/sh
# This script defines send_slack function to be called for sending text notifications as Jenkins-CI app / user to Slack from shell
# command line. We found the standard Jenkins Slack notification plugin too limiting, especially when working with bash scripts and
# checking various conditions. 
#
# You can call this script as 'source ./jenkins-ci-slack-nofity.sh' from another script and then call send_slack from bash command line.  
# Example: 
# First, we define the send_slack function
send_slack() {

# We need to make sure we add text to be sent to Slack. We send type markdown in the payload, so feel free to use markdown formatting.
        if [ -z "${1}" ];then
                echo "Error: You need to add text to send to Slack"
                exit 1
        fi
# Here we define to which channel we will post messgaes and which user account. 
# Because we are using the jenkins-ci app hook and secret, this needs to be a channel and users name corresponding with the 
# jenkins-ci app cconfiguration. You can open Jenkins-CI app details in the app catalog of your Slack to find out which channels
# the app is allowed to post
# the username for jenkins-ci app is jenkins by default

        [ -z "${SLACK_CHAN}" ] && SLACK_CHAN="#your-channel"
        [ -z "${SLACK_USERNAME}" ] && SLACK_USERNAME=jenkins

# Use your organizations workspace instead of <yourOrgWorkspaceName> here. This is the same that you use to 
# log in to Slack via web client
# finally replace the <secret> with the token (secret) for your jenkins-ci app

URL=https://<yourOrgWorkspaceName>.slack.com/services/hooks/jenkins-ci/<secret>

# And finally send it all to Slack. 
        curl -X POST --data-urlencode 'payload={"channel": "'${SLACK_CHAN}'", "username": "'${SLACK_USERNAME}'", "type": "mrkdwn", "text": "'"${*}"'"}' ${URL} 
}


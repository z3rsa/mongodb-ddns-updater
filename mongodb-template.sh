#!/bin/bash
## change to "bin/sh" when necessary

# MongoDB Atlas API configuration
public_key=""                                                                   # Public API Key from Project Settings -> Access Manager
private_key=""                                                                  # Private API Key from Project Settings -> Access Manager
group_id=""                                                                     # GroupID same as ProjectID on MongoDB Project Settings
discord_webhook_url=""                                                          # URI for Discord WebHook "https://discordapp.com/api/webhooks/xxxxx"
tanggal=$(LC_ALL=id_ID.utf8 TZ=Your/Timezone date +"%A, %d %B %Y Jam %H:%M:%S") # tanggal means date

ip_address=$(curl -s https://api.ipify.org) # Get Dynamic IP

# Get the current access list
current_access_list=$(curl --user "${public_key}:${private_key}" --digest --include \
     --header "Accept: application/json" \
     --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/${group_id}/accessList?pretty=true")

ip_list=$(echo "$current_access_list" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

# Check if the IP address is already in the access list
if echo "$current_access_list" | grep -q "$ip_address"; then
  echo "IP address ${ip_address} is already in the access list"
  if [[ $discord_webhook_url != "" ]]; then
    curl -H "Content-Type: application/json" -X POST -d '{
      "content": null,
      "embeds": [
        {
          "title": "MongoDB Access List 【example.com】",
          "description": "**Gagal menambah IP Address!**\n⸺⸺⸺⸺⸺⸺⸺⸺◉\n'IP' ➠ '$ip_address' sudah ada\n⸺⸺⸺⸺⸺⸺⸺⸺◉\n'"$tanggal"'",
          "color": 16711680 # Red Color
        }
      ],
      "attachments": []
    }' $discord_webhook_url
  fi
  exit 0
else
  while read -r ip_list; do
    deleteResult=$(curl --user "${public_key}:${private_key}" --digest --include \
      --header "Accept: application/json" \
      --header "Content-Type: application/json" \
      --request DELETE "https://cloud.mongodb.com/api/atlas/v1.0/groups/${group_id}/accessList/${ip_list}")
    echo "$deleteResult"
    
    # Check if the delete was successful and break out of the loop if it was
    if [[ $(echo "$deleteResult" | grep -cE "(204 No Content|401 Unauthorized)") -eq 1 ]]; then
      echo "IP address ${ip_list} deleted successfully"
      break
    else
      echo "Failed to delete IP address ${ip_list}"
    fi
  done <<< "$ip_list"
fi

# Add the IP address to the access list
result=$(curl --user "${public_key}:${private_key}" --digest --include \
     --header "Accept: application/json" \
     --header "Content-Type: application/json" \
     --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${group_id}/accessList?pretty=true" \
     --data "[{\"ipAddress\":\"${ip_address}\",\"comment\":\"IP Address Express\"}]")

# Report the status of the update
case "$result" in
*"\"error\":"*)
  echo "Failed to add IP address ${ip_address} to the access list"
  echo "$result"
  if [[ $discord_webhook_url != "" ]]; then
    curl -H "Content-Type: application/json" -X POST -d '{
      "content": null,
      "embeds": [
        {
          "title": "MongoDB Access List 【example.com】",
          "description": "IP address: '$ip_address'\nError: ${result}",
          "color": null # No Color If Error
        }
      ],
      "attachments": []
    }' $discord_webhook_url
  fi
  exit 1
  ;;
*)
  echo "Successfully added IP address ${ip_address} to the access list"
  echo "$result"
  if [[ $discord_webhook_url != "" ]]; then
    curl -H "Content-Type: application/json" -X POST -d '{
      "content": null,
      "embeds": [
        {
          "title": "MongoDB Access List 【example.com】",
          "description": "**Berhasil menambah IP Address!**\n⸺⸺⸺⸺⸺⸺⸺⸺◉\n'example.com' ➠ '$ip_address'\n⸺⸺⸺⸺⸺⸺⸺⸺◉\n'"$tanggal"'",
          "color": 65280 # Green Color
        }
      ],
      "attachments": []
    }' $discord_webhook_url
  fi
  exit 0
  ;;
esac


#!/bin/bash

echo "Starting the main script..."

echo "Deploying Client..."
bash ./client/deploy.sh sd_client

if [ $? -ne 0 ]; then
  echo "Client deploy failed."
  exit 1
fi

echo "Deploying Users Server..."
bash ./UserManagement/deploy.sh sd_users

if [ $? -ne 0 ]; then
  echo "Users deploy failed."
  exit 1
fi

echo "Deploying Devices Server..."
bash ./DeviceManagement/deploy.sh sd_devices

if [ $? -ne 0 ]; then
  echo "Chat deploy failed."
  exit 1
fi

echo "Deploying Chat Server..."
bash ./ChatManagement/deploy.sh sd_chat

if [ $? -ne 0 ]; then
  echo "Chat deploy failed."
  exit 1
fi

echo "All microservices have been deployed."
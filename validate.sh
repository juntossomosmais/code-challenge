#!/bin/bash

API_URL="http://localhost:8080/api/v1/users?pageNumber=1&pageSize=10"

# Make the API call and capture the response
response=$(curl -s $API_URL)

# Validate the response body structure using grep and awk
if echo "$response" | grep -q '"pageNumber"' && \
   echo "$response" | grep -q '"pageSize"' && \
   echo "$response" | grep -q '"totalCount"' && \
   echo "$response" | grep -q '2000' && \
   echo "$response" | grep -q '"users"' && \
   echo "$response" | awk '/"users": \[/ {flag=1; next} /]/ {flag=0} flag {print}' | grep -q '.'; then
  echo "Response body is valid."
else
  echo "Response body is invalid."
fi
#!/bin/bash

# Opprett et passord:
read -p "What namespace do you want to create this secret for? : " in_namespace

read -p "What secret do you want to produce in $in_namespace? : " secret_name

read -s -p "Whatwill the secret/password for $secret_name be? : " secret_pw

# Base64 encrypt password
kubectl -n $in_namespace create secret generic $secret_name --from-literal=password=$secret_pw --dry-run=client -o yaml > $secret_name.yaml

# Seal password with sealed-secrets
kubeseal --controller-name sealed-secrets-controller --controller-namespace sealed-secrets --format=yaml < $secret_name.yaml > $secret_name-sealed.yaml

# New line to make output nicer
printf " \n \n"

# Seal should be done
printf "Secret $secret_name created and sealed with sealed-secrets. \n"

# Inform user what file to use where
printf "\nThe file named $secret_name-sealed.yaml is now safe to use in the git repo\n \n"


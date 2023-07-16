#!/bin/zsh

echo "Redirecting to Github to create Personal Access Token (classic)."
echo "Click 'Generate New Token' and copy it to your clipboard."

cmd.exe /c "start https://github.com/settings/tokens"

echo "You will paste your token in the next prompt."
echo "You will have to right click to paste."
echo "Have you copied your GitHub token? [y/n]"
read input

if [ "$input" = "y" ]; then
  echo "Please paste your token and press Enter:"
  read gittoken
  echo ${gittoken} | lpass add --non-interactive 'gittoken'
  echo "Token added to LastPass."
else
  echo "Please copy your token and try again."
fi

export GITHUB_TOKEN="$gittoken"

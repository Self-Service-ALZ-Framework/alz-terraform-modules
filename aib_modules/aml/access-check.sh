#!/bin/bash

parent_directory_name="./access_checker_directory"

show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Show Intro Message
echo "👋 Hello! AI Booster created this interactive script"
echo "We are here to help with access validation."
echo "we will be taking a few inputs for proper validation."
echo "First, We will start with cloning a GitHub repository. 📂"
echo ""
echo "Here are the steps I will be checking for you:"
echo "1.  🐙   GitHub Clone Check"
echo "2.  🔐   Keyring Access Check"
echo "3.  📦   Storage Container Create Check"
echo "4.  📤   Storage Upload and Download Check"
echo "5.  🤖   LLM Call Check"
echo "6.  🔑   Key Vault Access Check"
echo "7.  🛠️    Build Docker Image Check"
echo "8.  🚀   Push Docker Image to ACR Check"
echo "9. 🔍   Deploy Index on Azure Search"

echo ""
# Prompt to Start
read -p "Press Enter to start the script..."
# Prompt for GitHub Credentials
echo ""
read -p "Enter your GitHub username: " username
read -sp "Enter your GitHub password/Access Token: " password
echo ""

# Clone Repositories and Check Access
test_repo_url="https://${username}:${password}@github.vodafone.com/vfgroup-aibooster/Azure-resources-test.git"

git clone "$test_repo_url" &> /dev/null &
show_spinner $!
if [ $? -eq 0 ]; then
    echo "> ✅ You have permission to clone GitHub repositories!"
    echo "> ✅ GitHub Cloned Successfully 😊"
else
    echo "> ❌ You do not have permission to clone GitHub repositories."
    exit 1
fi

# Move and Clean Up Directories
if [ -d "$parent_directory_name" ]; then
    rm -rf "$parent_directory_name"
fi
mkdir -p "$parent_directory_name"
mv ./Azure-resources-test "$parent_directory_name"

(cd "$parent_directory_name/Azure-resources-test" && make) 

rm -rf "$parent_directory_name"
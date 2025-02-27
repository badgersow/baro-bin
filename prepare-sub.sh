#!/bin/zsh

# A MacOS script to replace Submarine in Sub Editor with the one in the current campaign. Does not backup old submarine.
#
# 1. Decompresses save file
# 2. Replaces submarine in Sub Editor
#
# Preconditions: 
# - Install https://github.com/Jlobblet/Barotrauma-Save-Decompressor/blob/main/Barotrauma-Save-Decompressor-CLI/Program.cs
# - Install dotnet for MacOS
# - Edit the variables below to suit your needs


############## Start edit section

# Campaign name
CAMP_NAME="Klim"

# Submarine name
SUB_NAME="Kishka2"

# Path to CLI project of cloned repository with Barotrauma decompressor (see top of file)
COMPRESS_CLI="/Users/`whoami`/workspace/Barotrauma-Save-Decompressor/Barotrauma-Save-Decompressor-CLI"

############## End edit section

SUB_PATH="/Users/`whoami`/Library/Application Support/Steam/steamapps/common/Barotrauma/Barotrauma.app/Contents/MacOS/LocalMods/${SUB_NAME}/${SUB_NAME}.sub"
SAVE_NAME="${CAMP_NAME}.save"
SAVE_DIR_NAME="${CAMP_NAME}"
SAVE_DIR="/Users/`whoami`/Library/Application Support/Daedalic Entertainment GmbH/Barotrauma/Multiplayer"
SAVE_PATH="${SAVE_DIR}/${SAVE_NAME}"
NOW="$(date)"
WORKSPACE="/tmp/${NOW}"
OLD_SUB_HASH=`md5sum --quiet "${SUB_PATH}"`

echo "Copy save into temporary workspace..."
mkdir -p "${WORKSPACE}"
cp "${SAVE_PATH}" "${WORKSPACE}"

echo "Decompress the save, and remove it from the workspace..."
cd "${WORKSPACE}"
dotnet run --project "${COMPRESS_CLI}" decompress "${WORKSPACE}/${SAVE_NAME}"
rm "${WORKSPACE}/${SAVE_NAME}"

echo "Replace the sub in Sub Editor..."
cp "${WORKSPACE}/${SAVE_DIR_NAME}/${SUB_NAME}.sub" "${SUB_PATH}"

NEW_SUB_HASH=`md5sum --quiet "${SUB_PATH}"`
echo "Old sub hash: ${OLD_SUB_HASH}"
echo "New sub hash: ${NEW_SUB_HASH}"

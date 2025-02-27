#!/bin/zsh

# A MacOS script to replace Submarine in the current campaign with the one from Sub Editor.
#
# 1. Creates backup of a current save
# 2. Decompresses save file
# 3. Replaces submarine
# 4. Compresses save file
# 5. Replaces save file
#
# If something goes wrong, just manually copy backup file into the save directory
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

# Root directory for game backups
BACKUP_ROOT="/Users/`whoami`/Backup/Barotrauma"

# Path to CLI project of cloned repository with Barotrauma decompressor (see top of file)
COMPRESS_CLI="/Users/`whoami`/workspace/Barotrauma-Save-Decompressor/Barotrauma-Save-Decompressor-CLI"

############## End edit section


SUB_PATH="/Users/`whoami`/Library/Application Support/Steam/steamapps/common/Barotrauma/Barotrauma.app/Contents/MacOS/LocalMods/Kishka2/Kishka2.sub"
SAVE_NAME="${CAMP_NAME}.save"
SAVE_DIR_NAME="${CAMP_NAME}"
SAVE_DIR="/Users/`whoami`/Library/Application Support/Daedalic Entertainment GmbH/Barotrauma/Multiplayer"
SAVE_PATH="${SAVE_DIR}/${SAVE_NAME}"
SAVE_CDATA_PATH="/Users/`whoami`/Library/Application Support/Daedalic Entertainment GmbH/Barotrauma/Multiplayer/${CAMP_NAME}_CharacterData.xml"
NOW="$(date)"
BACKUP_DIR="${BACKUP_ROOT}/${NOW}"
BACKUP_FILE="${BACKUP_ROOT}/${NOW}/${SAVE_NAME}"
WORKSPACE="/tmp/${NOW}"
OLD_SAVE_HASH=`md5sum --quiet "${SAVE_PATH}"`

echo "Back up previous save in '${BACKUP_DIR}'..."
mkdir "${BACKUP_DIR}"
cp "${SAVE_PATH}" "${SAVE_CDATA_PATH}" "${BACKUP_DIR}"

echo "Copy save into temporary workspace..."
mkdir -p "${WORKSPACE}"
cp "${SAVE_PATH}" "${WORKSPACE}"

echo "Decompress the save and remove it from workspace..."
cd "${WORKSPACE}"
dotnet run --project "${COMPRESS_CLI}" decompress "${WORKSPACE}/${SAVE_NAME}"
rm "${WORKSPACE}/${SAVE_NAME}"

echo "Replace the sub in save directory..."
cp "${SUB_PATH}" "${WORKSPACE}/${SAVE_DIR_NAME}/"

echo "Compress the save..."
dotnet run --project "${COMPRESS_CLI}" compress "${WORKSPACE}/${SAVE_DIR_NAME}"

echo "Copy compressed save back to the game..."
cp "${WORKSPACE}/${SAVE_NAME}" "${SAVE_PATH}"

NEW_SAVE_HASH=`md5sum --quiet "${SAVE_PATH}"`
echo "Old save hash: ${OLD_SAVE_HASH}"
echo "New save hash: ${NEW_SAVE_HASH}"

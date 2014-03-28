#!/bin/sh
# Script to build VIH 7.x-1.x
# Make sure the correct number of args was passed from the command line

if [ $# -eq 0 ]; then
  echo "Usage $0 target_build_dir"
  exit 1
fi

shift $((OPTIND-1))
MAKEFILE='build-vih.make'
TARGET=$1
# Make sure we have a target directory
if [ -z "$TARGET" ]; then
  echo "Usage $0 target_build_dir"
  exit 2
fi
CALLPATH=`dirname "$0"`
ABS_CALLPATH=`cd "$CALLPATH"; pwd -P`
BASE_PATH=`cd ..; pwd`

echo '    ooooooooo    '
echo '  o           o  '
echo ' o             o '
echo ' o             o '
echo '  o           o  '
echo '    o    ooooo   '
echo ''
echo '================='
echo '       VIH       '
echo '================='

echo "This command can be used to build the distribution."
echo "  [1] Build distribution at $TARGET (in release mode)"
echo "  [2] Build distribution at $TARGET (in development mode)"
echo "  [3] Exit without building"
echo "Selection:"
read SELECTION

if [ $SELECTION = "1" ]; then

  echo "Building VIH distribution..."
  DRUSH_OPTS='--no-cache'

elif [ $SELECTION = "2" ]; then

  echo "Building VIH distrbution..."
  DRUSH_OPTS='--working-copy --no-gitinfofile --no-cache'

elif [ $SELECTION = "3" ]; then

  echo "Exiting without building..."
  exit 1
else
 echo "Invalid selection."
 exit 0
fi

# Temp move settings
if [ -f "$TARGET/sites/default/settings.php" ]; then
  echo "\nBacking up settings.php..."
  mv "$TARGET/sites/default/settings.php" settings.php
fi

# Verify the make file
set -e
echo 'Verifying make...'
drush verify-makefile

# Remove current drupal dir
echo 'Wiping Drupal directory...'
rm -rf "$TARGET"

# Do the build
echo 'Running drush make...'
drush make $DRUSH_OPTS "$ABS_CALLPATH/$MAKEFILE" "$TARGET"
set +e

# Build Symlinks
echo 'Setting up symlinks...'
DRUPAL=`cd "$TARGET"; pwd -P`
ln -s /opt/files/vih_dk "$DRUPAL/sites/default/files"

# Update existing distribution.
if [ -f "$BASE_PATH/settings.php" ]; then

  # Restore settings
  echo 'Restoring settings...'
  ln -s "$BASE_PATH/settings.php" "$DRUPAL/sites/default/settings.php"

  # Clear caches and Run updates
  cd "$DRUPAL"
  echo 'Clearing caches...'
  drush cc all;
  echo 'Running updates...'
  drush updb -y;
  echo 'Reverting all features...'
  drush fra -y;
  drush cc all;
  echo 'Build complete.'
fi

#!/bin/sh
# Script to rebuild the Panopoly installation profile
# This command expects to be run within the Panopoly profile.
# To use this command you must have `drush make` and `git` installed.

if [ -f drupal-org.make ]; then

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

  echo "\nThis command can be used to rebuild the installation profile in place.\n"
  echo "  [1] Rebuild profile in place in release mode"
  echo "  [2] Rebuild profile in place in development mode (with .git working-copy)\n"
  echo "Selection: \c"
  read SELECTION

  if [ $SELECTION = "1" ]; then

    echo "Building VIH install profile..."
    drush make --no-core --no-gitinfofile --contrib-destination=. drupal-org.make

  elif [ $SELECTION = "2" ]; then

    echo "Building VIH install profile..."
    drush make --working-copy --no-core --no-gitinfofile --contrib-destination=. drupal-org.make

  else
   echo "Invalid selection."
  fi
else
  echo 'Could not locate file "drupal-org.make"'
fi

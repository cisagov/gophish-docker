#!/usr/bin/env bash

# bump_version.sh (show|major|minor|patch|prerelease|build)

set -o nounset
set -o errexit
set -o pipefail

VERSION_FILE=src/version.txt
<<<<<<< HEAD
DOCKER_COMPOSE_FILE=docker-compose.yml
=======
README_FILE=README.md
>>>>>>> ce74596cede721a672a18d2d1712bc0b360b8ea0

HELP_INFORMATION="bump_version.sh (show|major|minor|patch|prerelease|build|finalize)"

old_version=$(sed -n "s/^__version__ = \"\(.*\)\"$/\1/p" $VERSION_FILE)

if [ $# -ne 1 ]
then
  echo "$HELP_INFORMATION"
else
  case $1 in
    major|minor|patch|prerelease|build)
      new_version=$(python -c "import semver; print(semver.bump_$1('$old_version'))")
      echo Changing version from "$old_version" to "$new_version"
      tmp_file=/tmp/version.$$
      sed "s/$old_version/$new_version/" $VERSION_FILE > $tmp_file
      mv $tmp_file $VERSION_FILE
<<<<<<< HEAD
      sed "s/$old_version/$new_version/" $DOCKER_COMPOSE_FILE > $tmp_file
      mv $tmp_file $DOCKER_COMPOSE_FILE
      git add $VERSION_FILE $DOCKER_COMPOSE_FILE
      git commit -m"Bumping version from $old_version to $new_version"
=======
      sed "s/$old_version/$new_version/" $README_FILE > $tmp_file
      mv $tmp_file $README_FILE
      git add $VERSION_FILE $README_FILE
      git commit -m"Bump version from $old_version to $new_version"
>>>>>>> ce74596cede721a672a18d2d1712bc0b360b8ea0
      git push
      ;;
    finalize)
      new_version=$(python -c "import semver; print(semver.finalize_version('$old_version'))")
      echo Changing version from "$old_version" to "$new_version"
      tmp_file=/tmp/version.$$
      sed "s/$old_version/$new_version/" $VERSION_FILE > $tmp_file
      mv $tmp_file $VERSION_FILE
<<<<<<< HEAD
      sed "s/$old_version/$new_version/" $DOCKER_COMPOSE_FILE > $tmp_file
      mv $tmp_file $DOCKER_COMPOSE_FILE
      git add $VERSION_FILE $DOCKER_COMPOSE_FILE
      git commit -m"Bumping version from $old_version to $new_version"
=======
      sed "s/$old_version/$new_version/" $README_FILE > $tmp_file
      mv $tmp_file $README_FILE
      git add $VERSION_FILE $README_FILE
      git commit -m"Bump version from $old_version to $new_version"
>>>>>>> ce74596cede721a672a18d2d1712bc0b360b8ea0
      git push
      ;;
    show)
      echo "$old_version"
      ;;
    *)
      echo "$HELP_INFORMATION"
      ;;
  esac
fi

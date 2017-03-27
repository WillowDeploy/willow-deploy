#!/usr/bin/env bash

npm test

if [ $? -eq 0 ]
then
  echo "Elm tests run successfully."
else
  echo "Elm tests failed!" >&2
  exit 3
fi


pushd "featuretests"

echo "--------------------- javac -------------------"

echo "javac -version"
javac -version

echo "'which javac' = '$(which javac)'"

echo "JAVA_HOME = '$JAVA_HOME'"


./gradlew test

if [ $? -eq 0 ]
then
  echo "Feature tests tests run successfully."
else
  echo "Feature tests failed!" >&2
  exit 3
fi


popd

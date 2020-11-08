#!/bin/bash

function ut() {
  docker-compose down
  docker-compose run --rm migration
  docker-compose run --rm test
  test_code=${?}
  docker-compose down
  exit ${test_code}
}

case ${1} in
ut)
  ut
  ;;
esac

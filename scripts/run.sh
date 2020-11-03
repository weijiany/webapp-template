#!/bin/bash

function ut() {
  docker-compose down
  docker-compose run --rm migration
  docker-compose run --rm test
  docker-compose down
}

case ${1} in
ut)
  ut
  ;;
esac

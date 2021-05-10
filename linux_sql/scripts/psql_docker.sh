#!/bin/bash

#start docker daemon if it is not running already.
sudo systemctl status docker || systemctl start docker

#pull the postgres docker image
docker pull postgres

#save command line arguments as variables
user_action_arg=$1 # create | start | stop
db_username=$2
db_password=$3

#case statements: create | start | stop | invalid
case "$user_action_arg" in
  #create case
  "create")
    echo "Trying to create jrvs-psql container..."
      #check the number of arguments and see if username and password arguments are missing
      if  [ "$#" -ne 3 ] || [ "$db_username" == "" ] || [ "$db_password" == "" ];
      then
          echo "ERROR: Username or password missing. Exiting script."
          exit 1
      fi

      #check if 'jrvs-psql' container is already created, if so exit with 1
      container_is_created='docker ls -a -f name=jrvs-psql | wc -l'; #-f is to filter, wc -l prints length
      if [ "$container_is_created" -eq 2 ];
      then
        echo "ERROR: Container jrvs-psql already exists. Exiting program."
        exit 1
      fi

      #create a new docker volume
      docker volume create pgdata

      #create a container using psql image with name=jrvs-psql
      docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
       #What's $?
      exit $?
  ;;

  #start case
  "start")
    echo "Trying to start jrvs-psql container..."
    #check number of arguments
    if [ "$#" -ne 1 ];
    then
      echo "ERROR: Too many arguments! Exiting code."
      exit 1
    fi

    #check if docker container exists, if not exit with code 1
    container_is_created='docker ls -a -f name=jrvs-psql | wc -l';
    if [ "$container_is_created" -ne 2 ];
    then
      echo "ERROR: Container jrvs-psql does not exist! Exiting script. :("
      exit 1
    fi

    #start docker container jrvs-psql
    docker container start jrvs-psql
    echo "Docker container initialised successfully! :D"
  ;;

  #stop case
  "stop")
    echo "Trying to stop jrvs-psql container..."
    #check number of arguments
    if [ "$#" -ne 1 ];
    then
      echo "ERROR: Too many arguments! Exiting code."
      exit 1
    fi

    #check if docker container exists, if not exit with code 1
    container_is_created='docker ls -a -f name=jrvs-psql | wc -l';
    if [ "$container_is_created" -ne 2 ];
    then
      echo "ERROR: Container jrvs-psql does not exist! Exiting script. :("
      exit 1
    fi

    # stop docker container
    docker container stop jrvs-psql
    echo "Docker container jrvs-psql stopped successfully."
  ;;
  *)
    #invalid argument
  echo "ERROR: Argument 1 not provided or is invalid."
  exit 1
esac

exit 0;

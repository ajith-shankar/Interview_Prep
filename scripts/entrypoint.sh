#!/bin/bash

if [ "SPARK_MODE" = "master" ]; then
    ${SPARK_HOME}/sbin/start-master.sh
    tail -f ${SPARK_HOME}/logs/spark--org.apache.spark.deploy.master.Master-*.out
elif [ "SPARK_MODE" = "worker" ]; then
    ${SPARK_HOME}/sbin/start-worker.sh $SPARK_MASTER_URL
    tail -f ${SPARK_HOME}/logs/spark--org.apache.spark.deploy.worker.Worker-*.out
else
    echo "SPARK_MODE must be 'master' or 'worker'"
    exit 1
fi
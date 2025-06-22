#!/bin/bash

# Create base dir if they don't exist
# Fix: Correct date format
DATE=$(date +%Y%m%d)  # Was missing % before Y
mkdir -p /notebooks/{pyspark,sql,python}

# 1. PySpark files 
for i in {1..2}; do
    cat > "/notebooks/pyspark/pyspark_${DATE}_q${i}.py" <<EOL
from pyspark.sql import SparkSession

# Initialize Spark Session
spark = (
    SparkSession.builder.appName("Practice_20250622_Q1")
    .config("spark.sql.shuffle.partitions", "4")
    .config("spark.submit.deployMode", "client")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("ERROR")

# Code here


# Stop the session
spark.stop()
EOL
done


# 2. SQL files
for i in {1..2}; do
    cat > "/notebooks/sql/sql_${DATE}_q${i}.sql" <<EOL
--PostgreSQL connection setup
\\c interview_prep_db; --Connect to existing db

EOL
done

# 3. Python files
for i in {1..2}; do
    cat > "/notebooks/python/python_${DATE}_q${i}.py" <<EOL
# import statement
import pandas as pd

EOL
done

# Permissions
chmod -R 777 /notebooks

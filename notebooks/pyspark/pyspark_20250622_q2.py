from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder \
    .appName("Practice_20250622_Q2") \
    .config("spark.sql.shuffle.partitions", "4") \
    getOrCreate()

# Code here

spark.stop()

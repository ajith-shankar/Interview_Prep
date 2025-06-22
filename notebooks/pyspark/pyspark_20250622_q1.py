from pyspark.sql import SparkSession
from pyspark.sql.functions import lit, col, when

# Initialize Spark Session
# ...existing code...
spark = (
    SparkSession.builder.appName("Practice_20250622_Q1")
    .config("spark.sql.shuffle.partitions", "4")
    .config("spark.submit.deployMode", "client")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("ERROR")


# Code here
data = [
    (1, "Alice", None),
    (2, "Bob", 1),
    (3, "Carol", 2),
    (4, "Dave", 1),
    (5, "Eve", 2),
    (6, "Frank", 4),
]


schema = ["Id", "Name", "Boss"]

df = spark.createDataFrame(data, schema)
df.show()

result = (
    df.alias("emp")
    .join(df.alias("mgr"), on=[col("emp.Boss") == col("mgr.Id")], how="left")
    .select(
        col("emp.Id"),
        col("emp.Name").alias("empName"),
        when(col("mgr.Name").isNull(), lit("No Boss")).otherwise(col("mgr.Name")).alias("BossName")
    )
)

result.show()

# Stop the session
spark.stop()
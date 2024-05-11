import snowflake.connector
import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

# Snowflake connection parameters
conn_params = {
    "user": "isin.pesch@deel.com",
    "password": "isinpeschww1eP",
    "account": "xyb13578",
    "warehouse": "transforming",
    "database": "isinpeschww1eP_analytics",
    "schema": "dbt_isin_pesch"
}

# Establish the connection
conn = snowflake.connector.connect(**conn_params)

# Create a cursor object
cur = conn.cursor()

# SQL query to select data from your dbt table
sql_query = """
SELECT movie_occurence_count, avg_imdb_rating, avg_rt_rating, avg_revenue, avg_runtime, avg_imdb_votes
FROM isinpeschww1ep_analytics.dbt_isin_pesch.int_collaboration_network_features
"""

# Execute the query
cur.execute(sql_query)

# Fetch the results into a DataFrame
data = cur.fetch_pandas_all()

# Close the cursor and connection
cur.close()
conn.close()

# Handle missing values if necessary
data.fillna(data.mean(), inplace=True)

# Standardize the data
scaler = StandardScaler()
data_normalized = scaler.fit_transform(data)

# Apply PCA
pca = PCA(n_components=6)  # Adjust based on your specific needs
pca.fit(data_normalized)
weights = pca.explained_variance_ratio_

print("Weights based on PCA:")
for i, weight in enumerate(weights, 1):
    print(f"Component {i}: {weight:.4f}")

#1. Principal Component Analysis (PCA)
#PCA is a statistical technique that transforms the original variables into a new set of variables, which are linear combinations of the original variables. These new variables (principal components) are orthogonal and ranked according to the variance of data along them, which can be interpreted as the importance of the components. You can use the variance explained by each principal component to determine the weights.
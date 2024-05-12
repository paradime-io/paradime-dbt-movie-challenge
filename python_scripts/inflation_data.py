import snowflake.connector
import pandas as pd

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
SELECT imdb_id, revenue, date_trunc('year', release_date) as revenue_year
FROM isinpeschww1ep_analytics.dbt_isin_pesch.int_movies_mapping
WHERE 
    revenue is not null and
    revenue != 0 and
    revenue_year is not null
"""

# Execute the query
cur.execute(sql_query)

# Fetch the results into a DataFrame
data = cur.fetch_pandas_all()


# Read the CPI data from the CSV file
cpi_data = pd.read_csv("machine_learning/us_inflation_rates.csv", parse_dates=["date"])

# Calculate the yearly average inflation value
cpi_data["year"] = cpi_data["date"].dt.year
yearly_avg_cpi = cpi_data.groupby("year")["value"].mean().reset_index()


# Merge CPI data with movie revenue data based on the revenue_year
data["revenue_year"] = pd.to_datetime(data["REVENUE_YEAR"], format='%Y')  # Convert to datetime


merged_data = pd.merge(data, yearly_avg_cpi, how="left", left_on=data["revenue_year"].dt.year, right_on="year")

# Rename the column
merged_data.rename(columns={"value": "yearly_avg_cpi"}, inplace=True)

# Calculate the inflation factor for each revenue year
merged_data["inflation_factor"] = merged_data["yearly_avg_cpi"].iloc[-1] / merged_data["yearly_avg_cpi"]

# Adjust the revenue values using the inflation factor
merged_data["normalized_revenue"] = merged_data["REVENUE"] * merged_data["inflation_factor"]

# Output the normalized revenue data
print(merged_data[["IMDB_ID","revenue_year","REVENUE","inflation_factor","normalized_revenue"]])

# Convert DataFrame to a list of tuples
sample_data = [(row['IMDB_ID'], row['normalized_revenue']) for _, row in merged_data.iterrows()]

filtered_data = [row for row in sample_data if not any(isinstance(val, float) and pd.isna(val) for val in row)]

# SQL query to delete all rows from the table
delete_query = """
DELETE FROM movie_normalized_revenue
"""

# Execute the query to delete all rows
cur.execute(delete_query)

# Commit the transaction
conn.commit()

# SQL query to insert multiple rows into the table
insert_query = """
INSERT INTO movie_normalized_revenue (imdb_id, normalized_revenue)
VALUES
"""

# Extend the query with multiple sets of values
insert_query += ",".join(["(%s, %s)" for _ in range(len(filtered_data))])

# Execute the query with sample data
cur.execute(insert_query, [item for sublist in filtered_data for item in sublist])

# Commit the transaction
conn.commit()


# Close the cursor and connection
cur.close()
conn.close()

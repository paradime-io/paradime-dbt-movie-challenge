import twint
import pandas as pd
import nest_asyncio
import snowflake.connector

# Apply necessary fixes for running twint in Jupyter notebooks or similar environments
nest_asyncio.apply()

# Snowflake connection parameters
conn_params = {
    "user": "isin.pesch@deel.com",
    "password": "isinpeschww1eP",
    "account": "xyb13578",
    "warehouse": "transforming",
    "database": "isinpeschww1eP_analytics",
    "schema": "dbt_isin_pesch"
}
# Function to fetch movie titles from the database
def fetch_movie_titles():
    try:
        conn = psycopg2.connect(**db_params)
        cursor = conn.cursor()
        cursor.execute("SELECT title FROM your_table_name")  # Adjust SQL as needed
        titles = [row[0] for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return titles
    except Exception as e:
        print("Error accessing database:", e)
        return []

# Function to configure and run twint to fetch tweets
def fetch_tweets(keyword, limit=100):
    c = twint.Config()
    c.Search = keyword  # Set the search keyword, which is the movie title
    c.Limit = limit     # Maximum number of tweets to pull
    c.Pandas = True     # Enable Pandas integration
    c.Hide_output = True  # Hide the console output
    twint.run.Search(c)  # Run the search
    tweets_df = twint.storage.panda.Tweets_df  # Get the tweets as a DataFrame
    return tweets_df[['date', 'tweet']] if not tweets_df.empty else pd.DataFrame(columns=['date', 'tweet'])

# Fetch movie titles
movie_titles = fetch_movie_titles()

# DataFrame to store results
results_df = pd.DataFrame(columns=['Date', 'Tweet', 'Movie Title', 'Sentiment', 'Polarity', 'Subjectivity'])

# Fetch and analyze tweets for each movie title
for title in movie_titles:
    print(f"Fetching tweets for: {title}")
    tweets = fetch_tweets(title)
    for index, row in tweets.iterrows():
        polarity, subjectivity = TextBlob(row['tweet']).sentiment
        sentiment = "Positive" if polarity > 0 else "Negative" if polarity < 0 else "Neutral"
        results_df = results_df.append({'Date': row['date'], 'Tweet': row['tweet'], 'Movie Title': title, 'Sentiment': sentiment, 'Polarity': polarity, 'Subjectivity': subjectivity}, ignore_index=True)

# Optionally, display or save the results
print(results_df.head())  # Display the first few rows of the results DataFrame
# results_df.to_csv("tweet_sentiment_analysis.csv", index=False)  # Save to CSV
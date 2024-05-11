import snowflake.connector
from sqlalchemy import create_engine
from fuzzywuzzy import process
import rottentomatoes as rt

# Snowflake connection parameters
USER = 'isin.pesch@deel.com'
PASSWORD = 'isinpeschww1eP'
ACCOUNT = 'xyb13578'
WAREHOUSE = 'transforming'
DATABASE = 'isinpeschww1eP_analytics'
SCHEMA = 'dbt_isin_pesch'

# SQLAlchemy engine setup for Snowflake
def create_snowflake_engine():
    from snowflake.sqlalchemy import URL
    engine = create_engine(URL(
        user=USER,
        password=PASSWORD,
        account=ACCOUNT,
        warehouse=WAREHOUSE,
        database=DATABASE,
        schema=SCHEMA,
        role='your_role',  # Specify if needed
    ))
    return engine

def fetch_movie_titles(engine):
    # Fetching movie titles from the Snowflake database
    query = "SELECT title FROM isinpeschww1ep_analytics.dbt_isin_pesch.int_collaboration_network_features"
    with engine.connect() as connection:
        result = connection.execute(query)
        return [row['title'] for row in result]

def find_best_match(movie_title, candidates):
    # Use fuzzy matching to find the best match in the candidates
    best_match, score = process.extractOne(movie_title, candidates)
    if score > 85:  # Adjust threshold based on your accuracy requirements
        return best_match
    return None

def fetch_movie_info(title):
    try:
        movie = rt.Movie(title)
        print(f"Information for {title}:")
        print(movie)
    except Exception as e:
        print(f"Error fetching data for {title}: {e}")

def main():
    engine = create_snowflake_engine()
    movie_titles = fetch_movie_titles(engine)
    rt_movie_titles = ["List of all movie titles known to Rotten Tomatoes"]  # This should be fetched or defined somehow

    for title in movie_titles:
        matched_title = find_best_match(title, rt_movie_titles)
        if matched_title:
            fetch_movie_info(matched_title)
        else:
            print(f"No sufficient match found for {title}")

if __name__ == "__main__":
    main()

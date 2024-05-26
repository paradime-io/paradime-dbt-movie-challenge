import os
import zipfile
import json
import pandas as pd
import numpy as np
import snowflake.connector
import nltk
import matplotlib.pyplot as plt

from snowflake.connector.pandas_tools import write_pandas
from nltk.sentiment.vader import SentimentIntensityAnalyzer
#from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
from IPython.display import display
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
from dotenv import load_dotenv

'''
nltk.download([
    "names",
    "stopwords",
    "state_union",
    "twitter_samples",
    "movie_reviews",
    "averaged_perceptron_tagger",
    "vader_lexicon",
    "punkt",
])
'''

stopwords = nltk.corpus.stopwords.words("english")

list_of_columns = ['imdb_id', 'plot', 'overview', 'tagline', 'title', 'keywords']
# table_name = 'intermediate.int_science_fictions_joined'
table_name = 'intermediate.int_movies'

load_dotenv()

conn_params = {
    'user': os.getenv('USER'),
    'password': os.getenv('PASSWORD'),
    'account': os.getenv('ACCOUNT'),
    'warehouse': os.getenv('WAREHOUSE'),
    'database': os.getenv('DATABASE'),
    'schema': os.getenv('SCHEMA')
}

analyzer = SentimentIntensityAnalyzer()


def read_snowflake_table_to_df(conn_params, tablename, list_of_columns):

    print('Setting up snowflake connection...')
    # Snowflake connection parameters
    conn = snowflake.connector.connect(**conn_params)
    
    '''
    conn = snowflake.connector.connect(
        user='istvan.mozes.90@gmail.com',
        password='istvanmozes9041bng',
        account='xyb13578',
        warehouse='TRANSFORMING',
        database='ISTVANMOZES9041BNG_ANALYTICS',
    )
    '''

    # Create a cursor object
    cur = conn.cursor()

    selected_columns = ','.join(list_of_columns)

    print(f'Query table {tablename}')
    # Execute the query
    cur.execute(f"SELECT {selected_columns} FROM {tablename}")

    # Fetch all rows from the result set
    rows = cur.fetchall()

    # Close the cursor and connection
    cur.close()
    conn.close()

    print('Convertnig table {tablename} to a dataframe...')
    # Convert the result into a Pandas DataFrame
    df = pd.DataFrame(rows, columns=list_of_columns)
    df = df.dropna(how='all')
    print(f'Table {tablename} is converted to a dataframe.')
    return df

def preprocess_text(text):
    # Tokenize the text
    if not pd.isna(text):
        tokens = word_tokenize(text.lower())
    else: return None

    # Remove stop words
    filtered_tokens = [token for token in tokens if token not in stopwords]

    # Lemmatize the tokens
    lemmatizer = WordNetLemmatizer()
    lemmatized_tokens = [lemmatizer.lemmatize(token) for token in filtered_tokens]

    # Join the tokens back into a string
    processed_text = ' '.join(lemmatized_tokens)

    return processed_text

def frequency(text, top_n):
    words: list[str] = nltk.word_tokenize(text)
    fd = nltk.FreqDist(words)
    return fd.most_common(top_n)

def concat_all_rows_in_column(df_column):
    df_column_filtered = df_column.dropna()
    print('Preprocessing data...')
    #print(f'Creating {df_column} list...')
    all_row_list = df_column_filtered.tolist()
    all_row_concat = ' '.join(all_row_list)
    #print(f'Done creating {df_column} list...')

    return all_row_concat


def get_snowflake_column_definition(df):
    print('Getting snowflake column definition...')
    dtype_mapping = {
        'int64': 'INTEGER',
        'float64': 'FLOAT',
        'object': 'STRING',
        'bool': 'BOOLEAN',
        'datetime64[ns]': 'TIMESTAMP_NTZ'
    }
    column_definitions = []
    for column in df.columns:
        col_type = str(df[column].dtype)
        snowflake_type = dtype_mapping.get(col_type, 'STRING')
        column_definitions.append(f"{column} {snowflake_type}")
    return ", ".join(column_definitions)

def create_table_if_not_exists(conn, table_name, column_definitions):
    print(f'Creating table {table_name}...')
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS {table_name} (
        {column_definitions}
    )
    """

    with conn.cursor() as cursor:
        cursor.execute(create_table_query)
        print(f"Table {table_name} checked/created successfully.")


def upload_df_to_snowflake_table(conn_params, df, table_name):

    print('Uploading dataframe to snowflake...')
    # Create a connection to Snowflake
    try:
        # Create a connection to Snowflake
        conn = snowflake.connector.connect(**conn_params)

        # Define the table structure
        column_definitions = get_snowflake_column_definition(df)

        # Create the table if it doesn't exist
        create_table_if_not_exists(conn, table_name, column_definitions)

        # Upload the DataFrame to Snowflake
        success, nchunks, nrows, output = write_pandas(conn, df, table_name, quote_identifiers=False)

        # Check the results
        if success:
            print(f"Successfully uploaded {nrows} rows to {table_name}.")
        else:
            print("Failed to upload DataFrame to Snowflake.")

    except snowflake.connector.errors.MissingDependencyError as e:
        print(f"Missing optional dependency error: {e}")
        print("Please ensure pandas is installed in your environment.")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        conn.close()


def get_sentiment(text):
    if not pd.isna(text):
        score = analyzer.polarity_scores(text)
    else: return None
    # sentiment = 1 if scores['pos'] > 0 else 0

    return score




def main(conn_params, table_name, list_of_columns): 
    pd.set_option('display.max_colwidth', None)
    # Convert the result into a Pandas DataFrame
    print('Bigquery to dataframe...')
    df = read_snowflake_table_to_df(conn_params,table_name,list_of_columns)

    # Preprocess the text
    list_of_columns.remove('imdb_id')
    for column in list_of_columns:
        print(f'Preprocessing {column}...')
        df['preprocessed_' + column] = df[column].apply(preprocess_text)
        print(f'Column preprocessed_{column} is added to dataframe.')
        df['polarity_score_' + column] = df[column].apply(get_sentiment)
        print(f'Column polarity_score_{column} is added to dataframe.')
        df['compound_' + column] = df['polarity_score_' + column].apply(lambda x: x['compound'] if x is not None else None)
        print(f'Column compound_{column} is added to dataframe.')
    
    # load dataframe to warehouse
    # upload_df_to_snowflake_table(conn_params, df, 'staging.stg_science_fictions_nlp')
    upload_df_to_snowflake_table(conn_params, df, 'staging.stg_all_movies_nlp')

    new_columns_lod = []   
    for column in list_of_columns:
        new_columns_lod.append({
            'column_name': 'concatenated_' + column, 
            'concatenated_column': concat_all_rows_in_column(df['preprocessed_' + column]),
            'top_n_word':  0})
        
    for column in new_columns_lod:
        column['top_n_word'] = frequency(column['concatenated_column'], 20)
        words = column['concatenated_column'].split()
        finder = nltk.collocations.BigramCollocationFinder.from_words(words)
        column['top_n_collocations'] = finder.ngram_fd.most_common(5)
    

    # Convert list of dictionaries to DataFrame
    df_freq = pd.DataFrame(new_columns_lod)
    print('Calculating word frequency distribution...')
    df_freq['top_n_word'] = df_freq['top_n_word'].apply(lambda x: json.dumps(x))
    df_freq['top_n_collocations'] = df_freq['top_n_collocations'].apply(lambda x: json.dumps(x))
    # df_freq = df_freq[['column_name' , 'top_n_word']]



    # upload_df_to_snowflake_table(conn_params, df_freq, 'staging.stg_word_frequency')
    upload_df_to_snowflake_table(conn_params, df_freq, 'staging.stg_all_movies_word_frequency')

    for column in new_columns_lod:
        # Create and generate a word cloud image:
        wordcloud = WordCloud(width=1600, height=800).generate(column['concatenated_column'])

        # Display the generated image:
        plt.imshow(wordcloud, interpolation='bilinear')
        plt.axis("off")

        # Save the figure
        custom_filename = 'all_movies_' + column['column_name'] + '_wordcloud.png'
        print(f'Wordcloud created as {custom_filename}.')
        plt.savefig(custom_filename, format='png', bbox_inches='tight', pad_inches=0)

    return df
    

# Call the main function
if __name__ == "__main__":
    main(conn_params, table_name, list_of_columns)
# dbt™ Data Modeling Challenge - Movie Edition

Welcome to the [[Paradime dbt™ Data Modeling Challenge - Movie Edition](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition)])!

## Table of Contents
1. [Getting Started](#getting-started)
   - [Registration and Verification](#step-1-registration-and-verification)
   - [Account Set-Up](#step-2-account-set-up)
   - [Paradime Account Configuration](#step-3-paradime-account-configuration)
   - [Kickstart Your Project](#step-4-kickstart-your-project)
2. [Competition Details](#competition-details)
3. [Building Your Project](#building-your-project)
4. [Example Submission](#example-submission)

---

## Getting Started

### Step 1: Registration and Verification
- **Submit Your Application**: Fill out the [[registration form](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-registration-form)].
- **Verification by Paradime**: We'll review your application against the [[entry requirements](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-how-it-works-2)].

### Step 2: Account Set-Up
After verification, you'll receive two emails from Paradime:
1. **Snowflake Account Credentials**: Contains your Snowflake account details. Search for an email with subject line "*Start Your Movie Data Modeling Challenge – Your Snowflake Credentials*."
2. **Paradime Platform Invitation**: An invitation to access the Paradime Platform. Search for an email with the subject line "*[Paradime] Activate your account*."

### Step 3: Paradime Account Configuration
- **Access Paradime**: Use the provided credentials to log into your account. Join the Paradime workspace using the invite email.
- **Snowflake Integration**: Add Snowflake credentials (Username, Password, Role, Database) to Paradime.
- **Act Fast - Limited Time Activation**: The links to activate your Paradime account expire within 24 hours!

Note: A step-by-step tutorial is available in you Snowflake credentials email, "*Start Your Movie Data Modeling Challenge – Your Snowflake Credentials*".

### Step 4: Kickstart Your Project
- **Create a New Branch**: Open the Paradime Editor and create a new branch. Your branch name should follow this format: "movie-<your_email>"
- **Start Developing**: Begin crafting SQL queries, developing dbt™ models, and generating insights!

Note: If you login to snowflake, your default role is public. Swith your role to the one we provide in the snowflake email (ex. "[your_name]_transformer". 

**Need Help?**: Check out [[this step-by-step video tutorial](https://app.arcade.software/share/7kRyaYbPoGc5ofmJfmvY), and join the #movie-competiton channel on [Slack](https://paradimers.slack.com/join/shared_invite/zt-1mzax4sb8-jgw~hXRlDHAx~KN0az18bw#/shared-invite/email) for assistance.

---

## Competition Details
- **[[Entry Requirements](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-how-it-works-2)**  
- **[[Competition Deliverables](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-how-it-works-2)**  
- **[[Judging Criteria](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-how-it-works-2)**

---
## Building Your Project

Now that you're set up, you have until May 26th, 2024 to complete and submit your project!

### Step 1: Getting to Know the Paradime

- **The Paradime Editor**: Dive into the Paradime Editor with this step-by-step, [[interactive guide](https://app.arcade.software/share/7kRyaYbPoGc5ofmJfmvY)]. It's designed to familiarize you with the core functionalities and of the editor, and get your familiar with the Project. You can also watch our youtube videos:
   - [All features in our intuitive IDE Apps Panel](https://www.youtube.com/watch?v=wQtIn-tnnbg)
   - [AI-enabled IDE for dbt™ development | DinoAI | Paradime.io](https://www.youtube.com/watch?v=-WG4JUv3sI8)
- **Paradime Help Docs**: For a comprehensive understanding of all the features and how to make the most of Paradime for your project, explore the [Paradime Help Docs](https://docs.paradime.io/app-help/welcome-to-paradime.io/readme).

### Step 2: Getting to Know the Movie Data

Paradime has pre-loaded your Snowflake account with 3 Movie datasets. These data sets contain roughly 17,000 rows of details Movie and TV Show data. 
Please understand that these data sets are not entirely accurate; They're are simply a starting point - you will need to bring in your own datasets to truly excel in this challenge. 
- **In Snowflake**: Directly explore the datasets in [Snowflake](https://app.snowflake.com/kbuwhsf/xrb98600) for hands-on analysis.
- **GitHub Repository Resources**:
  - [Staging Files](https://github.com/paradime-io/paradime-dbt-movie-challenge/tree/main/models/sources): These files provide a preliminary view and structure of the datasets available in this repository.
  - [schema.yml File](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/schema.yml): This file contains schema definitions, helping you understand the data models and their relationships.
- **Paradime Catalog UI**: Use the [Paradime Catalog UI](https://app.paradime.io/catalog/search) for an interactive exploration of the datasets, featuring intuitive search and navigation.

### Step 3: Generating Insights

Your primary goal is to construct dbt™ models that unearth compelling insights, captivating Movie fans. These three datasets are your starting point, and as you bring in additional data, the possibilities for discovery are virtually limitless. This is your playground to innovate and explore the depths of Movie and TV data.

Before diving in, ensure you're familiar with the [Judging Criteria](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-how-it-works-2) so you've got a chance to win the [$500-$1500 Amazon gift cards](https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-whats-in-it-for-you)!

https://www.paradime.io/dbt-data-modeling-challenge-movie-edition#div-whats-in-it-for-you

#### Need a spark of inspiration? 
Check out the [example submission](https://github.com/paradime-io/paradime-dbt-nba-data-challenge?tab=readme-ov-file#example-submission) from Paradime's recent NBA Data Modeling Challenge, as well as the winning submissions from the NBA data modeling Challenge:
- First Place - [Spence Perry's Submission](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/nba-spence-perry/README.md)
- Secobnd Place - [Chris Hughes' Submission](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/nba-cahughes95-gmail-com/README.md)
- Third Place - [István Mózes' Submission](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/nba-istvan-mozes-90-gmail-com/README.md)

Additionally, Here are some questions you might consider answering:

- **Highest grossing films of all time**:
      - Data Required: *[omdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_omdb_movies.sql)* and/or *[tmdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_tmdb_movies.sql)*. 
     You might also consider bringing in third party data to understand highest grossing films by country.
- **Highest/lowest ROI films of all time**:
      - Data Required: *[omdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_omdb_movies.sql)* and/or *[tmdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_tmdb_movies.sql)*. 
     See columns "budget", "revenue", and "box office".
- **Actors who appear in most films**:
      - Data Required: *[omdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_omdb_movies.sql)*, column "actors"
- **Highest grossing directors and writers**:
      - Data Required: *[omdb_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/main/models/sources/stg_omdb_movies.sql)*, column "director" abd "writer"

### Creating Data Visualizations

### Submitting Your Project
**Submission Deadline:** May 26th, 2024
Once your project is complete, please submit the following materials to Parker Rogers (parker@paradime.io) with Subject Line "<your_name> - Movie Data Modeling Challenge Submission":
- **GitHub Branch**: Send the link to your GitHub branch containing your dbt™ models.
- **README.md**: Include a README file that narrates your project's story, methodology, and insights. Check out this [example README](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/main/README.md#example-submission) from our previous NBA Data Modeling challenge. 
- **Data Visualizations and Insights**: Showcase your findings, ideally within your README.md. For inspiration, refer to these [example visualizations](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/blob/main/README.md#visualizations) from  our previous NBA Data Modeling challenge. 

If you're having issues submitting your project, watch this [interactive tutorial](https://app.arcade.software/share/TqmPGQAdXjopPO9LWdnz).

We look forward to seeing your creative and insightful analyses!

# Example Submission template
Here's an example project that fulfills all requirements and would be elligble eligible for cash prizes. Feel free to use this template for your submission. We also recommend diving into the the [winner's submissions](#need-a-spark-of-inspiration) from our recent NBA Data Modeling Challenge for inspiration. 

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
   - [Data Sources and Data Lineage](#data-sources-and-data-lineage)
4. [Visualizations](#visualizations)
   - [Vizualization #1](vizualization-1)
   - [Vizualization #2](Vizualization-2)
   - [Vizualization #3](Vizualization-3)
   - etc
5. [Conclusions](#conclusions)

## Introduction
A simple intro. Example - "Explore my project for the _dbt™ data modeling challenge - Movie Edition_, Hosted by [Paradime](https://www.paradime.io/)! This project dives into the analysis and visualization of Movie and TV data!"

## Data Sources and Data Lineage
My analysis leverages four key data sets:
- *data set name #1*
- *data set name #2*
- *data set name #3*
- *data set name #4*

Data Lineage
[Image]

### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **Other tool(s) used** and why.

### Data Lineage
- Copy and paste your data lineage image here. Watch this [YouTube Tutorial](https://youtu.be/wQtIn-tnnbg?feature=shared&t=135) to learn how. 

## Visualizations

### vizualization 1
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights

### vizualization 2
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights

### vizualization 3
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights


## Conclusions
Share a clear and concise conclusion of your findings! 

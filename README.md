## Table of Contents
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
  - [Data Sources](#data-sources)
  - [Data Lineage](#data-lineage)
- [Methodology](#methodology)
    - [Tools Used](#tools-used)
- [Analysis](#analysis)
  - [Genres overview 🏞️](#genres-overview-️)
  - [Recent genres dynamics 🧨](#recent-genres-dynamics-)
  - [Profitability 💰](#profitability-)
  - [Profit distribution 📈](#profit-distribution-)
  - [The Dirty Thirty 🎯](#the-dirty-thirty-)
  - [Superheroes 🦸](#superheroes-)
  - [Big budget big score 🙅‍♂️](#big-budget-big-score-️)
- [Conclusions 🎬](#conclusions-)
- [Appendices](#appendices)

## Introduction
In this project I will analyze movie trends throughout history. I will try to understand what makes a movie profitable.
This project is part of the _dbt™ data modeling challenge - Movie Edition_, Hosted by [Paradime](https://www.paradime.io/).

Each section starts with a discussion, followed by the visualizations and data modelling details (for the more technical audience) in a block quote.

The analysis is intended as a Lightdash dashboard which provides a better layout and more interactive options. It looks better there. See the screenshot [here](assets/dashb.png).

### Data Sources
My analysis leverages four key data sets:
- OMDB movies [dataset](https://www.omdbapi.com/)
- TMDB movies [dataset](https://developer.themoviedb.org/docs/getting-started)
- Inflation data from the [Federal Reserve Bank of Minneapolis ](https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1913-)

### Data Lineage

![chart](/assets/lineage.png)

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **[dbt_docstring](https://github.com/anelendata/dbt_docstring)** to generate documentation from docstrings.

## Analysis

### Genres overview 🏞️

Let's jump right in and check out how the number of movies produced in different genres has shot up over the years. Good news first—the movie industry is booming as we're seeing more and more films being made each year. The mix of genres is pretty much staying the same, except for a few standouts.

It's tough to see the differences between all the genres on the Absolute Chart. Let’s try looking at it another way. If we check out the percentage of total films each genre contributes over time, we get a clearer picture. Here's the deal: <span style="color:#673ab7">**drama**</span> is always the star of the show, keeping its lead safe and sound. But here's a surprise—<span style="color:#ffeb3b">**comedies**</span> used to top the charts, but <span style="color:#008080">**documentaries**</span> have sneaked in and moved ahead, beating <span style="color:#ffeb3b">**comedies**</span> in the race.
This could be because of those true crime movies that are very popular on streaming platforms. Or perhaps we’re seeing the return of the old direct-to-video strategy 🤔

It's no surprise that <span style="color:#9e9e9e">**war**</span> movies hit their highest points right after major wars. And <span style="color:#8b4513">**Westerns**</span>? They've taken their last ride into the sunset, now just a fond memory of the olden cinema days.

| Genre popularity by Decade. Absolute values|
| :-: |
| ![chart](/assets/aqotgf.png)|
| *All Quiet on the Genres Front (2022)* |

| Genre popularity by Decade. Relative values|
| :-: |
| ![chart](/assets/histg.png)|
| *Honey, I Shrunk the Genres (1989)*|

> **Technical details**
> 
> Firstly, I acknowledge that the abundance of colors can be somewhat overwhelming. I have provided a rationale for mapping genres to colors to serve as a mnemonic in [the appendix](#appendix).
> 
> The dataset I used combines data from both OMDB and TMDB. Because specific features were unique to each one, the [final model](models/marts/movies.sql) is an *inner join* of the two. This visualization utilizes a [targeted model](models/presentation/pres_genres_by_decade_scaled_values.sql), grouped by decade.
> 
> A challenge arises when a single movie belongs to multiple genres. For the purpose of this model, I have divided each movie into all the genres to which it belongs. For instance, a **Comedy-Drama** would be counted as 0.5 **Comedy** and 0.5 **Drama**, ensuring the totals remain constant. This method is effective as the distribution of genres per movie is equal across decades (see the [analysis](analyses/genres_per_movie_by_year.sql)).
> 
> Short films are intentionally omitted since 'short' is not a genre, and a short film can still belong to a specific genre. TV movies (including Game Show, Talk Show) are also excluded, as they fall into a different category entirely.
> 
> The analysis is restricted to the years 1920-2023 due to data availability. The last decade, which is not yet complete, is scaled accordingly, assuming a linear distribution of movies throughout the decade.

### Recent genres dynamics 🧨

Let's zoom in to see how the dynamics between various genres in the last 20 years. To do that, in a cineaste twist on the BCG Matrix, we compare the percentage of movies that belong the to given genre in the last 10 years (2014-2023) vs the growth of that genre between the previous 10 years (2004-2013) and the last 10 years (2014-2023). The reference lines are determined by the median genre participation (2% on the x-axis) and the overall growth in the number of movies between the decades (55% on the y-axis).

Sticking with the BCG terminology:
- ⭐️ <span style="color:#cddc39">**Thriller**</span> and <span style="color:#b71c1c">**Horror**</span> are our stars, 
- 🐄 <span style="color:#ffeb3b">**Comedy**</span>, <span style="color:#f06292">**Romance**</span>, and <span style="color:#f44336">**Action**</span> are our cash-cows, 
- 🐕 <span style="color:#e91e63">**Musical**</span> is the dog, and 
- ❓ <span style="color:#263238">**Mystery**</span>, tellingly, is a question mark. 

It seems like <span style="color:#f44336">**Action**</span> packed <span style="color:#ffeb3b">**Comedies**</span> with a bit of a <span style="color:#cddc39">**Thrill**</span>, would be a straight way to make a profitable movie. Let's examine the movie market more closely in the next section.

| Genre popularity by Decade.  Relative values|
| :-: |
| ![chart](/assets/bcgm.png)|
| *Box-office Category Growth Matrix (1999)*|

> **Technical details**
> 
> The, previously discussed, fact that movies and genres have a 1:M relationship might distort the picture, but should still allow us to draw conclusions. 

### Profitability 💰

Now that we’ve mapped out the genre landscape, let's shift gears and examine how much bang for your buck movie production tends to generate. However, it's important to note that only around 2.5% of the movies in our dataset have available budget and revenue information. Consequently, our analysis is limited to these films.

Immediately we see the significant drops in movie production and revenues that coincide with major global events like pandemics and wars. Nevertheless, the film industry has consistently demonstrated resilience, bouncing back each time, demonstrating its ability to weather any popcorn apocalypse.

Another observation involves the dramatic spikes during the industry's early years, such as the one in 1946 caused by Orson Welles's *The Stranger*. Despite its critical acclaim (with a 97% rating on Rotten Tomatoes), it did not rank among the most profitable films ever made. This anomaly resulted from a data entry error overselling the movie's revenue tenfold in the source dataset. We will limit our analysis to more recent, better quality data for the rest of this journey.

With the rapid increase in the number of movies produced and relatively stable **average** profits, we can suggest a tentative theory: the film industry operates on a winner-takes-all principle, a superstar model where a select few films rake in massive profits while the majority struggle to break even. Let's try to validate this hypothesis!

| Average budget, revenue, and profit per movie in 2023$ (left-hand y-axis), number of movies made (right-hand y-axis) by Year|
| :-: |
| ![chart](/assets/tlote.png)|
| *The Lord of the Earnings (2001)*|

> **Technical details**
> 
> Since the analysis spans centuries, I needed to adjust for inflation to ensure the comparability of the dollar values. All values are in 2023 USD equivalent.  

### Profit distribution 📈

Indeed, movie profits are dispersed in a **very** unequal manner. The distribution has a very long tail. The Gini coefficient, a measure of inequality, for the movie industry's revenues over the past two decades sits at 90%. The vast majority of films either suffer a loss or eke out a minor profit. However, at the opposite end of the histogram, we find the heavy-hitters – those rare cinematic blockbusters that rake in colossal profits.

This begs the question: What factors contribute to a movie's profitability? Could it hinge on the director's name splashed on the poster? Let's investigate further and delve into the role of directors in this superstar-driven film market.

| Histogram: Number of movies in each of the profit (or loss) bins. First and last bins grouped. Values in 2023$ |
| :-: |
| ![chart](/assets/tgtbatp.png)|
| *The Good, The Bad, and The Profitable (1966)*|

> **Technical details**
> 
> See the [analysis](analyses/revenue_gini_coefficient.sql) for the Gini coefficient.

### The Dirty Thirty 🎯

The first thing to note here is that even the best have their bad days! Most of these hotshot directors have had a few flops, but these little blips on the radar hardly muddy their overall success. Kind of like a self-fulfilling prophecy, right? People line up for big names, causing these directors to churn out wins consecutively. 

Now, losses are bound by budget constraints, while profits... well, the sky is the limit! And it seems like the directors do exploit that!

Upon closer examination, there seems to be a common theme. Apart from some household names, it’s hard to miss the superhero movies craze. Let's dig into it. Superhero movies, a sign of our times, deserve their own section! 

| Total profits (and losses) by the top 30 most profitable Directors. Values in 2023$ |
| :-: |
| ![chart](/assets/fafdm.png)|
| *For a Few Dollars More (1965)*|

### Superheroes 🦸

Let's jump on the opportunity to use a pie chart. Over the past 15 years, superhero movies only constituted 0.75% of all films produced, yet they generated over 10% of total profits—a 13-fold overrepresentation. This statistic may seem discouraging for aspiring artists. Well, they can take solace in the fact that the remaining 90% of profits are still up for grabs.

But, is shooting the next installment of a popular franchise the only way to achieve financial success? Maybe we should place more emphasis on how the audience perceives the film. In the next (and last) section, we will investigate the correlation between large budgets and critical acclaim.

| Proportion of movies released  | Proportion of profits earned|
| :-: | :-: |
| ![chart](/assets/atotp.png)| ![chart](/assets/tib.png)|
| *A Tale of Two Pies (1935)*| *The Incredible Bulk (2008)*|

> **Technical details**
> 
> The profits are netted by the losses which might be skewing the results.
> 
> I couldn't resist using a pie-chart. This is probably the only legitimate usage for it--to illustrate approximate proportion between two vastly different values.

### Big budget big score 🙅‍♂️

The movie budget is contrasted here with a Combined Rating, a metric calculated by bringing the ratings from various sources to a common scale and calculating their average. 

The message here is encouraging. It is not enough to pump in a lot of money into a movie to achieve critical acclaim. For the 500 most popular films the R<sup>2</sup> was a mere 10%. There are plenty of examples of movies with very small budgets that were highly rated by the audience and critics.


| Budget (2023$) vs Combined Rating |
| :-: |
| ![chart](/assets/ncfbb1.png)|
| *No Country for Big Budgets (2007)*|

> **Technical details**
> 
> For the R<sup>2</sup> calculation see the [analysis](analyses/r_squared_budget_vs_rating.sql)
 
## Conclusions 🎬

The movie industry is constantly evolving. Some genres like drama and documentaries are gaining popularity, while others like Westerns are losing their appeal. Superhero movies are standing out as big money-makers, even though they make up a small portion of the total films produced.

Profits in the movie industry follow a pattern where a few blockbuster hits make a lot of money, while most films struggle to make a profit. Directors play a key role in this system, with some consistently making profitable movies despite occasional failures.

Although many may think that spending more money leads to critical success, our analysis shows that this isn't always true. The audience's opinion and critical reception of a film depend on factors beyond just its budget. Success in the movie industry relies on factors like storytelling, direction, and how well a film connects with its audience.

As the movie industry keeps changing and responding to audience tastes, understanding these trends will be crucial for filmmakers, producers, and studios looking to succeed in a competitive and evolving industry.

A final word of recommendation for movie producers: keep making great movies regardless of the budget at hand.

A final word of recommendation for moviegoers: vote with your dollar. Do yourself a service and don't watch bad movies.

## Appendices

<details>

<summary>Further research ideas</summary>


Runtime
- Analyze effect of movie runtime on ratings, box office.

Global Influence
- Geographic heat map: Movie production, box office by country.
- Analyze impact of language, culture on movie success.
Financial Insights

Revenue vs. Awards
- Scatter plot: Correlation between box office and awards/nominations.

Profit Trends
- Line graph: Box office revenue across years.
- Scatter plot: Correlation between IMDB votes and box office earnings.
- Analyze peak revenue times: heat map calendar or line graph.

Director Impact
- Bar graphs: Box office hits and average IMDB ratings by director.
Industry Analysis

Production Leaders
- Bar graphs/pie charts: Most productive directors, actors.

Director Effectiveness
- Director impact on ratings, revenue, awards.

Bankability
- Bar chart: Box office returns by actors/directors.

Career Analysis
- Heatmap: Directors' and actors' performance over career stages. Career momentum.
- Impact of node centrality and the Bacon's law

Breakthroughs, Oscars Impact & Career Boost
- Line chart: Box office pre/post breakthrough role.
- Analyze career trajectory post breakout role.
- What makes a breakthrough movie

Star Maker Directors
- Line graphs: Actor careers post major role with specific directors.

</details>

<details>

<summary>On the color selection</summary>

In the data visualizations above, each movie genre is represented by a specific color that embodies the mood and theme commonly associated with the genre. I used a brand new feature of Lightdash that allows for persistent dimensions colors. Here's how each of the genres are color-coded:

- **Comedy**: <span style="color:#ffeb3b">**Yellow**</span> represents the light, cheerful themes typically found in comedy films.
- **War**: <span style="color:#9e9e9e">**Gray**</span> encapsulates the gritty, somber moods often depicted in war movies.
- **Drama**: <span style="color:#673ab7">**Dark Purple**</span> reflects the deep, intense emotional experiences typical of dramatic storytelling.
- **Western**: <span style="color:#8b4513">**Saddle Brown**</span> symbolizes the earthy, rugged setting and themes of Western genre films.
- **Animation**: <span style="color:#03a9f4">**Light Blue**</span> conveys the vibrant, playful nature of animated movies.
- **Musical**: <span style="color:#e91e63">**Bright Pink**</span> illustrates the lively, expressive characteristics of musical films.
- **Documentary**: <span style="color:#008080">**Teal**</span> represents the balanced, calming approach often essential in documentaries.
- **Thriller**: <span style="color:#cddc39">**Lime**</span> signifies the electric, suspenseful atmosphere thrills often bring.
- **Romance**: <span style="color:#f06292">**Soft Pink**</span> denotes love and tenderness, core themes in romantic films.
- **Music**: <span style="color:#ff9800">**Orange**</span> captures the energetic, dynamic spirit of music-centric movies.
- **Horror**: <span style="color:#b71c1c">**Dark Red**</span> is used to evoke blood and fear, elements commonly found in horror films.
- **Crime**: <span style="color:#212121">**Deep Grey**</span> reflects the dark, mysterious tones typical in crime stories.
- **Action**: <span style="color:#f44336">**Red**</span> communicates the bold, exciting nature of action movies.
- **Adventure**: <span style="color:#4caf50">**Green**</span> again used here to represent growth and the journey central to adventure stories.
- **Biography**: <span style="color:#795548">**Brown**</span> symbolizes the earthy, authentic bases of biographical films, focusing on real people and true events.
- **Family**: <span style="color:#ffca28">**Amber**</span> represents warmth and comfort, key elements in family-oriented films.
- **Fantasy**: <span style="color:#9c27b0">**Deep Purple**</span> captures the magical, mystical elements typical of fantasy films.
- **History**: <span style="color:#3f51b5">**Indigo**</span> reflects the depth and significance of historical contexts and narratives.
- **Mystery**: <span style="color:#263238">**Charcoal**</span> evokes the dark, enigmatic qualities present in mystery genres.
- **Sci-Fi**: <span style="color:#00bcd4">**Cyan**</span> represents the futuristic and often technologically advanced themes found in science fiction.
- **Sport**: <span style="color:#8bc34a">**Light Green**</span> is used to denote energy, health, and vigor, important components of sports films.

</details>

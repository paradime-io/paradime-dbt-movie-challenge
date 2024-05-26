select
    sfj.*,
    s.compound_plot,
    s.compound_overview,
    s.compound_tagline,
    s.compound_title,
    s.compound_keywords
from {{ref('int_science_fictions_joined')}} as sfj
left join {{ref('int_sentiment')}} as s
on sfj.imdb_id = s.imdb_id
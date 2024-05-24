import requests
import pandas as pd 
from collections import OrderedDict
import json
import argparse


# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-from", "--from_year", required=True,
    help="minimum date in query will be Jan 1st of this year")
ap.add_argument("-to", "--to_year", required=True,
    help="maximum date in query will be 31st Dec of this year")
args = vars(ap.parse_args())

from_year=args["from_year"]
to_year=args["to_year"]

url = 'https://query.wikidata.org/sparql'
query = """
SELECT DISTINCT ?human ?humanLabel ?dob ?genderLabel
WHERE
{
  ?human wdt:P31 wd:Q5 ;
         wdt:P106 wd:Q33999 .
         ?human wdt:P569 ?dob .
  OPTIONAL { ?human wdt:P21 ?gender . }
  FILTER(?dob >= "+%s-01-01T00:00:00Z"^^xsd:dateTime
        && ?dob <= "+%s-12-31T00:00:00Z"^^xsd:dateTime)
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en" .
  }
}
""" % (from_year, to_year)

print(query)

r = requests.get(url, params = {'format': 'json', 'query': query})
print(r.status_code)

data = r.json()
with open('query-results-%s-to-%s.json' % (from_year, to_year), 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=4)
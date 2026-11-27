# Financial Market Data Pipeline

An ETL pipeline that scrapes the 100 most active US stocks from Yahoo Finance, cleans the data with pandas, and loads it into a PostgreSQL table.

This was Milestone 1 (Phase 0) of the Hacktiv8 Comprehensive Data Analytics (CODA) program.

```
Yahoo Finance  ──►  Extract  ──►  Transform  ──►  Load
(Most Active)       Selenium +    pandas          PostgreSQL
                    BeautifulSoup
```

## 1. Extract

- Selenium opens the [Most Active](https://finance.yahoo.com/markets/stocks/most-active/) page with `count=100`, scrolls down and waits for the JavaScript to render the table.
- BeautifulSoup parses the table and pulls six fields for each stock: Symbol, Company Name, Price, Change Percent, Volume and Market Cap.
- Output: `kotor_most_active.csv`, 100 rows, every value still stored as text.

## 2. Transform

The scraped values are formatted for people, not for analysis. Each numeric column needed its own fix:

| Column | Raw value | Clean value | How |
|---|---|---|---|
| Price | `"1,087.73"` | `1087.73` | Remove thousands separator, cast to float |
| Change Percent | `"+8.42%"` | `8.42` | Remove `+` and `%`, cast to float |
| Volume | `"151.251M"` | `151251000` | `convert_suffix()` turns M / B / T into numbers |
| Market Cap | `"5.542T"` | `5542000000000` | Same function |

After cleaning, `df.info()` confirms all four columns are `float64` with 100 non-null rows.
Output: `bersih_most_active.csv`.

## 3. Load

`load_to_postgresql.sql` creates the `most_active_stocks` table (with `symbol` as the primary key) and loads the clean CSV using PostgreSQL's `COPY ... CSV HEADER`.

## Snapshot summary

The data is a single snapshot taken in September 2026.

- **Most traded:** Grab Holdings (GRAB), 151.3M shares, almost twice the next stock (Nokia, 83.9M)
- **Largest market cap:** NVIDIA (NVDA), $5.54T
- **Biggest gainer:** Viking Therapeutics (VKTX), +32.20%
- **Biggest loser:** Cisco Systems (CSCO), -5.26%
- **Market mood:** 66 of the 100 stocks were up and 34 were down when the data was taken
- **Price range:** $2.10 to $1,087.73, median $17.95

## Files

| File | What it is |
|---|---|
| `most_active_stocks_etl.ipynb` | Extract and transform steps |
| `load_to_postgresql.sql` | Table creation and data load |
| `kotor_most_active.csv` | Raw scraped data |
| `bersih_most_active.csv` | Clean data |

## How to run

1. `pip install -r requirements.txt` (Selenium also needs Google Chrome installed)
2. Run the notebook. It saves both CSV files in the same folder.
3. In PostgreSQL, run `load_to_postgresql.sql`. Change the file path in the `COPY` command to where your `bersih_most_active.csv` is.

Note: the page changes every trading day, so a new run gives different stocks and numbers.

## Limitations and next steps

- **One snapshot only.** Scheduling the pipeline (for example with Airflow) would build a daily history that can show trends.
- **Columns are picked by position** (`cols[3]`, `cols[5]`, ...). If Yahoo changes the table layout, the scraper breaks. Selecting cells by their `data-testid` attributes would be sturdier.
- **Missing values become 0.** `convert_suffix()` turns `"-"` into `0.0`, which looks like real data. Keeping them as `NaN` / `NULL` would be more honest.
- **Data types.** `FLOAT` leaves rounding noise in large numbers (e.g. `33255000.000000004`). `BIGINT` for volume and `NUMERIC` for market cap would store them exactly.
- This project is for learning purposes. Check Yahoo Finance's terms of use before scraping it regularly.

## Tools

Python, Selenium, BeautifulSoup, pandas, NumPy, PostgreSQL

## Author

**Aldi Zulkarnaen Alamsyah**
[LinkedIn](https://www.linkedin.com/in/aldi-zulkarnaen/) · [GitHub](https://github.com/AldiZA)

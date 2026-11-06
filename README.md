# 🦆 dbt + DuckDB Job Market Pipeline

This repo is my build of Project #1 from Luke Barousse's free course, [dbt for Data Analytics & Engineering](https://github.com/lukebarousse/dbt_Analytics_Engineering_Course). It takes a year of raw job postings and turns them into tested, documented tables on DuckDB. GitHub Actions rebuilds the warehouse automatically and publishes it.

## Author 👤

**🙋🏾‍♂️ Built by:** [Daniel Agbenyo](https://github.com/daniel-agbenyo)

**📚 Course:** [Luke Barousse](https://www.linkedin.com/in/luke-b), *dbt for Data Analytics & Engineering*

## What this project covers

This project is the **T in ELT**. The raw data was already extracted and loaded as parquet files. dbt reads those files with DuckDB, cleans them, and builds analysis tables inside the warehouse. All of the SQL is version-controlled, tested and documented, so it doesn't live in scattered scripts.

The pipeline:

1. **Download** 12 months of raw job postings (parquet) into `data/raw/`
2. **Transform** them with dbt into a cleaned view plus three summary tables
3. **Test** the key columns with dbt's generic tests (`not_null`, `unique`)
4. **Ship** the result: on every push to `main`, every Monday morning, or a manual run, GitHub Actions builds `prod.duckdb` and uploads it to a [GitHub release](https://github.com/daniel-agbenyo/dbt-duckdb-pipeline/releases/tag/warehouse)

## What's in this repo

| Folder | What it is |
| --- | --- |
| [analytics/](analytics/) | The dbt project: models, sources, tests and `dbt_project.yml` |
| [scripts/](scripts/) | `download_data.py` fetches the course dataset into `data/raw/` |
| [ci/](ci/) | `profiles.yml` with a `dev` and a `prod` DuckDB target, used by CI (and usable locally) |
| [.github/workflows/](.github/workflows/) | `dbt_build.yml` downloads the data, runs `dbt build` and publishes the warehouse |
| `data/` | Raw parquet files and the `.duckdb` warehouses (git-ignored, created when you run the pipeline) |

### The models

| Model | Materialized | What it is |
| --- | --- | --- |
| `job_postings` | view | One row per job posting. Selects the useful columns from the raw source and drops error rows |
| `jobs_per_month` | table | Number of postings per month and role (search term) |
| `top_locations` | table | The 10 locations with the most postings |
| `monthly_summary` | table | Total postings, remote postings and % remote for each month |

## Setup

Requires [uv](https://docs.astral.sh/uv/). It installs Python 3.12 and `dbt-duckdb` for you.

```bash
git clone https://github.com/daniel-agbenyo/dbt-duckdb-pipeline.git
cd dbt-duckdb-pipeline
uv sync                                       # creates .venv with dbt + DuckDB adapter
uv run python scripts/download_data.py        # downloads the dataset (~85MB) into data/raw/
cd analytics
uv run dbt debug --profiles-dir ../ci --target dev   # verify everything works
uv run dbt build --profiles-dir ../ci --target dev   # build the models and run the tests
```

This builds `data/dev.duckdb`. To browse the docs and lineage graph:

```bash
uv run dbt docs generate --profiles-dir ../ci --target dev --target-path ../docs
uv run dbt docs serve --target-path ../docs   # then open http://localhost:8080
```

Don't want to run anything? Download the latest `prod.duckdb` from the [warehouse release](https://github.com/daniel-agbenyo/dbt-duckdb-pipeline/releases/tag/warehouse) and open it with DuckDB.

## The dataset

A year of real job postings (Data Engineer, Data Analyst and Data Scientist roles), July 2025 to June 2026. Luke Barousse's [datanerd.tech](https://datanerd.tech) pipeline collected them. The data is raw and intentionally messy, with duplicate scrapes, error rows and inconsistent fields. Cleaning it is the point of the project.

The files ship as monthly parquet in the course's [dataset release](https://github.com/lukebarousse/dbt_Analytics_Engineering_Course/releases/tag/dataset-v1). `scripts/download_data.py` fetches them for you.

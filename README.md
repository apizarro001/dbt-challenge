# Practice Expansion Reporting with dbt

A dbt Core project using MotherDuck to turn fictional practice revenue
into a tested reporting dataset.

Created by Andrey Pizarro for the DataCoves technical challenge.

## Business Purpose

Revenue reports depend on reliable customer identifiers and consistent
calculations. Missing identifiers or duplicate records can produce
incomplete or inflated results.

This project demonstrates how dbt organizes transformations into reusable
steps and applies repeatable data checks.

The final report shows each practice's monthly revenue, previous month's
revenue, and whether revenue increased, decreased, or stayed unchanged.

## Sample Data

All data is fictional.

- `practices`: 100 practices with identifiers, names, and regions.
- `practice_revenue`: 300 records covering January–March 2026.
- Revenue includes increasing, decreasing, and unchanged patterns.
- Each revenue record represents one practice in one month.
- Amounts represent fictional USD monthly revenue.

CSV files are loaded into MotherDuck using dbt seeds. In a client
implementation, existing warehouse tables would usually supply these inputs.

## Project Structure

| Folder | Database schema | Purpose |
|---|---|---|
| seeds | main | Fictional input data |
| models/staging | staging | Standardize identifiers, text, and data types |
| models/modeling | modeling | Calculate monthly revenue changes |
| models/reporting | reporting | Combine practice details with revenue calculations |
| tests | — | Custom data checks |
| macros | — | Schema naming rule |

## Data Flow

Revenue:
`practice_revenue` → `stg_practice_revenue`
→ `mdl_practice_revenue_change` → `rpt_practice_expansion`

Practice details:
`practices` → `stg_practices` → `rpt_practice_expansion`

dbt references define dependencies and determine build order.

## Business Rules

- Expansion: revenue increased compared with the previous month.
- Contraction: revenue decreased compared with the previous month.
- Unchanged: revenue stayed the same.
- First observed month: no previous revenue record is available.

The first observed month has no calculated revenue change. It does not
automatically represent a newly acquired customer.

## Data Checks

The project contains 16 data tests covering:

- Unique practice identifiers.
- Required values in input and reporting data.
- Revenue identifiers matching an existing practice.
- One revenue record per practice per month.
- Allowed revenue classification labels.

Tests detect the conditions defined in the project. They do not repair data.
Automated scheduling and notifications are not configured in this demo.

## Setup on Windows

Prerequisites: Python 3.13, Git, and a MotherDuck account.

From the downloaded or cloned project folder, create a Python environment
and install dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

In MotherDuck, create the database:

```sql
CREATE DATABASE IF NOT EXISTS dbt_challenge;
```

Create or update `%USERPROFILE%\.dbt\profiles.yml` with this profile.
Preserve other profiles if the file already exists:

```yaml
dbt_challenge:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "md:dbt_challenge"
      schema: main
      threads: 1
```

Check the connection and complete browser authentication when prompted:

```powershell
.\.venv\Scripts\dbt.exe debug
```

Load the seeds, build models, and run tests:

```powershell
.\.venv\Scripts\dbt.exe build
```

The commands use the environment directly, so PowerShell activation is
not required.

## Validation Results

The completed build passed all 22 steps:
2 seeds, 4 models, and 16 tests, with no warnings or errors.

| Month | Practices | Total revenue | Net revenue change |
|---|---:|---:|---:|
| 2026-01 | 100 | 226250.00 | Not available |
| 2026-02 | 100 | 226150.00 | -100.00 |
| 2026-03 | 100 | 226050.00 | -100.00 |

February and March each contain 33 expanding practices, 34 contracting
practices, and 33 unchanged practices.

Query the final report in MotherDuck:

```sql
SELECT *
FROM dbt_challenge.reporting.rpt_practice_expansion
ORDER BY practice_id, revenue_month;
```

## Demo Boundaries

- The sample has consecutive months. Missing months would require
  additional handling before interpreting the previous record as
  the previous calendar month.
- Expansion and contraction are simplified revenue comparisons.
  Customer acquisition, churn, and reactivation rules are not included.
- Exact schema names are configured for this individual demo.
  A shared team setup would need isolated development environments.
- Local credentials, database files, and generated output are excluded
  from Git.
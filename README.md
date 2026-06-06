# dbt Medallion Project — E-Commerce Analytics

A complete **dbt + Snowflake** proof-of-concept project for E-Commerce Analytics built using the official dbt **Staging → Intermediate → Marts** architecture.

## Project Structure

```
sf_dbt/
├── models/
│   ├── staging/ecom/       # 1:1 views of raw source tables (type casts, audit columns)
│   ├── intermediate/ecom/  # Joins, deduplication, business logic
│   ├── marts/
│   │   ├── finance/        # orders, sales_summary
│   │   └── marketing/      # customers (CLV, lifecycle metrics)
│   └── utilities/          # all_dates (date spine)
├── macros/                 # generate_surrogate_key, audit_columns, cents_to_dollars
├── seeds/                  # raw_orders.csv, raw_customers.csv, raw_products.csv
├── snapshots/              # customer_snapshot (SCD Type 2)
├── tests/                  # assert_positive_value_for_total_amount
└── analyses/               # sample_ad_hoc_analysis
```

## Setup

### 1. Clone the repo
```bash
git clone <your-repo-url>
cd sf_dbt
```

### 2. Create `profiles.yml`
Create a `profiles.yml` in the project root (this file is gitignored — never commit it):

```yaml
snowflake_profile:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "your-account.snowflakecomputing.com"
      user: "your_user"
      password: "your_password"
      role: "DBT_ROLE"
      warehouse: "DBT_WH"
      database: "ECOMMERCE_DEV"
      schema: "PUBLIC"
      threads: 4
```

### 3. Install packages
```bash
dbt deps
```

### 4. Run the project
```bash
dbt seed       # Load CSVs to Snowflake
dbt run        # Build all models
dbt test       # Run all data quality tests
dbt snapshot   # Track customer history (SCD Type 2)
```

### 5. View documentation
```bash
dbt docs generate
dbt docs serve   # Opens http://localhost:8080
```

## Data Flow

```
raw CSV seeds → staging (views) → intermediate (views) → marts (tables)
```

# Data Engineering Assessment

## Overview

This project implements a simple end-to-end data pipeline using Airbyte, Postgres, and dbt.

Pipeline flow:

File source (Shopify sample JSONL files) -> Airbyte -> Postgres raw schema -> dbt staging models -> dbt marts

## Architecture

Components used:

- Airbyte for ingestion from local JSONL files
- Postgres as the warehouse
- dbt for transformations
- Docker for local execution
- GitHub for version control and workflow setup

Schemas used:

- `raw` for Airbyte-ingested source tables
- `dev` for dbt development models
- `prod` for dbt production models
- `staging` and `marts` logic represented through dbt model layers

Primary raw tables loaded by Airbyte:

- `raw.shopify_customers_file`
- `raw.shopify_orders_file`
- `raw.shopify_products_file`

Primary dbt models:

Staging:
- `stg_customers`
- `stg_orders`
- `stg_products`

Marts:
- `dim_customers`
- `dim_products`
- `fact_orders`
- `sales_summary`
- `customer_order_summary`

## Project Structure

```text
data-engineering-assessment/
├─ DATA/
│  ├─ portable_shopify.customers.sample.jsonl
│  ├─ portable_shopify.orders.sample.jsonl
│  └─ portable_shopify.products.sample.jsonl
├─ dbt/
│  ├─ Dockerfile
│  ├─ dbt_project.yml
│  ├─ profiles.yml
│  ├─ macros/
│  │  └─ generate_schema_name.sql
│  └─ models/
│     ├─ sources/
│     │  └─ sources.yml
│     ├─ staging/
│     │  ├─ stg_customers.sql
│     │  ├─ stg_orders.sql
│     │  └─ stg_products.sql
│     ├─ marts/
│     │  ├─ dim_customers.sql
│     │  ├─ dim_products.sql
│     │  ├─ fact_orders.sql
│     │  ├─ sales_summary.sql
│     │  └─ customer_order_summary.sql
│     └─ schema.yml
├─ scripts/
│  ├─ staging.sql
│  ├─ marts.sql
│  └─ rbac.sql
├─ .github/
├─ README.md
└─ CHALLENGE.md
```

## Local Setup

### 1. Start Postgres and supporting services

From the project root, start Docker services:

```bash
docker compose up -d
```

Validate the Postgres container is running:

```bash
docker ps
```

Connect to Postgres inside the container:

```bash
docker exec -it de_postgres psql -U postgres -d assessment
```

## Airbyte Setup

### 2. Launch Airbyte

Start Airbyte using the project setup or Docker compose, depending on the repository instructions.

Open the Airbyte UI in the browser.

### 3. Make local files reachable to Airbyte

From the project root, serve the sample files with Python:

```bash
python -m http.server 9000
```

This exposes the `DATA` folder over HTTP.

Example URLs:

- `http://<your-local-ip>:9000/DATA/portable_shopify.customers.sample.jsonl`
- `http://<your-local-ip>:9000/DATA/portable_shopify.orders.sample.jsonl`
- `http://<your-local-ip>:9000/DATA/portable_shopify.products.sample.jsonl`

Important notes:

- Use `http`, not `https`
- Use `.jsonl` format
- If Airbyte cannot read `localhost`, use your machine IP such as `192.168.x.x`

### 4. Configure Airbyte source

Create a source using:

- Source type: File
- Format: JSONL
- Reader options: JSONL-compatible settings
- File URLs: the HTTP URLs above

Create one source stream for each file.

### 5. Configure Airbyte destination

Create a Postgres destination with:

- Host: `de_postgres` if Airbyte and Postgres run in the same Docker network
- Port: `5432`
- Database: `assessment`
- Username: `postgres`
- Password: your configured password
- Schema: `raw`

### 6. Configure the Airbyte connection

Recommended selections:

- Sync mode: `Replicate Source`
- Namespace: `Destination-defined`
- Destination schema: `raw`

If a stream shows primary key issues, use a mode that works without strict dedupe requirements for this dataset.

### 7. Run the sync

Trigger `Sync now` in Airbyte.

After sync, validate the tables in Postgres:

```sql
\dt raw.*
SELECT COUNT(*) FROM raw.shopify_customers_file;
SELECT COUNT(*) FROM raw.shopify_orders_file;
SELECT COUNT(*) FROM raw.shopify_products_file;
```

## SQL Validation and Supporting Scripts

If needed, execute helper SQL scripts from the project root:

```bash
docker exec -i de_postgres psql -U postgres -d assessment < scripts\staging.sql
docker exec -i de_postgres psql -U postgres -d assessment < scripts\marts.sql
docker exec -i de_postgres psql -U postgres -d assessment < scripts\rbac.sql
```

These scripts help validate staging, marts, and role setup outside dbt as well.

## dbt Setup

### 8. Build dbt Docker image

From the project root:

```bash
docker build -t local-dbt-postgres -f dbt\Dockerfile dbt
```

### 9. Validate dbt connection

Run:

```bash
docker run --rm ^
  --network data-engineering-assessment_default ^
  -v "%cd%\dbt:/usr/app" ^
  local-dbt-postgres debug --project-dir /usr/app --profiles-dir /usr/app --target dev
```

Expected outcome:

- `profiles.yml file [OK found and valid]`
- `dbt_project.yml file [OK found and valid]`
- `Connection test: [OK connection ok]`

### 10. Run dbt for development

Run dbt models into the `dev` schema:

```bash
docker run --rm ^
  --network data-engineering-assessment_default ^
  -v "%cd%\dbt:/usr/app" ^
  local-dbt-postgres run --project-dir /usr/app --profiles-dir /usr/app --target dev
```

Successful outcome should show all 8 models completed.

### 11. Run dbt for production

Run the same project into the `prod` schema by changing the target:

```bash
docker run --rm ^
  --network data-engineering-assessment_default ^
  -v "%cd%\dbt:/usr/app" ^
  local-dbt-postgres run --project-dir /usr/app --profiles-dir /usr/app --target prod
```

### 12. Validate dbt outputs

Example validation queries:

```sql
SELECT COUNT(*) FROM dev.stg_customers;
SELECT COUNT(*) FROM dev.stg_orders;
SELECT COUNT(*) FROM dev.stg_products;

SELECT COUNT(*) FROM dev.fact_orders;
SELECT * FROM dev.sales_summary LIMIT 10;
SELECT * FROM dev.customer_order_summary ORDER BY lifetime_value DESC LIMIT 10;
```

If validating prod:

```sql
SELECT COUNT(*) FROM prod.fact_orders;
SELECT * FROM prod.sales_summary LIMIT 10;
```

## Staging vs Production

Development target:

- Target name: `dev`
- Schema output: `dev`
- Used for local testing and iteration

Production target:

- Target name: `prod`
- Schema output: `prod`
- Used for deployment-ready runs

The dbt macro `generate_schema_name.sql` controls schema naming so the same models can be run against different targets cleanly.

## RBAC Design

Roles created:

- `airbyte_ingestion`
- `transform_role`
- `reporting_role`
- `postgres`

Intent of each role:

- `airbyte_ingestion`: owns or writes raw ingestion objects
- `transform_role`: reads raw and builds transformed models
- `reporting_role`: read-only access to curated marts
- `postgres`: admin role for setup and management

Example validation:

```sql
\du
```

## Git Workflow

### 13. Create feature branch

```bash
git checkout -b feature/yeshwanth-solution
```

### 14. Stage and commit changes

```bash
git add .
git commit -m "Add dbt project with staging and marts models"
```

### 15. Push branch

```bash
git push -u origin feature/yeshwanth-solution
```

## Pull Request Content

The PR description should include:

- How Airbyte was run locally
- How dbt was run in `dev` and `prod`
- How GitHub secrets should be configured
- Assumptions made
- Optional Loom walkthrough link

Suggested PR sections:

- Overview
- Architecture
- Local run steps
- Airbyte run steps
- dbt run steps
- GitHub Actions secrets
- RBAC design
- Assumptions
- Validation results

## GitHub Actions and Secrets

For CI/CD workflows, configure repository secrets such as:

- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

If Airbyte automation is included, add any required Airbyte credentials or host secrets as well.

Typical workflow usage:

- Run dbt debug
- Run dbt run for target environment
- Optionally run dbt test if tests are configured and selected in workflow

## Challenges

Assumptions made during Challenges:

1. The Shopify sample files are line-delimited JSON and should be ingested as JSONL.
2. Airbyte writes source data into the `raw` schema.
3. dbt models are implemented as views for simplicity and fast iteration.
4. Local development uses Docker networking and the Postgres container name `de_postgres`.
5. `dev` and `prod` are separated by schema, not separate databases.
6. Some nested Shopify fields require flattening or selective extraction in staging models.
7. This solution prioritizes clarity and completeness for the assessment over production-grade orchestration hardening.

## Validation Summary

Validated successfully:

- Airbyte sync to Postgres raw schema
- Raw tables visible in Postgres
- dbt debug successful
- dbt run successful for all 8 models
- Core analytical outputs available in marts
- Git branch pushed successfully



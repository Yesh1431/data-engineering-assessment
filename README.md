# Data Engineering Assessment

Interview challenge for data engineering candidates at Brainforge. This assessment evaluates **ingestion, transformation, orchestration, and database design** using Shopify-style data (customers, orders, products).

---

## Overview

You will build an end-to-end data pipeline: ingest JSONL into Postgres (via Airbyte), define Postgres roles and RBAC, transform data with dbt (staging + order summary mart), and run dbt via GitHub Actions (on PR and on a schedule). The task mirrors a realistic client scenario and tests your ability to make clear design choices and document them.

**Full instructions:** [CHALLENGE.md](CHALLENGE.md) — read this first.

---

## Repository structure

```
.
├── CHALLENGE.md          # Full task list and deliverables
├── README.md             # This file
└── DATA/
    ├── portable_shopify.customers.sample.jsonl
    ├── portable_shopify.orders.sample.jsonl
    ├── portable_shopify.products.sample.jsonl
    ├── METADATA_customers.md
    ├── METADATA_orders.md
    └── METADATA_products.md
```

- **Raw data:** Three JSONL files in `DATA/` (Shopify-style customers, orders, products).
- **Metadata:** See `DATA/METADATA_*.md` for field descriptions and join keys.

---

## Time expectation

- **Expected effort:** ~5–8 hours (depending on familiarity with Airbyte, dbt, and GitHub Actions).
- The challenge is open-ended; we evaluate clarity of design, documentation, and completeness as much as the implementation.

---

## Submission instructions

1. **Fork** this repository (you'll receive access once selected for the challenge).
2. Create a new branch named after yourself (e.g. `feature/jane-doe-solution`).
3. Implement your solution in your branch (Airbyte, Postgres, dbt, GitHub Actions as per [CHALLENGE.md](CHALLENGE.md)).
4. Submit a **Pull Request** to your fork when finished.
5. In the PR description include:
   - How to run Airbyte and dbt (staging vs production).
   - How to configure GitHub secrets for the workflows.
   - Any assumptions you made.
   - Optional: link to a short Loom (5–10 min) walking through your approach.
6. Share the fork link with the recruiting team.

---

## Evaluation criteria

| Area | Description |
|------|-------------|
| **Data / pipeline design** | How well the solution handles ingestion (Airbyte → Postgres), schema/namespace choices, and transformation (staging → mart). |
| **Code quality** | Structure, readability, maintainability of dbt models and any scripts; adherence to common DE practices. |
| **System design** | RBAC design (four roles), staging vs production targets, and clarity of documentation. |
| **Completeness** | All deliverables in [CHALLENGE.md](CHALLENGE.md) met; run/validation (dbt run, tests, Actions) succeeds; docs cover run steps and secrets. |
| **Presentation** | If you provide a Loom: clarity and professionalism of the walkthrough. |

---

## Contact

For technical questions about this challenge, reach out to your contact at Brainforge. Do **not** open public GitHub issues or discussions about the challenge.

---

*This assessment is used by Brainforge for Data Engineering candidates (Stage 3). Content owner: Awaish.*

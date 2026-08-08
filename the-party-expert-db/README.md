# The Party Expert — Relational Database Design & Analytics

> An end-to-end MySQL database solution and predictive-analytics study for a Melbourne event-planning
> company, built as a university team project for **ISYS2038 Database Design & Development**.
> Covers data modelling, a normalised schema, a full data dictionary, ten
> business-driven SQL queries (standard + advanced), a database-administration review, and a
> sales-forecasting model in Orange.

**Tech:** MySQL Workbench· SQL (DDL, DML, Views, Functions, Procedures, Triggers, CTEs) · Orange (data mining) ·
Entity-Relationship modelling (ER modelling) · Normalisation

---

## Overview

*The Party Expert (TPE)* is a small Melbourne company that plans weddings, birthdays, corporate events and
conferences. In the case study, TPE runs on emails, phone calls and manual spreadsheets, which causes
errors and inefficiencies, and is planning to expand to Sydney. Acting as business analysts, the team
designed and built a centralised relational database to replace the manual process, then used it to
answer real operational questions and to forecast sales.

The work is delivered in two parts:

- **Part A — Foundations.** Business problem analysis, Entity–Relationship Diagram (ERD), relational
  model, a complete data dictionary, and five business SQL queries (with table creation and test data).
- **Part B — Advanced.** Five advanced SQL objects (View, Function, Stored Procedure, Trigger, nested
  CTE query), a database-administration review (privacy, integrity and backup strategy), and a
  predictive-analytics study in Orange comparing three models.

---

## What this project demonstrates

- Translating a messy, real-world business narrative into a **normalised relational schema** (7 core
  entities + 3 associative entities).
- Writing a rigorous **data dictionary** — data types, sizes, keys and integrity constraints
  (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT`, `AUTO_INCREMENT`).
- Authoring **business-driven SQL**, each query tied to a decision TPE actually needs to make
  (employee performance, client value, billing, scalability, supplier quality).
- Building **advanced SQL objects** — a reporting `VIEW`, a reusable `FUNCTION`, a validated `PROCEDURE`,
  a data-protecting `TRIGGER`, and a multi-CTE `NESTED QUERY`.
- Reasoning about **database administration** — PII/financial-data protection and a backup/recovery plan.
- Running a **predictive-analytics workflow** in Orange (cleaning, exploration, model comparison) to
  forecast sales.

---

## Repository structure

```
the-party-expert-db/
├── README.md                     ← you are here
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── reports/                  ← Part A & Part B written reports (PDF)
│   └── diagrams/                 ← Images: ERD + Relational model, Orange's predictive models + outputs
│
├── sql/
│   ├── part-a/                   ← schema + 5 business queries
│   │   ├── 00_create_schema.sql
│   │   ├── 01_query1_total_hours_per_employee.sql
│   │   ├── 02_query2_total_spending_per_client.sql
│   │   ├── 03_query3_overdue_final_invoice_update.sql
│   │   ├── 04_query4_large_scale_party_location.sql
│   │   └── 05_query5_top_rated_supplier_per_type.sql
│   └── part-b/                   ← 5 advanced SQL objects
│       ├── 01_view_party_cost_summary.sql
│       ├── 02_function_avg_fee_by_genre.sql
│       ├── 03_procedure_insert_invoice_with_validation.sql
│       ├── 04_trigger_prevent_future_resign.sql
│       └── 05_nested_query_top_supplier_type_per_party.sql
│
└── orange/
    └── workflow/                 ← Orange .ows workflow
```
---

## Database design

Ten tables were derived from the case study — seven core entities and three associative entities that
resolve the many-to-many relationships.

| Type        | Tables |
|-------------|--------|
| Core        | `Client`, `Party`, `Location`, `Employee`, `Entertainer`, `Supplier`, `Invoice` |
| Associative | `Invitation` (Party ↔ Entertainer), `Responsibility` (Party ↔ Employee), `Purchase` (Party ↔ Supplier) |

Key business rules encoded in the schema include: each party has exactly one client, one location and one
full-time lead employee; each party takes exactly one supplier per category (florist, caterer, bakery,
and one equipment/accessory hire); entertainers are optional and many-to-many; and each party generates a
20% deposit invoice and a final invoice, issued within 14 days of completion.

> The ERD and relational model images live in [`docs/diagrams/`](docs/diagrams/); the full written
> reports (with the complete data dictionary) live in [`docs/reports/`](docs/reports/).

---

## SQL highlights

### Part A — business queries

| # | Query | Technique | Business question |
|---|-------|-----------|-------------------|
| 1 | Total worked hours per employee | `JOIN`, `GROUP BY`, `SUM`, `ORDER BY` | Who are the top-performing staff, and how should shifts be allocated? |
| 2 | Total spending per client | multi-table `JOIN`, `GROUP BY`, `SUM` | Which clients drive the most lifetime value? |
| 3 | Overdue final-invoice update | action `UPDATE` across joined tables | Flag unpaid final invoices automatically. |
| 4 | Large-scale party locations | subquery (`AVG`), `WHERE` filter | Which Melbourne venues host the biggest events? |
| 5 | Top-rated supplier per type | subquery + scalar functions (`UPPER`, `CONCAT`) | Build a preferred-vendor list by category. |

### Part B — advanced SQL objects

| # | Object | Name | Purpose |
|---|--------|------|---------|
| 1 | `VIEW` | `Party_Cost_Summary` | One-row-per-party summary joining six tables. |
| 2 | `FUNCTION` | `avg_fee_by_genre` | Reusable average-fee lookup for pricing/quoting. |
| 3 | `PROCEDURE` | `insert_invoice_with_validation` | Insert an invoice only if the amount is valid (> 0). |
| 4 | `TRIGGER` | `prevent_future_resign` | Block resignation while an employee still has upcoming parties. |
| 5 | `NESTED QUERY` (CTE) | Top supplier type per party | Rank best-performing supplier types across events. |

---

## Data analytics (Orange)

A sales dataset (2,000 records, 7 attributes) was cleaned and modelled in Orange to forecast
`SalesAmount`:

- **Cleaning** — ~0.2% missing values; numerical fields imputed with the mean, categorical with the
  mode, and rows missing the target variable removed (1,992 clean records).
- **Exploration** — box plots, distributions and feature statistics identified `Customers` and `Sales`
  as the strongest predictors.
- **Modelling** — Linear Regression, Random Forest and k-Nearest Neighbours were compared with 5-fold
  cross-validation (R², RMSE, MAE, MAPE).

**Result:** Linear Regression was the best fit (**R² ≈ 0.991**, lowest RMSE/MAE), narrowly ahead of
Random Forest (R² ≈ 0.990) and well ahead of kNN (R² ≈ 0.967) — chosen for accuracy *and*
interpretability.

---

## How to run

### SQL (MySQL)

1. Create/select a database (schema):
   ```sql
   CREATE DATABASE tpe;
   USE tpe;
   ```
2. Build the tables and constraints:
   ```sql
   SOURCE sql/part-a/00_create_schema.sql;
   ```
3. Load your test data (10–20 rows per table), then run any query, e.g.:
   ```sql
   SOURCE sql/part-a/01_query1_total_hours_per_employee.sql;
   ```
4. For Part B, run the advanced objects the same way (each file drops-and-recreates its object safely).

> Tested on MySQL 8.0 (MySQL Workbench). The scripts use plain, unqualified table names so they run in
> any schema you select.

### Orange (analytics)

1. Install [Orange](https://orangedatamining.org/).
2. Open `orange/workflow/*.ows`.
3. Point the **File** widget at the dataset in `orange/data/` (see that folder's README).

---

## My contribution

This was a four-person team project. My personal contribution across both parts was:

- **Designing the data dictionary**: data types, sizes, keys and integrity constraints for all ten
  tables.
- **Authoring the SQL**: the five Part A business queries and the five Part B advanced SQL objects
  (view, function, procedure, trigger, nested CTE).
- **Writing the business rationale**: the purpose, value and impact narrative for every query.
- **Database implementation**: generate data table-by-table, implement queries and validates results & analytics.

Full team credits are below.

---

## Team & acknowledgements

Delivered by a team of four RMIT students acting as analysts at "Best Innovative Solution (BIS) Pty Ltd":

- **Hua Quoc Thinh, Ngo (Williams Ngo)** — Data dictionary, SQL & advanced SQL authoring + business
  explanations *(repository author)*
- **Nguyen Ngoc Thao My** — Data modelling (ERD & relational model), database-administration approaches
- **Maria Del Rosario Vargas Ramos** — Introduction, business assumptions & rules, Orange analytics
- **Dang Nguyen Huy Nhat** — SQL support, report presentation

---

## Academic integrity

This repository contains original coursework, shared publicly as a portfolio piece to demonstrate
database and SQL skills. It is **not** provided for reuse or resubmission. If you are a current student,
please do your own work and follow your institution's academic-integrity policy.

The company, **dataset are generated by team** — no real client data is included.

---

## Contact

**Hua Quoc Thinh, Ngo (Williams Ngo)** — Business Analyst / Data Analyst / BI Analyst, Melbourne

- LinkedIn: [https://linkedin.com/in/hua-quoc-thinh-ngo-713b42232](https://www.linkedin.com/in/hua-quoc-thinh-ngo-713b42232/)
- GitHub: https://github.com/huango3979
- Email: quocthinh231021@gmail.com

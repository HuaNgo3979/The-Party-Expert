# SQL scripts

Reconstructed from the project reports so the repo runs out of the box. **Please verify
each script against your own working `.sql` files** — screenshots can hide small details.

Two things were cleaned up for a public repo:
1. The `s3863887.` schema prefix was removed, so scripts run in any database you select
   (`USE your_db;`). Add your own prefix back if you prefer.
2. `Employee.Resigned_Date` is defined as **nullable** in the schema, because the Part B
   trigger checks `IS NOT NULL`.

## Run order
1. `part-a/00_create_schema.sql` — creates all tables + constraints
2. Load 10–20 test rows per table (your data script — not included here)
3. Run any query file in `part-a/`
4. Run any advanced object in `part-b/` (each safely drops & recreates itself)

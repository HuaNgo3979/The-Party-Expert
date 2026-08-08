## Getting Started

Want to run this project yourself? You'll need two free tools - **MySQL** (to build and query the
database) and **Orange** (for the sales-forecasting analytics). Here's how to set both up.

### Prerequisites

| Tool | Purpose | Download |
|------|---------|----------|
| MySQL (Server + Workbench) | Create the database and run the SQL scripts | https://dev.mysql.com/downloads/ |
| Orange | Open the analytics workflow (dataset not included — see note below) | https://orangedatamining.com/download/ |

---

### 1. Install MySQL

MySQL comes with **Workbench**, a visual editor where you'll run the scripts.

**Windows**
1. Download the **MySQL Installer** → https://dev.mysql.com/downloads/installer/
2. Run it and choose the **Developer Default** setup (installs Server + Workbench together).
3. When prompted, set a **root password** and remember it.

**macOS**
1. Download **MySQL Community Server** → https://dev.mysql.com/downloads/mysql/
2. Download **MySQL Workbench** → https://dev.mysql.com/downloads/workbench/
3. Install both, set a root password during setup.

**Then, in any OS:** open **MySQL Workbench**, click your local connection, and you're in.

> New to Workbench? You run a script with the **lightning-bolt** button, and see results in the
> grid below.

---

### 2. Install Orange

1. Go to https://orangedatamining.org/download/ and grab the installer for your OS.
2. Install and open it — you'll get a visual, drag-and-drop canvas (no coding needed).

---

### 3. Run the database (MySQL)

1. In Workbench, create a schema: `CREATE DATABASE tpe; USE tpe;`
2. Open and run [`sql/part-a/00_create_schema.sql`](https://github.com/HuaNgo3979/The-Party-Expert/blob/main/the-party-expert-db/sql/part-a/00_create_schema.sql) to build all the tables.
3. Load 10–20 test rows per table, then run any query from
   [`sql/part-a/`](https://github.com/HuaNgo3979/The-Party-Expert/tree/main/the-party-expert-db/sql/part-a)
   or the advanced objects in
   [`sql/part-b/`](https://github.com/HuaNgo3979/The-Party-Expert/tree/main/the-party-expert-db/sql/part-b).

---

### 4. Run the analytics (Orange)

> **Note on the dataset:** the sales dataset used for this study was provided by RMIT as course
> material, so it is **not included** in this public repository. To keep the analytics reproducible,
> the Orange workflow and result screenshots are shared instead.

The analytics were built in Orange using this pipeline:

`File → Impute → Select Columns → (Box Plot / Distributions / Feature Statistics) → Test & Score → Prediction`

- Workflow file: [`orange/workflow/`](https://github.com/HuaNgo3979/The-Party-Expert/tree/main/the-party-expert-db/orange)
- Result screenshots: [`docs/diagrams/`](https://github.com/HuaNgo3979/The-Party-Expert/tree/main/the-party-expert-db/docs/diagrams)

**Summary of results:** after cleaning (~0.2% missing values imputed; target rows removed → 1,992
records), three models were compared with 5-fold cross-validation. **Linear Regression** was the best
fit — **R² ≈ 0.991**, lowest RMSE/MAE — ahead of Random Forest (R² ≈ 0.990) and kNN (R² ≈ 0.967).

*The dataset is available on request for academic review — please reach out via the contact details below.*

> Full walkthrough and results are in the reports under
> [`docs/reports/`](https://github.com/HuaNgo3979/The-Party-Expert/tree/main/the-party-expert-db/docs/reports).

# Publishing this repo to GitHub

A quick, copy-paste checklist. (You can delete this file once it's up.)

## 1. Add your files first
- `sql/`  — verify the scripts, or replace with your own `.sql` files
- `orange/workflow/` — add `tpe_sales_prediction.ows`
- `orange/data/` — add the dataset (read that folder's README first — it's ignored by default)
- `docs/reports/` — add the two PDFs
- `docs/diagrams/` — add `erd.png` and `relational-model.png`

## 2. Create an empty repo on GitHub
Go to https://github.com/new and create **the-party-expert-db** (no README/licence/gitignore —
this folder already has them). Keep it **Private** first if you're unsure about the dataset.

## 3. Push from your computer
Open a terminal in this folder and run:

```bash
git init
git add .
git commit -m "Add The Party Expert database design & analytics project"
git branch -M main
git remote add origin https://github.com/huango3979/the-party-expert-db.git
git push -u origin main
```

## 4. Link it from your portfolio
Your portfolio already points its "The Party Expert" card at `/the-party-expert-db`, so once this
is live at `https://github.com/huango3979/the-party-expert-db` the link will work.

## Tips
- Make the repo **public** only after you've confirmed the RMIT dataset is OK to share
  (see `orange/data/README.md`).
- Add a couple of result screenshots to `assets/screenshots/` — it makes the repo look complete
  even before the dataset is added.

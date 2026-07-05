# kotonoha_ruby
Repo for KOtonoha website repository

A Ruby on Rails app for the Kotonoha university organization website.

## Setup

Requires a local PostgreSQL server. On Linux, connects over the local Unix
socket using peer auth for your current OS user by default — no password
needed. Override via `DATABASE_USERNAME` / `DATABASE_PASSWORD` / `DATABASE_HOST`
in `.env` if your setup needs it (e.g. a non-default Postgres user).

```
bundle install
cp .env.example .env   # then edit ADMIN_EMAIL / ADMIN_PASSWORD
bin/rails db:setup     # creates the db and runs db/seeds.rb
bin/rails server
```

Then visit http://localhost:3000. The home page has a "Sobre Kotonoha" button
that links to the about page, and an "Eventos" page listing club events.

## Admin login

There's a single admin account, created from `ADMIN_EMAIL` / `ADMIN_PASSWORD`
in `.env` by `db/seeds.rb` (no public sign-up). Sign in at `/users/sign_in` to
get access to creating, editing, hiding and deleting events, and to managing
the staff page. Everyone else sees those pages read-only.

## Staff page

`/staffs` lists club staff grouped by hierarchy (Presidente, Vicepresidente,
Directorio, etc.). Categories live in their own table (`StaffCategory`), not
a hardcoded list, so an admin can add new categories and reorder the whole
hierarchy (and reorder people within a category) from `/staff_categories` and
the up/down buttons on each staff card — no code changes needed.

## Deploying to Render (trial)

The repo includes a `render.yaml` Blueprint, so most of the setup is automatic:

1. Push this repo to GitHub (if it isn't already).
2. In the Render dashboard: **New > Blueprint**, point it at the repo. Render
   reads `render.yaml` and provisions a free Postgres database plus a free
   web service using the existing `Dockerfile`.
3. Once created, open the web service's **Environment** tab and set the three
   secrets Render left blank (`sync: false` in the blueprint means it won't
   invent a value):
   - `RAILS_MASTER_KEY` — run `cat config/master.key` locally and paste the value. **Never commit this file** (it's already gitignored).
   - `ADMIN_EMAIL` / `ADMIN_PASSWORD` — for the one seeded admin account.
4. Trigger a deploy (or it'll deploy automatically after you save the env vars). First boot runs migrations and seeds automatically — no shell access needed.
5. Visit the `.onrender.com` URL Render gives you.

**Known limitation for the trial**: the free plan's disk is ephemeral, so
uploaded event/staff photos are lost on every redeploy or restart. The
`render.yaml` has a commented-out `disk:` block for when that starts to
matter — it requires switching off the free plan.

Note: the DB connection env var is deliberately named `APP_DATABASE_URL`, not
`DATABASE_URL` — see the comment in `config/database.yml` for why (Rails
auto-detects a literal `DATABASE_URL` and parses it with a stricter internal
URI parser that rejects underscores, which Render's auto-generated database
usernames commonly contain).

## Tests

```
bundle exec rspec
```

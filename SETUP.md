# Knot setup

Knot works straight away on one device and saves to the browser. Do these steps once to sync phone and PC.

## 1. Create the Supabase project (free, about 5 minutes)

1. Go to https://supabase.com, sign in with GitHub, and click **New project**. Pick any name and password, and the region closest to you (Frankfurt).
2. Open **SQL Editor → New query**, paste everything from `schema.sql`, and click **Run**. It should say "Success".
3. Open **Authentication → Sign In / Providers → Email** and turn **Confirm email** off. This lets you sign in right away without a confirmation email. You can leave it on if you prefer.
4. Open **Project Settings → API** (or **Data API**) and copy:
   - **Project URL**, e.g. `https://abcd.supabase.co`
   - **anon public** key, the long one starting with `eyJ`. Do not use the `service_role` key.

## 2. Connect each device

1. Open Knot → **Settings → Sync**, paste the URL and key, and click **Save and connect**.
2. The first time, click **Create account**. On every other device, click **Sign in** with the same email and password.

If you put the URL and key into `SUPABASE_URL` / `SUPABASE_KEY` at the top of `index.html`, you'll only need to sign in on each device. The anon key is safe to publish because row-level security limits each account to its own data.

## 3. Install it like an app

- **Windows (Chrome or Edge):** open the site → ⋮ menu → **Install Knot**. It gets its own window and taskbar icon.
- **Android (Chrome):** ⋮ → **Add to Home screen / Install app**.
- **iPhone (Safari):** Share → **Add to Home Screen**.

## Notes

- A free Supabase project pauses after about a week without use. Open the dashboard and click **Restore**; nothing is lost. Settings → **Export JSON** makes a manual backup.
- Quick add understands: `today`, `tomorrow`, `fri`, `15 nov`, `15.11.`, `16:00`, `p1`–`p4`, `#Project`, `every day`, `weekdays`, `every week`, `every mon`.
- In notes, `[[Note title]]` links notes (clicking a link to a note that doesn't exist creates it), `#tag` adds a tag, and `- [ ]` makes a checklist.

# LOADOUT

A progressive overload tracker built for the gym, not for app stores.

## Why I built this

I was tired of bringing a notebook to the gym. Every other app I tried was either bloated with features I didn't need, or treated progressive overload as an afterthought — just a log with no intelligence about what comes next.

I also wanted the data to be useful outside the gym. I run a weekly health digest that pulls from my Garmin via Health Connect. LOADOUT's export drops straight into that workflow, so my strength training shows up alongside my runs and sleep data in one place.

Three problems, one small tool:
- No more notebook
- Actual progressive overload logic (not just logging)
- Easy export into my Claude weekly health email

## What it does

**Workout definitions** — set up named workouts (e.g. YMCA, DOWNSTAIRS) with exercises, target sets/reps, and starting weights. These persist and evolve over time.

**Session logging** — start a workout, mark each exercise as Hit / Miss / Skip. If you hit, it shows you what weight to target next session before you leave the gym. If you miss, it holds the weight and you repeat.

**Smart progression** — increments are calculated based on your bodyweight, age, current strength relative to bodyweight, and rep range. Early in a lift, weight jumps meaningfully each session. As you approach your ceiling, increments shrink. It follows how strength actually works.

**Export** — plain text readout of the past week, past month, or all time. Copy or download and paste it directly into a Claude prompt alongside Health Connect data for a full weekly health digest.

## Stack

- Vanilla HTML/JS — single file, no build step
- Hosted on GitHub Pages
- Supabase for auth (magic link), database, and row-level security
- IBM Plex Mono — because it looks like what it is

## Setup

1. Create a free project at [supabase.com](https://supabase.com)
2. Run the SQL schema (see `schema.sql`)
3. Add your Supabase project URL and anon key to the top of `index.html`
4. Add your GitHub Pages URL to Supabase → Authentication → URL Configuration
5. Push to GitHub Pages

No build process. No subscriptions.

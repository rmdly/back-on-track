# Back On Track

I'm very good at falling off the wagon. Eating, training, the boring daily
admin — it all slides at once, and then I try to fix the lot from memory and
get nowhere.

So this is one app for all of it. Plan the week, follow the day, stop relying
on remembering.

Rails 8, Hotwire, Tailwind and SQLite. Built in phases, still going.

## What's in it

- **Daily routine** — the small repeating things, laid out per day, with
  templates so I'm not retyping the same list every week.
- **Shopping** — items and lists, grouped by store.
- **Food** — meals with their ingredients, planned onto days, and a shopping
  list generated from whatever's been planned.
- **Training** — exercises, workout templates, planned sessions, then the real
  session with sets logged as they're done.
- **Calendar** — jump to any day, forwards or back.

## Running it

```bash
bin/setup
bin/rails db:seed
bin/dev
```

Sign in as `me@backontrack.app` with the password `password`.

`bin/rails test` runs 114 unit, controller and integration tests. There are 10
system tests on top of that, which need a browser.

## Where it's up to

| Phase | Area | State |
| ----- | ---- | ----- |
| 1 | Auth and daily routine | done |
| 2 | Shopping, calendar and day view | done |
| 3 | Food and meal planning | done |
| 4 | Training and workouts | done |
| 5 | Running | next |
| 6 | Polish | not started |

Every phase goes models → controllers and routes → views → seeds → tests, and
doesn't count as done until the tests are green. `TODO.md` has the detail for
what's coming.

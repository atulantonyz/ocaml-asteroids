# Chapter 2 — Game state and tick

Python original: `constants.py`, and the `while True:` loop in `main.py` with `dt = clock.tick(60) / 1000` and `updatable.update(dt)`

## Goal

Move the constants into their own module, introduce a `game` record behind a `ref`, route every change through `Game.controller`, and replace pygame's frame loop with a GLUT timer that delivers a real `dt` in seconds about 60 times per second. The window still shows nothing.

## Files to create or change

- **Create** `src/constants.ml`
- **Create** `src/game.ml`
- **Change** `src/main.ml`: use `Constants`, create `ref (Game.init ())`, add `tickTicker`, call `Game.render`

## What to implement

### `constants.ml`

All 13 values from `constants.py`, lower-cased. Sizes are `int` (GLUT wants ints), everything else `float`:

```ocaml
let screen_width = 1280
let screen_height = 720
let player_radius = 20.
let line_width = 2.
(* player_turn_speed 300., player_speed 200., asteroid_min_radius 20., asteroid_kinds 3 (int),
   asteroid_spawn_rate_seconds 0.8, asteroid_max_radius (min * kinds), shot_radius 5.,
   player_shoot_speed 500., player_shoot_cooldown_seconds 0.3 *)
```

### `game.ml`

```ocaml
type action =
    | Tick of float     (* dt in seconds *)

type game = {
    mutable spawn_timer: float;   (* more fields arrive in later chapters *)
}

let controller game = function
    | Tick dt -> game

let render game =
    GlClear.clear [ `color ];
    Glut.swapBuffers ()

let init () = { spawn_timer = 0. }
```

`controller` returns the (mutated) record, exactly like `ocaml-invader`. Keep the `Tick` branch empty for now.

### `main.ml`

- `elapsed () = Glut.get ~gtype:Glut.ELAPSED_TIME` — wall-clock **milliseconds** since `Glut.init`.
- A recursive one-shot timer that carries the last timestamp:

```ocaml
let rec tickTicker game last = fun ~value ->
    let now = elapsed () in
    let dt = float_of_int (now - last) /. 1000. in
    game := Game.controller !game (Game.Tick dt);
    Glut.timerFunc ~ms:16 ~cb:(tickTicker game now) ~value:0
```

- `initTickers ~game` arms it once with `elapsed ()` as the first `last`.
- `Glut.displayFunc ~cb:(fun () -> Game.render !game)`.
- `let game = ref (Game.init ())` in the entry point; pass `~w:Constants.screen_width ~h:Constants.screen_height`.

## Checkpoint

```bash
make build
make start
```

Same black window as chapter 1. If you want proof the tick runs, temporarily `Printf.printf "%f\n%!" dt` in the `Tick` branch and remove it before moving on.

## Pitfalls

- `Glut.timerFunc` is **one-shot**. The callback must re-register itself or you get exactly one tick.
- Compute `dt` from `ELAPSED_TIME`, not from the nominal 16 ms; GLUT timers drift, and pygame's `clock.tick` also reports real time.
- `Random.self_init ()` belongs in `main.ml` now, next to `Glut.init`, so later chapters do not forget it.
- No `unix` dependency is needed; do not add it to `buildDepends`.

## Next

Chapter 3 builds the maths: `vec2.ml` and `circleshape.ml`.

# Chapter 6 — Asteroids and the asteroid field

Python original: `asteroid.py` (`draw`, `update`) and `asteroidfield.py` (`edges`, `spawn`, `update`)

## Goal

Every 0.8 s a white circle of radius 20, 40 or 60 appears just outside a random edge and drifts across the screen at 40–100 px/s, veering up to 30 degrees from the edge normal.

## Files to create or change

- **Create** `src/asteroid.ml`
- **Create** `src/asteroidfield.ml`
- **Change** `src/game.ml`: `mutable asteroids`, `updateAsteroidField`, `advanceAll`, render loop

## What to implement

### `asteroid.ml`

```ocaml
type asteroid = Circleshape.circleshape

val create : position:Vec2.t -> velocity:Vec2.t -> radius:float -> asteroid
val advance : dt:float -> asteroid -> asteroid       (* = Circleshape.advance *)
val render : asteroid -> unit                        (* = Circleshape.renderCircle *)
```

Leave `split` for chapter 9.

### `asteroidfield.ml`

Transcribe the four `edges` as `(Vec2.t * (float -> Vec2.t)) list`. Each pair is *(direction of travel, position along that edge for `t` in `[0, 1]`)*:

```ocaml
({ Vec2.x = 1.; y = 0. },  fun t -> { Vec2.x = -. asteroid_max_radius; y = t *. h });  (* from the left  *)
({ Vec2.x = -1.; y = 0. }, fun t -> { Vec2.x = w +. asteroid_max_radius; y = t *. h }); (* from the right *)
({ Vec2.x = 0.; y = 1. },  fun t -> { Vec2.x = t *. w; y = -. asteroid_max_radius });   (* from the top   *)
({ Vec2.x = 0.; y = -1. }, fun t -> { Vec2.x = t *. w; y = h +. asteroid_max_radius }); (* from the bottom *)
```

`spawnRandom : unit -> asteroid` is `AsteroidField.update` minus the timer. Random mapping from Python:

| Python | OCaml |
|--------|-------|
| `random.choice(edges)` | `List.nth edges (Random.int (List.length edges))` |
| `random.randint(40, 100)` | `40 + Random.int 61` |
| `random.randint(-30, 30)` | `Random.int 61 - 30` |
| `random.uniform(0, 1)` | `Random.float 1.` |
| `random.randint(1, ASTEROID_KINDS)` | `1 + Random.int asteroid_kinds` |

Radius is `asteroid_min_radius *. float_of_int kind`.

### `game.ml`

- Fields `mutable asteroids: Asteroid.asteroid list` (init `[]`) and `mutable spawn_timer: float` (already there since chapter 2).
- `updateAsteroidField ~dt game`: `spawn_timer += dt`; when `> asteroid_spawn_rate_seconds`, reset to `0.` and append `Asteroidfield.spawnRandom ()`.
- `advanceAll ~dt game`: `game.asteroids <- List.map (Asteroid.advance ~dt) game.asteroids`.
- `Tick dt` now runs `updatePlayer`, `updateAsteroidField`, `advanceAll` in that order (the Python `updatable` group updates player, field, then asteroids in insertion order; the visible result is the same).
- `render`: `List.iter Asteroid.render game.asteroids` before the player.

## Checkpoint

```bash
make build
make start
```

Circles of three sizes enter from all four sides roughly every second and float across. Nothing collides yet; the ship passes through them.

## Pitfalls

- `Random.self_init ()` must have run (chapter 2) or every game spawns the same sequence.
- `Random.int 61` gives `0..60`; forgetting the `+ 40` / `- 30` offset is the usual mistake.
- The Python never removes off-screen asteroids and neither does this port. That is faithful, not a bug to fix in this walkthrough.
- The edge lambdas rely on the flipped `ortho2d`: `y = -. asteroid_max_radius` is *above* the window.

## Next

Chapter 7 gives the player a gun.

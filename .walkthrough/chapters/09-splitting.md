# Chapter 9 — Splitting

Python original: `Asteroid.split` in `asteroid.py`

## Goal

Large asteroids (radius 60) break into two medium ones (40), medium into two small ones (20), small ones vanish. Children leave at ±20–50 degrees from the parent's heading, 1.2× faster.

## Files to change

- **Change** `src/asteroid.ml`: `split`
- **Change** `src/game.ml`: `checkShotCollisions` appends `Asteroid.split asteroid`

## What to implement

### `asteroid.ml`

Python's `split` kills `self` and constructs children as a side effect. Here the caller removes the parent, so `split` is a pure function returning the children:

```ocaml
val split : asteroid -> asteroid list
```

```ocaml
let split (asteroid : asteroid) : asteroid list =
    let { Circleshape.position; velocity; radius } = asteroid in
    if radius <= Constants.asteroid_min_radius then []
    else
        let split_angle = 20. +. Random.float 30. in            (* uniform(20.0, 50.0) *)
        let v1 = Vec2.rotate velocity ~deg:split_angle in
        let v2 = Vec2.rotate velocity ~deg:(-. split_angle) in
        let split_radius = radius -. Constants.asteroid_min_radius in
        [ create ~position ~velocity:(Vec2.scale v1 1.2) ~radius:split_radius;
          create ~position ~velocity:(Vec2.scale v2 1.2) ~radius:split_radius ]
```

### `game.ml`

Add a `spawned` accumulator to `checkShotCollisions`:

```ocaml
| Some shot ->
    usedShots := shot :: !usedShots;
    spawned := !spawned @ Asteroid.split asteroid
...
game.asteroids <- !survivors @ !spawned;
```

Children are appended after survivors, so they are not re-tested against shots until the next tick, same as the Python (new sprites join the group after the loop).

## Checkpoint

```bash
make build
make start
```

Shoot a big rock: two medium ones fan out from the impact point, faster than the parent. Shoot a medium one: two small ones. Shoot a small one: gone.

## Pitfalls

- Destructure with `let { Circleshape.position; velocity; radius } = asteroid in`, not `let open Circleshape in`; opening the module shadows `create` with `Circleshape.create ~x ~y ~radius` and the build fails.
- `split_radius` is `radius - 20`, **not** `radius / 2`; that is how 60 ? 40 ? 20 works with three kinds.
- This is the last chapter. The Python original stops here: no score, no lives, no wrap-around, no sound.

## Done

Tick the box in `.walkthrough/progress.md`. Compare your `src/` with `.walkthrough/reference/src/` if you are curious; anything beyond this (culling off-screen objects, a score, a restart) is an extension you may ask for explicitly.

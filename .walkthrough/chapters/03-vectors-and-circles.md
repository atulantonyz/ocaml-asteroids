# Chapter 3  Vectors and circles

Python original: `pygame.Vector2` (used everywhere) and `circleshape.py`

## Goal

Replace `pygame.Vector2` with a tiny `Vec2` module and `CircleShape` with a record type shared by player, asteroids, and shots. Nothing new on screen yet; this chapter is about types that compile and a circle-drawing helper you will reuse three times.

## Files to create

- **Create** `src/vec2.ml`
- **Create** `src/circleshape.ml`

No change to `game.ml` or `main.ml`. obuild compiles every `.ml` under `src/`, so both new modules are type-checked by `make build` even before anything references them (chapter 4 does).

## What to implement

### `vec2.ml`

```ocaml
type t = { x: float; y: float }

val zero : t
val up : t                       (* { x = 0.; y = 1. } = pygame.Vector2(0, 1) *)
val add : t -> t -> t
val sub : t -> t -> t
val scale : t -> float -> t
val rotate : t -> deg:float -> t
val distance : t -> t -> float
```

`rotate` is the same matrix pygame uses, with the angle in **degrees**:

```ocaml
x' = x * cos r - y * sin r
y' = x * sin r + y * cos r      where r = deg * Float.pi / 180.
```

### `circleshape.ml`

```ocaml
type circleshape = {
    mutable position: Vec2.t;
    mutable velocity: Vec2.t;
    radius: float;
}

val create : x:float -> y:float -> radius:float -> circleshape   (* velocity = Vec2.zero *)
val collides_with : circleshape -> circleshape -> bool          (* distance <= r1 + r2 *)
val advance : dt:float -> circleshape -> circleshape            (* position += velocity * dt; returns the record *)
val renderCircle : circleshape -> unit
```

`renderCircle` is `pygame.draw.circle(screen, "white", position, radius, LINE_WIDTH)` in immediate mode:

```ocaml
GlMat.load_identity ();
GlMat.translate3 (shape.position.x, shape.position.y, 0.);
GlDraw.color (1., 1., 1.);
GlDraw.begins `line_loop;
(* 32 vertices at radius * (cos a, sin a), a = 2 pi i / 32 *)
GlDraw.ends ()
```

Line width is set once per frame in `Game.render` (chapter 4), not here.

## Checkpoint

```bash
make build
```

You should see `Compiling Vec2` and `Compiling Circleshape` in the output and no errors. `make start` shows the same black window as before.

## Pitfalls

- Field access on a record from another module needs the module path once: `{ Vec2.x = 1.; y = 0. }` or `shape.position.Vec2.x`. Type annotations (`(p : Vec2.t)`) also disambiguate.
- Python's `CircleShape` is a class hierarchy. Here `Player` will *embed* a `circleshape`; `Asteroid` and `Shot` will just *alias* the type. There is no inheritance to reproduce.
- `advance` mutates in place **and** returns the record, so `List.map (Circleshape.advance ~dt)` reads like the Python `update`.

## Next

Chapter 4 draws the player triangle at the center.

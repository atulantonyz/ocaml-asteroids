# Chapter 4 — Player

Python original: `player.py` (`__init__`, `triangle`, `draw`) and `Player(x=SCREEN_WIDTH / 2, y=SCREEN_HEIGHT / 2)` in `main.py`

## Goal

A white outlined triangle sits at the center of the window, pointing **down** (rotation 0 with pygame's y-down convention).

## Files to create or change

- **Create** `src/player.ml`
- **Change** `src/game.ml`: `mutable player`, `Player.render`, `GlDraw.line_width`, `init`

## What to implement

### `player.ml`

```ocaml
type player = {
    shape: Circleshape.circleshape;
    mutable rotation: float;
    mutable shot_cooldown: float;
}

val create : x:float -> y:float -> player     (* radius = Constants.player_radius, rotation = 0., cooldown = 0. *)
val triangle : player -> Vec2.t list          (* [a; b; c] in world coordinates *)
val render : player -> unit
```

`triangle` is a direct transcription:

```
forward = rotate up rotation
right   = rotate up (rotation + 90) * (radius / 1.5)
a = position + forward * radius
b = position - forward * radius - right
c = position - forward * radius + right
```

`render` draws the three points as a `line_loop` **without** translating (the points are already absolute):

```ocaml
GlMat.load_identity ();
GlDraw.color (1., 1., 1.);
GlDraw.begins `line_loop;
List.iter (fun (p : Vec2.t) -> GlDraw.vertex2 (p.x, p.y)) (triangle player);
GlDraw.ends ()
```

### `game.ml`

- Add `mutable player: Player.player` to the record.
- `init ()` creates the player at `(float screen_width / 2, float screen_height / 2)`.
- `render`: after `GlClear.clear`, call `GlDraw.line_width Constants.line_width`, then `Player.render game.player`, then `Glut.swapBuffers ()`.

## Checkpoint

```bash
make build
make start
```

A small white triangle in the middle, apex pointing toward the bottom of the window.

## Pitfalls

- If the apex points **up**, your `ortho2d` from chapter 1 is not flipped.
- `open Constants` at the top of `player.ml` keeps the code close to the Python; do not `open Circleshape` (it would shadow `create`).
- `GlDraw.line_width` is global GL state. Setting it once per frame in `Game.render` is enough for every outline drawn afterwards.

## Next

Chapter 5 makes the triangle turn and move with the keyboard.

# Chapter 1 — Empty window

Python original: `main.py` (`pygame.init`, `set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))`, `screen.fill("black")`, `display.flip()`)

## Goal

Open a 1280×720 GLUT window titled `OCaml Asteroids`, set a 2D orthographic projection whose **y axis points down** (like pygame), clear to black every frame, and swap buffers. No game state yet.

## Files to create

- `src/main.ml` — the only source file this chapter

Do **not** create `game.ml`, `constants.ml`, or call `Game.init` yet. Hard-code `1280` and `720` here; chapter 2 moves them to `constants.ml`.

## What to implement

1. `Glut.init Sys.argv` at startup (ignore the return value).
2. `initDisplay ~w ~h ~title`:
   - `Glut.initDisplayMode ~double_buffer:true ~depth:true ~alpha:true ()`
   - `Glut.initWindowSize ~w ~h`
   - `ignore (Glut.createWindow ~title)` — it returns the window id
   - `Glut.idleFunc ~cb:(Some Glut.postRedisplay)` so the window keeps redrawing
3. `initView ~w ~h`:
   - `GlDraw.viewport ~x:0 ~y:0 ~w ~h`
   - `GlMat.mode \`projection`, `GlMat.load_identity ()`
   - `GluMat.ortho2d ~x:(0.0, float_of_int w) ~y:(float_of_int h, 0.0)` — note the **swapped y pair**: top of the window is `y = 0`, bottom is `y = 720`, exactly as in pygame
   - `GlMat.mode \`modelview`
4. `Glut.displayFunc ~cb:(fun () -> GlClear.clear [ \`color ]; Glut.swapBuffers ())`
5. `Glut.mainLoop` as the last call
6. Window size **1280×720**, title `"OCaml Asteroids"`

Skip timers and keyboard callbacks until chapters 2 and 5.

## Checkpoint

```bash
make build
make start
```

You should see a blank black 1280×720 window. Close it with the window chrome (Esc comes in chapter 5).

## Pitfalls

- GLUT callbacks use labeled arguments (`~key ~x ~y` for keys, `~value` for timers). Match those labels when you add them later.
- The flipped `ortho2d` is what lets every Python coordinate, rotation sign, and edge formula be copied verbatim. Do not "fix" it to `(0., 720.)`.
- `idleFunc` drives continuous redraw. Without it, the window may never paint.
- `ocaml-asteroids.obuild` expects `src/main.ml`. The `src` directory is created when you add that file.

## Next

Chapter 2 introduces `constants.ml`, `game.ml`, a `ref` to game state, and the 60 fps tick.

# Chapter 5 — Input and movement

Python original: `player.py` (`rotate`, `move`, the key checks in `update`), driven by `pygame.key.get_pressed()`

## Goal

Hold `A`/`D` to rotate at 300 deg/s, `W`/`S` to move forward/backward at 200 px/s. Esc closes the window. Space does nothing yet.

## Files to change

- **Change** `src/player.ml`: `rotate ~dt`, `move ~dt`
- **Change** `src/game.ml`: `Press`/`Release` actions, `mutable held`, `updatePlayer`
- **Change** `src/main.ml`: `keyboardFunc`, `keyboardUpFunc`, `ignoreKeyRepeat`

## What to implement

### `player.ml`

```ocaml
let rotate ~dt player = player.rotation <- player.rotation +. player_turn_speed *. dt
let move ~dt player =
    (* position += rotate up rotation * player_speed * dt *)
```

Python passes `-dt` for the reverse direction; do the same.

### `game.ml` — held keys stand in for `key.get_pressed()`

pygame polls the keyboard each frame. GLUT only tells you about edges, so keep a list of keys currently down:

```ocaml
type action =
    | Press of int      (* ASCII code from Glut.keyboardFunc *)
    | Release of int    (* ASCII code from Glut.keyboardUpFunc *)
    | Tick of float
```

- Field `mutable held: int list`, initialised to `[]`.
- `Press k` adds `k` if absent; `Release k` filters it out.
- `let key_a = Char.code 'a'` and likewise `d`, `w`, `s`; `key_space = 32`.
- `updatePlayer ~dt game` mirrors `Player.update`: decrement `shot_cooldown`, then

```ocaml
if isHeld game key_a then Player.rotate ~dt:(-. dt) player;
if isHeld game key_d then Player.rotate ~dt player;
if isHeld game key_w then Player.move ~dt player;
if isHeld game key_s then Player.move ~dt:(-. dt) player;
```

- `Tick dt` calls `updatePlayer ~dt game`.

### `main.ml`

```ocaml
let keyDown game = fun ~key ~x ~y ->
    match key with
    | 27 -> exit 0                                      (* Esc *)
    | _ -> game := Game.controller !game (Game.Press key)

let keyUp game = fun ~key ~x ~y ->
    game := Game.controller !game (Game.Release key)

let initInputs ~game =
    Glut.ignoreKeyRepeat ~ignore:true;
    Glut.keyboardFunc ~cb:(keyDown game);
    Glut.keyboardUpFunc ~cb:(keyUp game)
```

Call `initInputs ~game` from `initEngine`.

## Checkpoint

```bash
make build
make start
```

`A`/`D` spin the triangle, `W` moves it toward its apex, `S` backs it up. Holding two keys works (turn while thrusting). Esc quits.

## Pitfalls

- Letters arrive as ASCII ints (`97` for `a`); GLUT reports them **lower-case** unless Shift is held, so Caps Lock will break input. That matches the Python, which only checks `K_a`.
- Without `ignoreKeyRepeat`, the OS autorepeat sends extra `Press` events; harmless with the "add if absent" rule, but noisy.
- `exit 0` is the only quit path in `ocaml-invader` too. The Python original relies on the window close button, which still works here.
- Movement uses `dt`, so it is frame-rate independent; if the ship jumps, your `dt` is in milliseconds instead of seconds.

## Next

Chapter 6 fills the screen with drifting asteroids.

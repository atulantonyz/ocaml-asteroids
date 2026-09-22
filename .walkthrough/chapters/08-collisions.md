# Chapter 8 — Collisions

Python original: the two `for asteroid in asteroids:` loops in `main.py` (`collides_with(player)` ? `"Game over!"` + `sys.exit()`; `collides_with(shot)` ? `asteroid.split()` + `shot.kill()`)

## Goal

An asteroid touching the ship prints `Game over!` and exits. A shot touching an asteroid removes both. (Splitting arrives next chapter; for now a hit asteroid just disappears.)

## Files to change

- **Change** `src/game.ml`: `checkPlayerCollisions`, `checkShotCollisions`, call both from `Tick`

## What to implement

### Player vs asteroids

```ocaml
let checkPlayerCollisions game =
    let player = game.player.Player.shape in
    if List.exists (fun asteroid -> Circleshape.collides_with asteroid player) game.asteroids then begin
        print_endline "Game over!";
        exit 0
    end
```

### Shots vs asteroids

For each asteroid, look for the first shot that overlaps it (`List.find_opt`). Keep asteroids with no hit; remember which shots were used; drop those shots afterwards:

```ocaml
let checkShotCollisions game =
    let hitBy asteroid = List.find_opt (fun shot -> Circleshape.collides_with asteroid shot) game.shots in
    let survivors = ref [] and usedShots = ref [] in
    List.iter (fun asteroid ->
        match hitBy asteroid with
        | None -> survivors := !survivors @ [ asteroid ]
        | Some shot -> usedShots := shot :: !usedShots
    ) game.asteroids;
    game.asteroids <- !survivors;
    game.shots <- List.filter (fun shot -> not (List.memq shot !usedShots)) game.shots
```

Use `List.memq` (physical equality) for shots, the same way `ocaml-invader` uses `==` on records: two shots can have identical coordinates.

### `Tick`

Order inside `Tick dt`: `updatePlayer`, `updateAsteroidField`, `advanceAll`, `checkPlayerCollisions`, `checkShotCollisions`. That matches `main.py`: update everything, then the player check, then the shot check.

## Checkpoint

```bash
make build
make start
```

Shooting an asteroid makes it and the shot vanish. Flying into one prints `Game over!` in the terminal and the window closes.

## Pitfalls

- Python's `sys.exit()` is the whole end-game. No score, no restart screen; do not add one in this walkthrough.
- If a single shot could remove two overlapping asteroids in one frame, that is also what the Python does (the inner loop does not `break`). The `find_opt` version reproduces it because the shot is only filtered out after the asteroid loop.
- `game.player.Player.shape` is the qualified field access; `game.player.shape` also works if `Player` is opened or the type is known.

## Next

Chapter 9 turns a hit asteroid into two smaller, faster ones.

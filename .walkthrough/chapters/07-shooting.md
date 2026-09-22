# Chapter 7 — Shooting

Python original: `shot.py`, plus `Player.shoot` and the Space branch of `Player.update`

## Goal

Holding Space fires a radius-5 circle from the ship's position in its facing direction at 500 px/s, at most once every 0.3 s.

## Files to create or change

- **Create** `src/shot.ml`
- **Change** `src/player.ml`: `shoot`
- **Change** `src/game.ml`: `mutable shots`, cooldown + Space in `updatePlayer`, advance and render shots

## What to implement

### `shot.ml`

```ocaml
type shot = Circleshape.circleshape

val create : position:Vec2.t -> velocity:Vec2.t -> shot   (* radius = Constants.shot_radius *)
val advance : dt:float -> shot -> shot
val render : shot -> unit
```

Same shape as `asteroid.ml`. Because `Player` depends on `Shot`, `shot.ml` must not depend on `Player` (obuild resolves the order for you; a cycle is a build error).

### `player.ml`

```ocaml
let shoot player =
    let velocity = Vec2.scale (Vec2.rotate Vec2.up ~deg:player.rotation) player_shoot_speed in
    Shot.create ~position:player.shape.position ~velocity
```

Python's `Shot(*self.position)` copies the ship position; `Vec2.t` is immutable so sharing the value is safe.

### `game.ml`

- Field `mutable shots: Shot.shot list`, init `[]`.
- In `updatePlayer`, after the four movement keys:

```ocaml
if isHeld game key_space && player.shot_cooldown <= 0. then begin
    player.shot_cooldown <- player_shoot_cooldown_seconds;
    game.shots <- game.shots @ [ Player.shoot player ]
end
```

  (`shot_cooldown <- shot_cooldown -. dt` should already be the first line of `updatePlayer` from chapter 5.)
- `advanceAll`: also `game.shots <- List.map (Shot.advance ~dt) game.shots`.
- `render`: `List.iter Shot.render game.shots` between asteroids and player.

## Checkpoint

```bash
make build
make start
```

Space fires small circles out of the apex, about three per second while held. Shots fly through asteroids for now.

## Pitfalls

- Python checks `if self.shot_cooldown > 0.0: return`; here the condition is inverted and combined with the key test. Same behaviour.
- The cooldown only counts down inside `updatePlayer`; if you moved that line, shots either never fire or spam.
- Shots are never culled off-screen (faithful to the original). With `@ [ ... ]` appends this is O(n) per shot, which is fine at this scale.

## Next

Chapter 8 makes shots and asteroids hit things.

# OCaml Asteroids

An Asteroids clone in OCaml and OpenGL (LablGL / GLUT), rebuilt as a **guided walkthrough**.

This project ports the pygame game in [`../Asteroids`](../Asteroids) to the stack used by [`../ocaml-invader`](../ocaml-invader): Docker, `obuild`, LablGL and GLUT. The Docker image, `obuild` config, and Makefile are already here. Game source is not: you write it chapter by chapter.

## Start here

In Cursor Agent chat, say:

```
Begin the OCaml Asteroids walkthrough from chapter 1
```

The agent teaches one chapter at a time. After each chapter you should have something you can build and see.

**Spoilers:** [`.walkthrough/reference/src/`](.walkthrough/reference/src/) is the finished game. Do not open it unless you want the full solution. The agent will not paste those files unless you are stuck or you ask.

Progress is tracked in [`.walkthrough/progress.md`](.walkthrough/progress.md). Chapter briefs live in [`.walkthrough/chapters/`](.walkthrough/chapters/).

## Chapters

| # | Chapter | Python file mirrored | You will be able to see |
|---|---------|----------------------|-------------------------|
| 0 | [Project setup](.walkthrough/chapters/00-project-setup.md) | `pyproject.toml` | Docker image builds (`make install`). No game code. |
| 1 | [Empty window](.walkthrough/chapters/01-empty-window.md) | `main.py` (display) | 1280×720 black window, y-down projection |
| 2 | [Game state and tick](.walkthrough/chapters/02-game-state-and-tick.md) | `constants.py`, `main.py` (loop) | `Game.controller`, 60 fps `dt` timer |
| 3 | [Vectors and circles](.walkthrough/chapters/03-vectors-and-circles.md) | `circleshape.py`, `Vector2` | `Vec2`, `Circleshape`, circle outline helper |
| 4 | [Player](.walkthrough/chapters/04-player.md) | `player.py` (draw) | White triangle at the center |
| 5 | [Input and movement](.walkthrough/chapters/05-input-and-movement.md) | `player.py` (update) | A/D turn, W/S move, Esc quits |
| 6 | [Asteroids and field](.walkthrough/chapters/06-asteroids-and-field.md) | `asteroid.py`, `asteroidfield.py` | Circles drift in from the edges every 0.8 s |
| 7 | [Shooting](.walkthrough/chapters/07-shooting.md) | `shot.py`, `Player.shoot` | Space fires with a 0.3 s cooldown |
| 8 | [Collisions](.walkthrough/chapters/08-collisions.md) | `main.py` (loops) | Shots remove asteroids; crash prints `Game over!` |
| 9 | [Splitting](.walkthrough/chapters/09-splitting.md) | `Asteroid.split` | Big rocks break into two faster smaller ones |

## Controls

`A` / `D` rotate, `W` / `S` thrust forward / back, `Space` shoot, `Esc` quit.

## Project setup (already done)

| File | Role |
|------|------|
| [`Dockerfile`](Dockerfile) | `ocaml/opam2:debian-10-ocaml-4.08` plus `lablgl`, `obuild`, freeglut/GLU |
| [`ocaml-asteroids.obuild`](ocaml-asteroids.obuild) | Executable `ocaml-asteroids`, `main-is: main.ml`, `src-dir: src` |
| [`Makefile`](Makefile) | Docker-wrapped `install` / `build` / `start` |

```bash
make install   # build the Docker image (once)
make build     # obuild configure && obuild build
make start     # build, run ./ocaml-asteroids, then clean
```

Host OpenGL/GLUT is required to *run* the binary (`freeglut3` on Debian/Ubuntu). If start fails, see `make start-advice` / `make deps-install`.

This walkthrough keeps **obuild + LablGL/GLUT** and the Python game's exact behavior. It does not port `logger.py`, and does not add score, lives, wrap-around, or sound.

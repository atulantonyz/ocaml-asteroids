# OCaml Asteroids

An Asteroids clone in OCaml and OpenGL (LablGL / GLUT). The finished game is in [`src/`](src/). It uses Docker, `obuild`, LablGL, and GLUT, and matches the behavior of the pygame Asteroids game: no score, lives, wrap-around, or sound. `logger.py` from that original is not ported.

## Run the game

Linux or WSL2, Docker, and a display. On WSL2 that means WSLg or an X server.

The window is the binary `./ocaml-asteroids` on the host, so install the host GLUT library first (`freeglut3` on Debian and Ubuntu; on newer Ubuntu the package that provides `libglut.so.3` may have another name):

```bash
sudo apt-get install freeglut3
```

Then:

```bash
make install   # once: build a local image named ocamlasteroids
make start     # compile in that image, open the game, then delete the build
```

`make install` does not download an `ocamlasteroids` image. It builds one from the [`Dockerfile`](Dockerfile). Docker Hub is used only for the base image `ocaml/opam2:debian-10-ocaml-4.08`.

`make build` only compiles, and it needs a real terminal (`docker run -i -t`). `make start` always runs `make clean` after the game exits, so the binary is not left behind.

| File | Role |
|------|------|
| [`Dockerfile`](Dockerfile) | `ocaml/opam2:debian-10-ocaml-4.08` plus `lablgl`, `obuild`, freeglut/GLU |
| [`ocaml-asteroids.obuild`](ocaml-asteroids.obuild) | Executable `ocaml-asteroids`, `main-is: main.ml`, `src-dir: src` |
| [`Makefile`](Makefile) | Docker-wrapped `install` / `build` / `start` |

## Controls

`A` / `D` rotate, `W` / `S` thrust forward / back, `Space` shoot, `Esc` quit. Keys are lowercase; Caps Lock makes them miss.

## Walkthrough

This repo was built one chapter at a time. To rebuild it that way in Cursor Agent chat, say:

```
Begin the OCaml Asteroids walkthrough from chapter 1
```

The agent teaches one chapter at a time. [`.walkthrough/reference/src/`](.walkthrough/reference/src/) is a second copy of the finished game. Progress is tracked in [`.walkthrough/progress.md`](.walkthrough/progress.md). Chapter briefs live in [`.walkthrough/chapters/`](.walkthrough/chapters/).

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

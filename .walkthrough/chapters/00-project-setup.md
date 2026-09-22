# Chapter 0 — Project setup

Python original: `pyproject.toml` (`pygame==2.6.1`), `main.py` skeleton

## Goal

Understand the stack that is already in the repo. There is no game code yet. After this chapter you can build the Docker image.

## Already in the repo

| File | What it does |
|------|----------------|
| `Dockerfile` | `FROM ocaml/opam2:debian-10-ocaml-4.08`. Installs `m4`, `freeglut3-dev`, `libglu1-mesa-dev`, `mesa-common-dev`, then `opam install lablgl obuild core`. Same image recipe as `ocaml-invader`. |
| `ocaml-asteroids.obuild` | Package `ocaml-asteroids`. Executable `main-is: main.ml`, `src-dir: src`, `buildDepends: lablgl, lablgl.glut`. |
| `Makefile` | `install` builds the image `ocamlasteroids`. `build` runs `obuild configure && obuild build` in the container. `start` builds, runs `./ocaml-asteroids`, then cleans. |

`obuild` is the build tool (not Dune). LablGL talks to OpenGL; `lablgl.glut` gives the window, keyboard, and timers. In pygame terms: `pygame.display` + `pygame.draw` become LablGL, `pygame.event` / `pygame.key` / `pygame.time.Clock` become GLUT callbacks.

## Files to create

None. Do not create `src/` yet.

## Checkpoint

```bash
make install
```

That should finish without error. `make build` will fail until chapter 1 adds `src/main.ml`.

## Pitfalls

- Building the image needs Docker (on WSL, enable Docker Desktop WSL integration). Running the game later also needs host GLUT (`freeglut3` on Debian/Ubuntu). Use `make deps-install` / `make start-advice` if `./ocaml-asteroids` cannot open a display.
- `apt-get update` on this image 404s unless `/etc/apt/sources.list` points at `archive.debian.org` (Debian 10 is EOL). The Dockerfile already does this. Keep `ocaml/opam2:debian-10-ocaml-4.08`; do not bump the OCaml image.
- Do not replace obuild with dune, or add an `.opam` file.
- `core` is installed in the image but is **not** a `buildDepends` of the game. Leave it unused.
- OCaml is 4.08 inside the container: `List.filter_map`, `List.find_opt`, `Float.pi`, `Random.self_init` are available; newer stdlib additions are not.

## Next

Chapter 1 creates `src/main.ml` and an empty GLUT window.

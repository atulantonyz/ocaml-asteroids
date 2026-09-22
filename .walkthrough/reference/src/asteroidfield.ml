open Constants

let w = float_of_int screen_width
let h = float_of_int screen_height

(* (direction the asteroid travels, position along that edge for t in [0, 1]) *)
let edges : (Vec2.t * (float -> Vec2.t)) list = [
    ({ Vec2.x = 1.; y = 0. }, fun t -> { Vec2.x = -. asteroid_max_radius; y = t *. h });
    ({ Vec2.x = -1.; y = 0. }, fun t -> { Vec2.x = w +. asteroid_max_radius; y = t *. h });
    ({ Vec2.x = 0.; y = 1. }, fun t -> { Vec2.x = t *. w; y = -. asteroid_max_radius });
    ({ Vec2.x = 0.; y = -1. }, fun t -> { Vec2.x = t *. w; y = h +. asteroid_max_radius });
]

(* Spawn a new asteroid at a random edge, like AsteroidField.update *)
let spawnRandom () =
    let (direction, positionAt) = List.nth edges (Random.int (List.length edges)) in
    let speed = float_of_int (40 + Random.int 61) in            (* randint(40, 100) *)
    let velocity = Vec2.scale direction speed in
    let velocity = Vec2.rotate velocity ~deg:(float_of_int (Random.int 61 - 30)) in  (* randint(-30, 30) *)
    let position = positionAt (Random.float 1.) in              (* uniform(0, 1) *)
    let kind = 1 + Random.int asteroid_kinds in                  (* randint(1, ASTEROID_KINDS) *)
    Asteroid.create ~position ~velocity ~radius:(asteroid_min_radius *. float_of_int kind)

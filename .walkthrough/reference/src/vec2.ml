type t = {
    x: float;
    y: float;
}

let zero = { x = 0.; y = 0. }

(* pygame.Vector2(0, 1): "forward" for the player before any rotation *)
let up = { x = 0.; y = 1. }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }

let sub a b = { x = a.x -. b.x; y = a.y -. b.y }

let scale v k = { x = v.x *. k; y = v.y *. k }

(* Same matrix as pygame.Vector2.rotate (angle in degrees) *)
let rotate v ~deg =
    let rad = deg *. Float.pi /. 180. in
    let c = cos rad and s = sin rad in
    {
        x = v.x *. c -. v.y *. s;
        y = v.x *. s +. v.y *. c;
    }

let distance a b =
    let d = sub a b in
    sqrt (d.x *. d.x +. d.y *. d.y)

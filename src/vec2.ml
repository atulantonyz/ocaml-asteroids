type t = { x : float; y : float }

let zero = { x = 0.; y = 0. }

(* pygame.Vector2(0, 1): "forward" before any rotation*)
let up = { x = 0.; y = 1. }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }
let scale v k = { x = v.x *. k; y = v.y *. k }

let rotate v ~deg =
    let rad = deg *. Float.pi /. 180. in
    let c = cos rad and s = sin rad in
    { x = v.x *. c -. v.y *. s; y = v.x *. s +. v.y *. c }

let distance a b =
    let dx = a.x -. b.x and dy = a.y -. b.y in
    sqrt (dx *. dx +. dy *. dy)
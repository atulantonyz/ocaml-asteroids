type action =
    | Tick of float

type game = {
    mutable spawn_timer : float;
}

let controller game = function
    | Tick _dt -> game

let render _game =
    GlClear.clear [ `color ];
    Glut.swapBuffers ()

let init () = { spawn_timer = 0. }

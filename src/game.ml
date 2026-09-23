type action =
    | Tick of float

type game = {
    mutable player : Player.player;
    mutable spawn_timer : float;
}

let controller game = function
    | Tick _dt -> game

let render game =
    GlClear.clear [ `color ];
    GlDraw.line_width Constants.line_width;
    Player.render game.player;
    Glut.swapBuffers ()

let init () = {
    player = Player.create
        ~x:(float_of_int Constants.screen_width /. 2.)
        ~y:(float_of_int Constants.screen_height /. 2.);
    spawn_timer = 0.;
}

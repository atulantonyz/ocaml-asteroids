type action =
    | Press of int
    | Release of int
    | Tick of float

type game = {
    mutable player : Player.player;
    mutable spawn_timer : float;
    mutable held : int list;
}

let key_a = Char.code 'a'
let key_d = Char.code 'd'
let key_w = Char.code 'w'
let key_s = Char.code 's'
let key_space = 32

let isHeld game key = List.mem key game.held

let updatePlayer ~dt game =
    let player = game.player in
    player.shot_cooldown <- player.shot_cooldown -. dt;
    if isHeld game key_a then Player.rotate ~dt:(-. dt) player;
    if isHeld game key_d then Player.rotate ~dt player;
    if isHeld game key_w then Player.move ~dt player;
    if isHeld game key_s then Player.move ~dt:(-. dt) player

let controller game = function
    | Press key ->
        if not (List.mem key game.held) then game.held <- key :: game.held;
        game
    | Release key ->
        game.held <- List.filter (fun k -> k <> key) game.held;
        game
    | Tick dt ->
        updatePlayer ~dt game;
        game

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
    held = [];
}

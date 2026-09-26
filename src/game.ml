type action =
    | Press of int
    | Release of int
    | Tick of float

type game = {
    mutable player : Player.player;
    mutable spawn_timer : float;
    mutable held : int list;
    mutable asteroids : Asteroid.asteroid list;
    mutable shots : Shot.shot list;
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
    if isHeld game key_s then Player.move ~dt:(-. dt) player;
    if isHeld game key_space && player.shot_cooldown <= 0. then begin
    player.shot_cooldown <- Constants.player_shoot_cooldown_seconds;
    game.shots <- game.shots @ [ Player.shoot player ]
end

let updateAsteroidField ~dt game =
    game.spawn_timer <- game.spawn_timer +. dt;
    if game.spawn_timer > Constants.asteroid_spawn_rate_seconds then begin
        game.spawn_timer <- 0.;
        game.asteroids <- game.asteroids @ [ Asteroidfield.spawnRandom () ]
    end

let advanceAll ~dt game =
    game.asteroids <- List.map (Asteroid.advance ~dt) game.asteroids;
    game.shots <- List.map (Shot.advance ~dt) game.shots

let controller game = function
    | Press key ->
        if not (List.mem key game.held) then game.held <- key :: game.held;
        game
    | Release key ->
        game.held <- List.filter (fun k -> k <> key) game.held;
        game
    | Tick dt ->
        updatePlayer ~dt game;
        updateAsteroidField ~dt game;
        advanceAll ~dt game;
        game

let render game =
    GlClear.clear [ `color ];
    GlDraw.line_width Constants.line_width;
    List.iter Asteroid.render game.asteroids;
    List.iter Shot.render game.shots;
    Player.render game.player;
    Glut.swapBuffers ()

let init () = {
    player = Player.create
        ~x:(float_of_int Constants.screen_width /. 2.)
        ~y:(float_of_int Constants.screen_height /. 2.);
    spawn_timer = 0.;
    held = [];
    asteroids = [];
    shots = [];
}

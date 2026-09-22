open Constants

type action =
    | Press of int      (* ASCII key code from Glut.keyboardFunc *)
    | Release of int    (* ASCII key code from Glut.keyboardUpFunc *)
    | Tick of float     (* dt in seconds, like pygame's clock.tick(60) / 1000 *)

type game = {
    mutable player: Player.player;
    mutable asteroids: Asteroid.asteroid list;
    mutable shots: Shot.shot list;
    mutable spawn_timer: float;
    mutable held: int list;     (* keys currently down; stands in for pygame.key.get_pressed() *)
}

let key_a = Char.code 'a'
let key_d = Char.code 'd'
let key_w = Char.code 'w'
let key_s = Char.code 's'
let key_space = 32

let isHeld game key = List.mem key game.held

(* Player.update in the original *)
let updatePlayer ~dt game =
    let player = game.player in
    player.shot_cooldown <- player.shot_cooldown -. dt;
    if isHeld game key_a then Player.rotate ~dt:(-. dt) player;
    if isHeld game key_d then Player.rotate ~dt player;
    if isHeld game key_w then Player.move ~dt player;
    if isHeld game key_s then Player.move ~dt:(-. dt) player;
    if isHeld game key_space && player.shot_cooldown <= 0. then begin
        player.shot_cooldown <- player_shoot_cooldown_seconds;
        game.shots <- game.shots @ [ Player.shoot player ]
    end

(* AsteroidField.update in the original *)
let updateAsteroidField ~dt game =
    game.spawn_timer <- game.spawn_timer +. dt;
    if game.spawn_timer > asteroid_spawn_rate_seconds then begin
        game.spawn_timer <- 0.;
        game.asteroids <- game.asteroids @ [ Asteroidfield.spawnRandom () ]
    end

let advanceAll ~dt game =
    game.asteroids <- List.map (Asteroid.advance ~dt) game.asteroids;
    game.shots <- List.map (Shot.advance ~dt) game.shots

let checkPlayerCollisions game =
    let player = game.player.Player.shape in
    if List.exists (fun asteroid -> Circleshape.collides_with asteroid player) game.asteroids then begin
        print_endline "Game over!";
        exit 0
    end

(* For every asteroid hit by a shot: drop the shot, replace the asteroid by Asteroid.split *)
let checkShotCollisions game =
    let hitBy asteroid = List.find_opt (fun shot -> Circleshape.collides_with asteroid shot) game.shots in
    let survivors = ref [] and spawned = ref [] and usedShots = ref [] in
    List.iter (fun asteroid ->
        match hitBy asteroid with
        | None -> survivors := !survivors @ [ asteroid ]
        | Some shot ->
            usedShots := shot :: !usedShots;
            spawned := !spawned @ Asteroid.split asteroid
    ) game.asteroids;
    game.asteroids <- !survivors @ !spawned;
    game.shots <- List.filter (fun shot -> not (List.memq shot !usedShots)) game.shots

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
        checkPlayerCollisions game;
        checkShotCollisions game;
        game

let render game =
    GlClear.clear [ `color ];
    GlDraw.line_width line_width;
    List.iter Asteroid.render game.asteroids;
    List.iter Shot.render game.shots;
    Player.render game.player;
    Glut.swapBuffers ()

let init () = {
    player = Player.create
        ~x:(float_of_int screen_width /. 2.)
        ~y:(float_of_int screen_height /. 2.);
    asteroids = [];
    shots = [];
    spawn_timer = 0.;
    held = [];
}

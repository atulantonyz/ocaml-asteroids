open Constants

type player = {
    shape: Circleshape.circleshape;
    mutable rotation: float;
    mutable shot_cooldown: float;
}

let create ~x ~y = {
    shape = Circleshape.create ~x ~y ~radius:player_radius;
    rotation = 0.;
    shot_cooldown = 0.;
}

(* pygame Player.triangle: three world-space vertices *)
let triangle player =
    let position = player.shape.position and radius = player.shape.radius in
    let forward = Vec2.rotate Vec2.up ~deg:player.rotation in
    let right = Vec2.scale (Vec2.rotate Vec2.up ~deg:(player.rotation +. 90.)) (radius /. 1.5) in
    let a = Vec2.add position (Vec2.scale forward radius) in
    let b = Vec2.sub (Vec2.sub position (Vec2.scale forward radius)) right in
    let c = Vec2.add (Vec2.sub position (Vec2.scale forward radius)) right in
    [ a; b; c ]

(* pygame.draw.polygon(screen, "white", points, LINE_WIDTH) *)
let render player =
    GlMat.load_identity ();
    GlDraw.color (1., 1., 1.);
    GlDraw.begins `line_loop;
    List.iter (fun (p : Vec2.t) -> GlDraw.vertex2 (p.x, p.y)) (triangle player);
    GlDraw.ends ()

(* rotate the player by dt degrees *)
let rotate ~dt player =
    player.rotation <- player.rotation +. player_turn_speed *. dt

(* move the player by dt units forward along its forward vector *)
let move ~dt player =
    let forward = Vec2.rotate Vec2.up ~deg:player.rotation in
    let step = Vec2.scale forward (player_speed *. dt) in
    player.shape.position <- Vec2.add player.shape.position step


(* Base "class" for game objects: a position, a velocity and a radius *)
type circleshape = {
    mutable position: Vec2.t;
    mutable velocity: Vec2.t;
    radius: float;
}

let create ~x ~y ~radius = {
    position = { Vec2.x = x; y };
    velocity = Vec2.zero;
    radius;
}

let collides_with a b =
    Vec2.distance a.position b.position <= a.radius +. b.radius

(* position += velocity * dt *)
let advance ~dt shape =
    shape.position <- Vec2.add shape.position (Vec2.scale shape.velocity dt);
    shape

let segments = 32

(* pygame.draw.circle(screen, "white", position, radius, LINE_WIDTH) *)
let renderCircle shape =
    GlMat.load_identity ();
    GlMat.translate3 (shape.position.x, shape.position.y, 0.);
    GlDraw.color (1., 1., 1.);
    GlDraw.begins `line_loop;
    for i = 0 to segments - 1 do
        let a = 2. *. Float.pi *. float_of_int i /. float_of_int segments in
        GlDraw.vertex2 (shape.radius *. cos a, shape.radius *. sin a)
    done;
    GlDraw.ends ()

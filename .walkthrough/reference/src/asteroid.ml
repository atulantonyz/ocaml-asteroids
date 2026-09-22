type asteroid = Circleshape.circleshape

let create ~position ~velocity ~radius : asteroid = {
    Circleshape.position;
    velocity;
    radius;
}

let advance = Circleshape.advance

let render (asteroid : asteroid) = Circleshape.renderCircle asteroid

(* The asteroid itself is removed by the caller. Returns its children:
   nothing for the smallest kind, two smaller and faster ones otherwise. *)
let split (asteroid : asteroid) : asteroid list =
    let { Circleshape.position; velocity; radius } = asteroid in
    if radius <= Constants.asteroid_min_radius then []
    else
        let split_angle = 20. +. Random.float 30. in            (* uniform(20.0, 50.0) *)
        let v1 = Vec2.rotate velocity ~deg:split_angle in
        let v2 = Vec2.rotate velocity ~deg:(-. split_angle) in
        let split_radius = radius -. Constants.asteroid_min_radius in
        [
            create ~position ~velocity:(Vec2.scale v1 1.2) ~radius:split_radius;
            create ~position ~velocity:(Vec2.scale v2 1.2) ~radius:split_radius;
        ]

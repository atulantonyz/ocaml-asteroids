type shot = Circleshape.circleshape

let create ~position ~velocity : shot = {
    Circleshape.position;
    velocity;
    radius = Constants.shot_radius;
}

let advance = Circleshape.advance

let render (shot : shot) = Circleshape.renderCircle shot

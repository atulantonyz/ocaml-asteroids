open Constants

type shot = Circleshape.circleshape

let create ~position ~velocity : shot = {
    Circleshape.position;
    velocity;
    radius = shot_radius;
}

let advance = Circleshape.advance
let render = Circleshape.renderCircle
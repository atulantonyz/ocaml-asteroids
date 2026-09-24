type asteroid = Circleshape.circleshape

let create ~position ~velocity ~radius : asteroid = {
  Circleshape.position;
  velocity;
  radius;
}

let advance = Circleshape.advance
let render = Circleshape.renderCircle
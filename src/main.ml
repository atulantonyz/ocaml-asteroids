let initDisplay ~w ~h ~title =
    Glut.initDisplayMode ~double_buffer:true ~depth:true ~alpha:true ();
    Glut.initWindowSize ~w ~h;
    ignore (Glut.createWindow ~title);
    Glut.idleFunc ~cb:(Some Glut.postRedisplay)

(* y grows downward, as in pygame, so the Python coordinates carry over unchanged *)
let initView ~w ~h =
    GlDraw.viewport ~x:0 ~y:0 ~w ~h;
    GlMat.mode `projection;
    GlMat.load_identity ();
    GluMat.ortho2d ~x:(0.0, float_of_int w) ~y:(float_of_int h, 0.0);
    GlMat.mode `modelview

let () =
    ignore (Glut.init Sys.argv);
    let w = 1280 in
    let h = 720 in
    initDisplay ~w ~h ~title:"OCaml Asteroids";
    initView ~w ~h;
    Glut.displayFunc ~cb:(fun () ->
        GlClear.clear [ `color ];
        Glut.swapBuffers ());
    Glut.mainLoop ()

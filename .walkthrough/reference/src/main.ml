let keyDown game = fun ~key ~x ~y ->
    match key with
    | 27 -> exit 0
    | _ -> game := Game.controller !game (Game.Press key)

let keyUp game = fun ~key ~x ~y ->
    game := Game.controller !game (Game.Release key)

(* Wall-clock milliseconds since Glut.init, like pygame's clock *)
let elapsed () = Glut.get ~gtype:Glut.ELAPSED_TIME

(* Fires every ~16ms (60 fps) and feeds the real elapsed dt to the game *)
let rec tickTicker game last = fun ~value ->
    let now = elapsed () in
    let dt = float_of_int (now - last) /. 1000. in
    game := Game.controller !game (Game.Tick dt);
    Glut.timerFunc ~ms:16 ~cb:(tickTicker game now) ~value:0

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

let initTickers ~game =
    Glut.timerFunc ~ms:16 ~cb:(tickTicker game (elapsed ())) ~value:0

let initInputs ~game =
    Glut.ignoreKeyRepeat ~ignore:true;
    Glut.keyboardFunc ~cb:(keyDown game);
    Glut.keyboardUpFunc ~cb:(keyUp game)

let initEngine ~game ~w ~h =
    initDisplay ~w ~h ~title:"OCaml Asteroids";
    initView ~w ~h;
    initTickers ~game;
    initInputs ~game;
    Glut.displayFunc ~cb:(fun () -> Game.render !game);
    Glut.mainLoop

let () =
    ignore @@ Glut.init Sys.argv;
    Random.self_init ();
    let game = ref (Game.init ()) in
    let run = initEngine ~game ~w:Constants.screen_width ~h:Constants.screen_height in
    run ()

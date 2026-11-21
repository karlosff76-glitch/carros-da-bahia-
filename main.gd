extends Node3D

const PLAYER_SCRIPT = preload("res://player.gd")

var player
var hud
var status_label
var current_vehicle = null
var camera_mode := 0
var touch_move := Vector2.ZERO
var world_materials := {}

func _ready():
    _build_world()
    _build_player()
    _build_hud()

func _mat(color: Color) -> StandardMaterial3D:
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    return m

func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, color: Color):
    var body = StaticBody3D.new()
    body.name = name
    body.position = pos
    parent.add_child(body)
    var mesh = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = size
    mesh.mesh = box
    mesh.material_override = _mat(color)
    body.add_child(mesh)
    var shape = CollisionShape3D.new()
    var bshape = BoxShape3D.new()
    bshape.size = size
    shape.shape = bshape
    body.add_child(shape)
    return body

func _build_world():
    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(180, 180)
    ground.mesh = plane
    ground.material_override = _mat(Color(0.25, 0.34, 0.24))
    ground.position.y = -0.15
    add_child(ground)

    var ground_body = StaticBody3D.new()
    add_child(ground_body)
    var ground_shape = CollisionShape3D.new()
    var box_shape = BoxShape3D.new()
    box_shape.size = Vector3(180, 0.3, 180)
    ground_shape.shape = box_shape
    ground_body.add_child(ground_shape)
    ground_body.position.y = -0.3

    # Rua principal e vielas
    _box(self, "Rua principal", Vector3(0, 0.01, 0), Vector3(15, 0.12, 150), Color(0.16, 0.17, 0.18))
    _box(self, "Rua transversal", Vector3(0, 0.02, -28), Vector3(120, 0.13, 11), Color(0.19, 0.20, 0.21))
    _box(self, "Viela A", Vector3(23, 0.02, 18), Vector3(7, 0.13, 75), Color(0.20, 0.21, 0.22))
    # Casas coloridas nas encostas
    var colors = [Color(0.82,0.48,0.30), Color(0.76,0.72,0.48), Color(0.40,0.65,0.66), Color(0.72,0.42,0.56), Color(0.84,0.78,0.66)]
    for i in range(5):
        for j in range(7):
            var x = -38.0 + i * 17.0
            var z = -53.0 + j * 17.0
            if abs(x) < 10 or (abs(z + 28) < 8):
                continue
            var h = 5.0 + float((i + j) % 3) * 1.5
            var house = _box(self, "Casa_%d_%d" % [i,j], Vector3(x, h/2.0, z), Vector3(10, h, 10), colors[(i+j)%colors.size()])
            _box(self, "Telhado_%d_%d" % [i,j], Vector3(x, h + 0.25, z), Vector3(10.5, 0.5, 10.5), Color(0.22,0.22,0.24))
            # porta simples
            _box(self, "Porta", Vector3(x, 1.0, z + 5.06), Vector3(1.4, 2.0, 0.12), Color(0.25,0.14,0.08))
    # Praça e quadra
    _box(self, "Quadra", Vector3(-27, 0.08, 28), Vector3(27, 0.2, 19), Color(0.18,0.43,0.28))
    _box(self, "Loja de som", Vector3(33, 2.0, -17), Vector3(12, 4, 10), Color(0.45,0.29,0.18))
    _box(self, "Oficina", Vector3(-34, 2.0, -17), Vector3(13, 4, 10), Color(0.25,0.36,0.48))

    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -30, 0)
    sun.light_energy = 1.25
    add_child(sun)
    var env = WorldEnvironment.new()
    var e = Environment.new()
    e.background_mode = Environment.BG_SKY
    e.sky = Sky.new()
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.62,0.68,0.78)
    e.ambient_light_energy = 0.7
    env.environment = e
    add_child(env)

    _spawn_car("Gol", Vector3(5, 0.8, 12), Color(0.75,0.12,0.08))
    _spawn_car("BYD", Vector3(-5, 0.8, 19), Color(0.12,0.42,0.72))
    _spawn_car("Uno", Vector3(5, 0.8, -15), Color(0.88,0.82,0.22))

func _spawn_car(car_name: String, pos: Vector3, color: Color):
    var car = CharacterBody3D.new()
    car.name = car_name
    car.position = pos
    car.set_script(preload("res://scripts/vehicle.gd"))
    car.set_meta("vehicle_name", car_name)
    add_child(car)

    var body = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(2.2, 1.0, 4.0)
    body.mesh = mesh
    body.position.y = 0.65
    body.material_override = _mat(color)
    car.add_child(body)

    var cabin = MeshInstance3D.new()
    var cm = BoxMesh.new()
    cm.size = Vector3(1.8, 0.8, 2.0)
    cabin.mesh = cm
    cabin.position = Vector3(0,1.45,-0.2)
    cabin.material_override = _mat(Color(0.12,0.16,0.19))
    car.add_child(cabin)

    for x in [-1.12, 1.12]:
        for z in [-1.25, 1.25]:
            var wheel = MeshInstance3D.new()
            var wm = CylinderMesh.new()
            wm.top_radius = 0.38
            wm.bottom_radius = 0.38
            wm.height = 0.22
            wheel.mesh = wm
            wheel.rotation_degrees.z = 90
            wheel.position = Vector3(x,0.38,z)
            wheel.material_override = _mat(Color(0.04,0.04,0.04))
            car.add_child(wheel)

    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(2.2, 1.5, 4.0)
    collision.shape = shape
    collision.position.y = 0.75
    car.add_child(collision)
    return car

func _build_player():
    player = CharacterBody3D.new()
    player.name = "Jogador"
    player.set_script(PLAYER_SCRIPT)
    player.position = Vector3(0, 1.2, 5)
    add_child(player)

func _build_hud():
    hud = CanvasLayer.new()
    add_child(hud)
    var panel = PanelContainer.new()
    panel.position = Vector2(18, 14)
    panel.custom_minimum_size = Vector2(270, 74)
    hud.add_child(panel)
    var v = VBoxContainer.new()
    panel.add_child(v)
    var title = Label.new()
    title.text = "CARROS DA BAHIA"
    title.add_theme_font_size_override("font_size", 22)
    v.add_child(title)
    status_label = Label.new()
    status_label.text = "Explore a comunidade • Protótipo"
    v.add_child(status_label)

    _add_button("CÂMERA", Vector2(-170,-90), Vector2(150,58), _toggle_camera)
    _add_button("ENTRAR / SAIR", Vector2(-170,-158), Vector2(150,58), _toggle_vehicle)
    _add_button("CELULAR", Vector2(-170,-226), Vector2(150,58), _open_phone)
    _add_button("SOM", Vector2(-170,-294), Vector2(150,58), _sound_info)

    var left = _add_button("◀", Vector2(28,-90), Vector2(70,65), func(): _send_drive_input(Vector2(-1,0)))
    var right = _add_button("▶", Vector2(180,-90), Vector2(70,65), func(): _send_drive_input(Vector2(1,0)))
    var forward = _add_button("▲", Vector2(104,-158), Vector2(70,65), func(): _send_drive_input(Vector2(0,-1)))
    var back = _add_button("▼", Vector2(104,-22), Vector2(70,65), func(): _send_drive_input(Vector2(0,1)))
    # Soltar controles pelo botão neutro
    _add_button("PARAR", Vector2(104,-90), Vector2(70,65), func(): _send_drive_input(Vector2.ZERO))

func _add_button(text_value: String, offset: Vector2, size: Vector2, action: Callable):
    var b = Button.new()
    b.text = text_value
    b.custom_minimum_size = size
    b.anchor_left = 1.0
    b.anchor_right = 1.0
    b.anchor_top = 1.0
    b.anchor_bottom = 1.0
    b.position = offset
    b.add_theme_font_size_override("font_size", 16)
    hud.add_child(b)
    b.pressed.connect(action)
    return b

func _send_drive_input(value: Vector2):
    if current_vehicle != null:
        current_vehicle.set_mobile_input(value)
    else:
        player.set_mobile_input(value)

func _toggle_camera():
    camera_mode = 1 - camera_mode
    player.set_camera_mode(camera_mode)
    status_label.text = "Câmera: " + ("terceira pessoa" if camera_mode == 0 else "primeira pessoa")

func _toggle_vehicle():
    if current_vehicle == null:
        var nearest = null
        var best = 999999.0
        for node in get_children():
            if node.has_meta("vehicle_name"):
                var d = player.global_position.distance_to(node.global_position)
                if d < best:
                    best = d
                    nearest = node
        if nearest != null and best < 7.0:
            current_vehicle = nearest
            current_vehicle.set_driving(true)
            player.set_physics_process(false)
            player.visible = false
            status_label.text = "Dirigindo: " + str(nearest.get_meta("vehicle_name")) + " • ▲ acelera ▼ ré ◀ ▶ vira"
        else:
            status_label.text = "Chegue perto de um carro para entrar"
    else:
        var exit_pos = current_vehicle.global_position + current_vehicle.global_transform.basis.x * 2.8
        current_vehicle.set_driving(false)
        player.global_position = exit_pos + Vector3(0, 0.8, 0)
        player.visible = true
        player.set_physics_process(true)
        current_vehicle = null
        status_label.text = "Você saiu do veículo"

func _open_phone():
    status_label.text = "CELULAR: GPS • Música • Garagem • Contatos (em desenvolvimento)"

func _sound_info():
    status_label.text = "LOJA DE SOM: torre, paredão, subwoofers e LEDs (em desenvolvimento)"

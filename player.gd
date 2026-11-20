extends CharacterBody3D

var speed := 6.0
var mobile_input := Vector2.ZERO
var camera_mode := 0
var yaw := 0.0
var pitch := -0.12
var camera_pivot: Node3D
var camera: Camera3D

func _ready():
    var capsule = CapsuleMesh.new()
    var visual = MeshInstance3D.new()
    visual.mesh = capsule
    visual.position.y = 0.9
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.12,0.28,0.72)
    visual.material_override = mat
    add_child(visual)

    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.height = 1.8
    shape.radius = 0.38
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0,1.5,0)
    add_child(camera_pivot)
    camera = Camera3D.new()
    camera.position = Vector3(0,0,5.5)
    camera.rotation_degrees = Vector3(-8,180,0)
    camera.current = true
    camera_pivot.add_child(camera)

func set_mobile_input(value: Vector2):
    mobile_input = value

func set_camera_mode(mode: int):
    camera_mode = mode
    if camera_mode == 0:
        camera.position = Vector3(0,0,5.5)
        camera.rotation_degrees = Vector3(-8,180,0)
    else:
        camera.position = Vector3(0,0.15,0.08)
        camera.rotation_degrees = Vector3(0,180,0)

func _physics_process(delta):
    var input_dir = mobile_input
    if Input.is_action_pressed("ui_up"): input_dir.y = -1
    if Input.is_action_pressed("ui_down"): input_dir.y = 1
    if Input.is_action_pressed("ui_left"): input_dir.x = -1
    if Input.is_action_pressed("ui_right"): input_dir.x = 1
    input_dir = input_dir.normalized()
    var direction = Vector3(input_dir.x,0,input_dir.y)
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed
    if not is_on_floor():
        velocity.y -= 22.0 * delta
    else:
        velocity.y = -0.2
    move_and_slide()

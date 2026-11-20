extends CharacterBody3D

@export var acceleration := 13.0
@export var reverse_speed := 5.0
@export var max_speed := 22.0
@export var turn_speed := 1.8
@export var drag := 8.0

var driving := false
var mobile_input := Vector2.ZERO
var current_speed := 0.0

func set_driving(value: bool):
    driving = value
    mobile_input = Vector2.ZERO

func set_mobile_input(value: Vector2):
    mobile_input = value

func _physics_process(delta):
    if not driving:
        velocity = Vector3.ZERO
        return

    var throttle = -mobile_input.y
    var steering = mobile_input.x

    if Input.is_action_pressed("ui_up"):
        throttle = 1.0
    elif Input.is_action_pressed("ui_down"):
        throttle = -1.0
    if Input.is_action_pressed("ui_left"):
        steering = -1.0
    elif Input.is_action_pressed("ui_right"):
        steering = 1.0

    if throttle > 0.0:
        current_speed = move_toward(current_speed, max_speed, acceleration * delta)
    elif throttle < 0.0:
        current_speed = move_toward(current_speed, -reverse_speed, acceleration * delta)
    else:
        current_speed = move_toward(current_speed, 0.0, drag * delta)

    if abs(current_speed) > 0.2:
        rotation.y -= steering * turn_speed * delta * sign(current_speed)

    var forward = -global_transform.basis.z
    velocity.x = forward.x * current_speed
    velocity.z = forward.z * current_speed
    velocity.y = -0.2
    move_and_slide()

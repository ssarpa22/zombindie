extends CharacterBody3D

@export var walk_speed := 3.2
@export var mouse_sensitivity := 0.0022
@export var gravity := 18.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var flashlight: SpotLight3D = $CameraPivot/Camera3D/Flashlight

var _pitch := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		_pitch = clampf(_pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-82), deg_to_rad(82))
		camera_pivot.rotation.x = _pitch
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		flashlight.visible = not flashlight.visible

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	input_vector.y = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	input_vector = input_vector.normalized()
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	velocity.x = direction.x * walk_speed
	velocity.z = direction.z * walk_speed
	if not is_on_floor():
		velocity.y -= gravity * _delta
	else:
		velocity.y = 0
	move_and_slide()


extends CharacterBody3D

@export var walk_speed := 3.2
@export var mouse_sensitivity := 0.0022
@export var gravity := 18.0
@export var bodycam_bob_amount := 0.025
@export var bodycam_sway_degrees := 0.7

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var flashlight: SpotLight3D = $CameraPivot/Camera3D/Flashlight

var _pitch := 0.0
var _bob_phase := 0.0
var _bodycam_time := 0.0
var _camera_home := Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_camera_home = camera.position

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
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_try_interact()

func _try_interact() -> void:
	var camera: Camera3D = $CameraPivot/Camera3D
	var ray_origin = camera.global_position
	var ray_end = ray_origin - camera.global_transform.basis.z * 2.8
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [get_rid()]
	var hit = get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		var target = hit.get("collider")
		if target != null and target.has_method("interact"):
			target.call("interact")

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	input_vector.y = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	input_vector = input_vector.normalized()
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	velocity.x = direction.x * walk_speed
	velocity.z = direction.z * walk_speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	move_and_slide()
	_update_bodycam(delta)

func _update_bodycam(delta: float) -> void:
	_bodycam_time += delta
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	var movement_amount := clampf(horizontal_speed / walk_speed, 0.0, 1.0)
	if movement_amount > 0.05 and is_on_floor():
		_bob_phase += delta * 7.2
	var step_amount := movement_amount if is_on_floor() else 0.0
	var sway := Vector3(
		sin(_bob_phase * 0.5) * 0.012 * step_amount,
		absf(sin(_bob_phase)) * bodycam_bob_amount * step_amount + sin(_bodycam_time * 1.1) * 0.003,
		0.0
	)
	var idle_roll := sin(_bodycam_time * 0.75) * deg_to_rad(0.15)
	var step_roll := sin(_bob_phase * 0.5) * deg_to_rad(bodycam_sway_degrees) * step_amount
	camera.position = camera.position.lerp(_camera_home + sway, clampf(delta * 10.0, 0.0, 1.0))
	camera.rotation.z = lerpf(camera.rotation.z, idle_roll + step_roll, clampf(delta * 9.0, 0.0, 1.0))

extends CharacterBody3D

@export var walk_speed := 3.2
@export var sprint_speed := 5.6
@export var noclip_speed := 9.0
@export var jump_velocity := 5.2
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
var _noclip_enabled := false
var _game_session: Node
var _sprinting := false
var _attack_cooldown := 0.0
var _step_noise_clock := 0.0

func set_game_session(session: Node) -> void:
	_game_session = session

func is_sprinting() -> bool:
	return _sprinting

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_camera_home = camera.position
	flashlight.set_meta("graphics_shadow_requested", true)
	flashlight.set_meta("graphics_shadow_low_priority", true)

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseMotion) or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var motion := event as InputEventMouseMotion
	_apply_mouse_motion(motion)

func _apply_mouse_motion(motion: InputEventMouseMotion) -> void:
	var sensitivity: float = GameSettings.mouse_sensitivity if is_instance_valid(GameSettings) else mouse_sensitivity
	sensitivity = clampf(sensitivity, 0.0005, 0.006)
	var invert_y: bool = GameSettings.invert_y if is_instance_valid(GameSettings) else false
	var vertical_direction: float = 1.0 if invert_y else -1.0
	rotate_y(-motion.relative.x * sensitivity)
	_pitch = clampf(_pitch + motion.relative.y * sensitivity * vertical_direction, deg_to_rad(-82), deg_to_rad(82))
	camera_pivot.rotation.x = _pitch

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not _has_pointer_interface():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("flashlight"):
		flashlight.visible = not flashlight.visible
	if event.is_action_pressed("interact"):
		_try_interact()
	if event.is_action_pressed("melee") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_try_melee_attack()
	if event.is_action_pressed("noclip"):
		if GameSettings.mode == "challenge":
			if _game_session:
				_game_session.notify("Noclip está desactivado en Modo desafío.")
			return
		_noclip_enabled = not _noclip_enabled
		$CollisionShape3D.set_deferred("disabled", _noclip_enabled)
		velocity = Vector3.ZERO
		print("Vuelo / noclip: ", "activado" if _noclip_enabled else "desactivado")

func _has_pointer_interface() -> bool:
	if not is_instance_valid(_game_session):
		return false
	var hud: Node = _game_session.get("hud")
	return is_instance_valid(hud) and hud.has_method("has_pointer_interface") and bool(hud.call("has_pointer_interface"))

func _try_interact() -> void:
	var camera: Camera3D = $CameraPivot/Camera3D
	var ray_origin = camera.global_position
	var ray_end = ray_origin - camera.global_transform.basis.z * 2.8
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [get_rid()]
	query.collide_with_areas = true
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		var target = hit.get("collider")
		if target != null and target.has_method("interact"):
			target.call("interact", self)
			return
		if target is CollisionObject3D and target.get_parent() != null and target.get_parent().has_method("interact"):
			target.get_parent().call("interact", self)

func _try_melee_attack() -> void:
	if _attack_cooldown > 0.0:
		return
	_attack_cooldown = 0.62
	var ray_from := camera.global_position
	var ray_to := ray_from - camera.global_transform.basis.z * 1.8
	var query := PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	query.exclude = [get_rid()]
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		var target_node: Object = hit.get("collider")
		if target_node != null and target_node.has_method("take_damage"):
			target_node.call("take_damage", 34.0, self, hit.position)
			if _game_session:
				_game_session.notify("Golpe conectado.")
		elif _game_session:
			_game_session.notify("El golpe no encontró objetivo.")
	if _game_session:
		_game_session.emit_noise(global_position, 11.0, "melee")

func _physics_process(delta: float) -> void:
	_attack_cooldown = maxf(0.0, _attack_cooldown - delta)
	_step_noise_clock = maxf(0.0, _step_noise_clock - delta)
	if _noclip_enabled:
		_sprinting = false
		_process_noclip(delta)
		return
	var input_vector := Vector2.ZERO
	input_vector.x = float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left"))
	input_vector.y = float(Input.is_action_pressed("move_back")) - float(Input.is_action_pressed("move_forward"))
	input_vector = input_vector.normalized()
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	var wants_sprint := Input.is_action_pressed("sprint") and input_vector.length_squared() > 0.0
	_sprinting = wants_sprint and (_game_session == null or _game_session.try_spend_stamina(delta * 13.0))
	var load_multiplier: float = _game_session.inventory.movement_multiplier() if _game_session != null else 1.0
	var current_speed: float = (sprint_speed if _sprinting else walk_speed) * load_multiplier
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	move_and_slide()
	if _game_session != null and _step_noise_clock <= 0.0 and Vector2(velocity.x, velocity.z).length() > 2.3:
		_game_session.emit_noise(global_position, 13.0 if _sprinting else 6.0, "footsteps")
		_step_noise_clock = 0.72 if _sprinting else 1.15
	_update_bodycam(delta)

func _process_noclip(delta: float) -> void:
	var input_vector := Vector3.ZERO
	input_vector.x = float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left"))
	input_vector.y = float(Input.is_key_pressed(KEY_SPACE)) - float(Input.is_key_pressed(KEY_C))
	input_vector.z = float(Input.is_action_pressed("move_back")) - float(Input.is_action_pressed("move_forward"))
	var horizontal := transform.basis * Vector3(input_vector.x, 0, input_vector.z)
	var direction := (horizontal + Vector3.UP * input_vector.y).normalized()
	var current_speed := noclip_speed * (1.5 if Input.is_action_pressed("sprint") else 1.0)
	global_position += direction * current_speed * delta
	velocity = direction * current_speed

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

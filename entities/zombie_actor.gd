extends CharacterBody3D

enum State { ROAM, INVESTIGATE, CHASE, ATTACK, DEAD }

@export var max_health := 70.0
@export var walk_speed := 1.45
@export var chase_speed := 2.55
@export var vision_distance := 19.0
@export var hearing_distance := 17.0

var game_session: Node
var target: CharacterBody3D
var health := 70.0
var state := State.ROAM
var _sense_clock := 0.0
var _attack_clock := 0.0
var _search_clock := 0.0
var _wander_clock := 0.0
var _noise_target := Vector3.ZERO
var _wander_target := Vector3.ZERO
var _random := RandomNumberGenerator.new()
var _visual: MeshInstance3D
var _dead := false
var _alerted := false
var archetype := "walker"
var _attack_damage := 11.0

func configure(session: Node, player: CharacterBody3D, infected_type: String = "walker") -> void:
	game_session = session
	target = player
	archetype = infected_type
	if archetype == "runner":
		max_health = 52.0
		walk_speed = 2.0
		chase_speed = 3.35
		vision_distance = 22.0
		_attack_damage = 8.0
	elif archetype == "brute":
		max_health = 135.0
		walk_speed = 0.95
		chase_speed = 1.55
		_attack_damage = 22.0
		var brute_mesh := CapsuleMesh.new()
		brute_mesh.radius = 0.48
		brute_mesh.height = 1.85
		_visual.mesh = brute_mesh
		_visual.scale = Vector3(1.3, 1.0, 1.3)
	_random.seed = int(absf(global_position.x * 317.0 + global_position.z * 911.0)) + 71
	health = max_health
	_wander_target = global_position

func _ready() -> void:
	add_to_group("zombies")
	_collision_and_visuals()

func _collision_and_visuals() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.34
	capsule.height = 1.72
	collision.shape = capsule
	collision.position.y = 0.86
	add_child(collision)
	_visual = MeshInstance3D.new()
	_visual.name = "InfectedBody"
	var body := CapsuleMesh.new()
	body.radius = 0.34
	body.height = 1.72
	_visual.mesh = body
	_visual.position.y = 0.86
	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color(0.22, 0.27, 0.22)
	skin.roughness = 1.0
	_visual.material_override = skin
	add_child(_visual)
	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.24
	head_mesh.height = 0.46
	head.mesh = head_mesh
	head.position = Vector3(0.0, 1.73, 0.0)
	var wounds := StandardMaterial3D.new()
	wounds.albedo_color = Color(0.18, 0.055, 0.035)
	head.material_override = wounds
	add_child(head)

func _physics_process(delta: float) -> void:
	if _dead or not is_instance_valid(target):
		return
	_attack_clock = maxf(0.0, _attack_clock - delta)
	_sense_clock -= delta
	if _sense_clock <= 0.0:
		_sense_clock = 0.28
		_update_perception()
	match state:
		State.CHASE, State.ATTACK:
			_pursue_target(delta)
		State.INVESTIGATE:
			_search_clock -= delta
			_move_toward(_noise_target, walk_speed, delta)
			if global_position.distance_to(_noise_target) < 1.1 or _search_clock <= 0.0:
				state = State.ROAM
		State.ROAM:
			_roam(delta)
	_apply_gravity(delta)
	move_and_slide()

func _update_perception() -> void:
	var to_player := target.global_position - global_position
	var distance := to_player.length()
	var forward := -global_transform.basis.z
	var in_cone := forward.dot(to_player.normalized()) > 0.42
	var flashlight: SpotLight3D = target.get_node_or_null("CameraPivot/Camera3D/Flashlight")
	var lit := is_instance_valid(flashlight) and flashlight.visible and distance < vision_distance * 1.35
	if distance <= vision_distance and (in_cone or lit) and _has_line_of_sight():
		state = State.CHASE
		_search_clock = 5.0
		_alerted = true
		return
	var player_speed := Vector2(target.velocity.x, target.velocity.z).length()
	var current_weather := int(game_session.weather_system.get("weather_index")) if is_instance_valid(game_session) else 0
	var weather_hearing := 0.68 if current_weather == 5 else (0.78 if current_weather == 3 else 1.0)
	var heard_radius := hearing_distance * weather_hearing * (1.6 if target.is_sprinting() else (0.58 if player_speed < 0.4 else 1.0))
	if player_speed > 0.4 and distance < heard_radius:
		_noise_target = target.global_position
		state = State.INVESTIGATE
		_search_clock = 4.0
		_alerted = true
		return
	if state == State.CHASE or state == State.ATTACK:
		_search_clock -= 0.28
		if _search_clock <= 0.0:
			_noise_target = target.global_position
			state = State.INVESTIGATE
			_search_clock = 5.0

func _has_line_of_sight() -> bool:
	var origin := global_position + Vector3(0.0, 1.45, 0.0)
	var destination := target.global_position + Vector3(0.0, 1.1, 0.0)
	var query := PhysicsRayQueryParameters3D.create(origin, destination)
	query.exclude = [get_rid()]
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.get("collider") == target

func _pursue_target(delta: float) -> void:
	var distance := global_position.distance_to(target.global_position)
	if distance <= 1.45:
		state = State.ATTACK
		velocity.x = move_toward(velocity.x, 0.0, delta * 4.0)
		velocity.z = move_toward(velocity.z, 0.0, delta * 4.0)
		if _attack_clock <= 0.0:
			_attack_clock = 1.55
			game_session.survival.take_damage(_attack_damage, true)
			game_session.notify("El infectado te hirió. Vendate con H.")
		return
	state = State.CHASE
	var night_boost := 1.15 if is_instance_valid(game_session) and game_session.world_clock.daylight_factor < 0.25 else 1.0
	_move_toward(target.global_position, chase_speed * night_boost, delta)

func _move_toward(destination: Vector3, speed: float, delta: float) -> void:
	var to_goal := destination - global_position
	to_goal.y = 0.0
	if to_goal.length_squared() < 0.002:
		velocity.x = move_toward(velocity.x, 0.0, delta * 3.0)
		velocity.z = move_toward(velocity.z, 0.0, delta * 3.0)
		return
	var direction := to_goal.normalized()
	var steering := _obstacle_steering(direction)
	velocity.x = steering.x * speed
	velocity.z = steering.z * speed
	look_at(global_position + steering, Vector3.UP)

func _obstacle_steering(direction: Vector3) -> Vector3:
	var space := get_world_3d().direct_space_state
	var origin := global_position + Vector3(0.0, 0.85, 0.0)
	var forward_query := PhysicsRayQueryParameters3D.create(origin, origin + direction * 1.0)
	forward_query.exclude = [get_rid()]
	if space.intersect_ray(forward_query).is_empty():
		return direction
	var left := direction.rotated(Vector3.UP, -0.85)
	var right := direction.rotated(Vector3.UP, 0.85)
	var left_query := PhysicsRayQueryParameters3D.create(origin, origin + left * 1.1)
	left_query.exclude = [get_rid()]
	var right_query := PhysicsRayQueryParameters3D.create(origin, origin + right * 1.1)
	right_query.exclude = [get_rid()]
	var left_clear := space.intersect_ray(left_query).is_empty()
	var right_clear := space.intersect_ray(right_query).is_empty()
	if left_clear and not right_clear:
		return left
	if right_clear and not left_clear:
		return right
	if left_clear and right_clear:
		return left if _random.randf() < 0.5 else right
	return -direction.rotated(Vector3.UP, 1.2)

func _roam(delta: float) -> void:
	_wander_clock -= delta
	if _wander_clock <= 0.0 or global_position.distance_to(_wander_target) < 1.0:
		_wander_clock = _random.randf_range(2.0, 5.0)
		var angle := _random.randf_range(0.0, TAU)
		var radius := _random.randf_range(1.0, 4.0)
		_wander_target = global_position + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
	_move_toward(_wander_target, walk_speed * 0.42, delta)

func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		if velocity.y < 0.0:
			velocity.y = 0.0
	else:
		velocity.y -= 18.0 * delta

func hear_noise(position: Vector3, noise_kind: String) -> void:
	if _dead:
		return
	_noise_target = position
	_search_clock = 5.5 if noise_kind == "gunshot" else 3.8
	state = State.INVESTIGATE
	_alerted = true

func take_damage(amount: float, _attacker: Node = null, hit_position: Vector3 = Vector3.ZERO) -> void:
	if _dead:
		return
	var final_damage := amount
	if hit_position != Vector3.ZERO and hit_position.y > global_position.y + 1.35:
		final_damage *= 1.8
	health = maxf(0.0, health - final_damage)
	if is_instance_valid(_attacker):
		_noise_target = _attacker.global_position
		state = State.CHASE
		_search_clock = 7.0
	if health <= 0.0:
		_die()

func _die() -> void:
	_dead = true
	state = State.DEAD
	remove_from_group("zombies")
	set_physics_process(false)
	var collision: CollisionShape3D = get_node_or_null("CollisionShape3D")
	if collision:
		collision.set_deferred("disabled", true)
	if is_instance_valid(_visual):
		_visual.rotation.z = PI * 0.5
		_visual.position.y = 0.35
	game_session.on_zombie_killed(self)

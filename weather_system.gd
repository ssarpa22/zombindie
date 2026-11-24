extends Node3D

const UIStyle = preload("res://ui/ui_style.gd")
const WEATHER_NAMES := ["Despejado", "Neblina", "Nublado", "Lluvia", "Nieve", "Viento"]

signal weather_event(event_position: Vector3, radius: float, message: String)

var world_environment: WorldEnvironment
var moon_light: DirectionalLight3D
var moon_mesh: MeshInstance3D
var player: Node3D
var world_clock: Node
var weather_index := 0
var _moon_angle := PI
var _moon_material: StandardMaterial3D
var _world_phase := 0.82
var _daylight_factor := 0.0
var _clock_driven := false
var _key_cooldown := 0.0
var _clouds: Node3D
var _cloud_bank: MeshInstance3D
var _rain: CPUParticles3D
var _snow: CPUParticles3D
var _wind: CPUParticles3D
var _cloud_material: StandardMaterial3D
var _weather_menu: PanelContainer
var _weather_status: Label
var _time_status: Label
var _day_length_status: Label
var _time_slider: HSlider
var _day_length_slider: HSlider
var _cycle_toggle: CheckButton
var _auto_weather_toggle: CheckButton
var _menu_open := false
var _menu_cooldown := 0.0
var _stars: MultiMeshInstance3D
var _milky_way: MultiMeshInstance3D
var _snow_cover: MeshInstance3D
var _snow_elapsed := 0.0
var _cloud_drift := 0.0
var _cloud_drift_offset := 0.0
var _tree_canopies: Array = []
var _wind_materials: Array[ShaderMaterial] = []
var _weather_rng := RandomNumberGenerator.new()
var _applied_weather_quality := -1
var _weather_auto := false
var _weather_auto_timer := 0.0
var _lightning_light: OmniLight3D
var _lightning_timer := 24.0
var _lightning_flash_timer := 0.0
var _thunder_delay := 0.0

func bind_scene(scene_root: Node) -> void:
	var found := _find_scene_nodes(scene_root)
	if world_environment == null:
		world_environment = found.get("environment") as WorldEnvironment
	if moon_light == null:
		moon_light = found.get("moon_light") as DirectionalLight3D
	if moon_mesh == null:
		moon_mesh = found.get("moon_mesh") as MeshInstance3D
	if player == null:
		player = found.get("player") as Node3D
	_tree_canopies = found.get("canopies", [])
	_prepare_tree_wind()
	_ensure_sky_effects()
	_add_location_beacons(scene_root)
	_build_forest_details(scene_root)
	_apply_weather()

func _find_scene_nodes(root: Node) -> Dictionary:
	var found := {}
	var pending: Array[Node] = [root]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		if node is WorldEnvironment:
			found["environment"] = node
		elif node is DirectionalLight3D and not found.has("moon_light"):
			found["moon_light"] = node
		elif node is CharacterBody3D:
			found["player"] = node
		elif node is MeshInstance3D and (node.name.to_lower().contains("moon") or node.name.to_lower().contains("luna")):
			found["moon_mesh"] = node
		var node_name := node.name.to_lower()
		if node is Node3D and (node_name.contains("canopy") or node_name.contains("copa") or node_name.contains("foliage") or node_name.contains("hoja")):
			if not found.has("canopies"):
				found["canopies"] = []
			found["canopies"].append(node)
		for child in node.get_children():
			pending.append(child)
	return found

func configure(env: WorldEnvironment, light: DirectionalLight3D, moon: MeshInstance3D, player_node: Node3D) -> void:
	world_environment = env
	moon_light = light
	moon_mesh = moon
	player = player_node
	_ensure_sky_effects()
	if get_parent() is Node3D:
		var found_nodes := _find_scene_nodes(get_parent())
		_tree_canopies = found_nodes.get("canopies", [])
		_prepare_tree_wind()
		_add_location_beacons(get_parent())
		_build_forest_details(get_parent())
	_apply_weather()

func _ready() -> void:
	_weather_rng.randomize()
	_lightning_timer = _weather_rng.randf_range(18.0, 34.0)
	# Ensure daytime starting condition
	_set_weather_mode(0, true)  # Despejado = clear/daytime
	_build_weather_effects()
	_build_weather_menu()
	_ensure_sky_effects()
	_apply_weather()

func bind_world_clock(clock: Node) -> void:
	world_clock = clock
	if not world_clock.is_connected("time_changed", _on_clock_changed):
		world_clock.connect("time_changed", _on_clock_changed)
	_sync_clock_controls()

func set_world_phase(phase: float, daylight: float) -> void:
	_world_phase = fposmod(phase, 1.0)
	_daylight_factor = clampf(daylight, 0.0, 1.0)
	_clock_driven = true
	_apply_weather()
	_sync_clock_controls()

func _ensure_sky_effects() -> void:
	if not is_instance_valid(_stars):
		_stars = _build_starfield()
		add_child(_stars)
	if not is_instance_valid(_milky_way):
		_milky_way = _build_milky_way()
		add_child(_milky_way)
	if not is_instance_valid(_snow_cover):
		_snow_cover = _build_snow_cover()
		add_child(_snow_cover)

func _process(delta: float) -> void:
	_key_cooldown = maxf(0.0, _key_cooldown - delta)
	_menu_cooldown = maxf(0.0, _menu_cooldown - delta)
	_update_weather_automation(delta)
	_update_lightning(delta)
	if Input.is_action_just_pressed("weather_menu") and _menu_cooldown <= 0.0:
		_menu_cooldown = 0.3
		_menu_open = not _menu_open
		_weather_menu.visible = _menu_open
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _menu_open else Input.MOUSE_MODE_CAPTURED
	if _menu_open:
		for i in range(6):
			if Input.is_key_pressed(KEY_1 + i) and _key_cooldown <= 0.0:
				_key_cooldown = 0.3
				_set_weather(i)
				break
	if Input.is_action_just_pressed("weather_cycle") and _key_cooldown <= 0.0:
		_key_cooldown = 0.35
		_set_weather((weather_index + 1) % WEATHER_NAMES.size())
	if is_instance_valid(player):
		if is_instance_valid(_clouds):
			if weather_index == 5:
				_cloud_drift_offset += _cloud_drift * delta
			var drift := sin(_cloud_drift_offset / 200.0) * 200.0 if weather_index == 5 else 0.0
			_clouds.global_position = player.global_position + Vector3(drift, 74.0, 0.0)
		if is_instance_valid(_rain):
			_rain.global_position = player.global_position + Vector3(0.0, 9.0, 0.0)
		if is_instance_valid(_snow):
			_snow.global_position = player.global_position + Vector3(0.0, 9.0, 0.0)
		if is_instance_valid(_wind):
			_wind.global_position = player.global_position + Vector3(0.0, 1.5, 0.0)
		if is_instance_valid(_lightning_light) and _lightning_flash_timer > 0.0:
			_lightning_light.global_position = player.global_position + Vector3(0.0, 18.0, 0.0)
		if is_instance_valid(_stars):
			_stars.global_position = player.global_position
		if is_instance_valid(_milky_way):
			_milky_way.global_position = player.global_position
		if is_instance_valid(_snow_cover):
			if weather_index == 4:
				_snow_elapsed = minf(900.0, _snow_elapsed + delta * lerpf(1.0, 0.7, _daylight_factor))
			elif weather_index == 3:
				_snow_elapsed = maxf(0.0, _snow_elapsed - delta * 0.08)
			elif _daylight_factor > 0.55:
				_snow_elapsed = maxf(0.0, _snow_elapsed - delta * 0.035 * _daylight_factor)
			var progress := clampf(_snow_elapsed / 900.0, 0.0, 1.0)
			_snow_cover.visible = progress > 0.0 and player.global_position.length() > 24.0
			_snow_cover.scale = Vector3(1.0, progress, 1.0)
			_snow_cover.global_position = Vector3(player.global_position.x, 0.035, player.global_position.z)
		for canopy_index in range(_tree_canopies.size()):
			var canopy: Node3D = _tree_canopies[canopy_index] as Node3D
			if is_instance_valid(canopy) and not (canopy is MultiMeshInstance3D):
				canopy.rotation.z = sin(Time.get_ticks_msec() * 0.0018 + canopy_index) * (0.025 if weather_index == 5 else 0.004)
	# Moon and directional light share one transform, so the shadow direction follows the moon.
	if not _clock_driven:
		_moon_angle += delta * 0.002
	if is_instance_valid(moon_mesh) and is_instance_valid(moon_light):
		var moon_orbit_center := player.global_position if is_instance_valid(player) else Vector3.ZERO
		var orbit_angle := _world_phase * TAU if _clock_driven else _moon_angle
		var moon_height := cos(orbit_angle) * 170.0
		moon_mesh.global_position = moon_orbit_center + Vector3(sin(orbit_angle) * 240.0, moon_height, cos(orbit_angle) * 240.0)
		moon_light.global_position = moon_mesh.global_position
		moon_light.look_at(moon_orbit_center, Vector3.UP)

func _build_weather_effects() -> void:
	_clouds = Node3D.new()
	_clouds.name = "Nubes de tormenta"
	add_child(_clouds)
	_cloud_material = StandardMaterial3D.new()
	_cloud_material.albedo_color = Color(0.10, 0.12, 0.17, 0.78)
	_cloud_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_cloud_material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	_cloud_material.roughness = 1.0
	_cloud_material.emission_enabled = true
	_cloud_material.emission = Color(0.10, 0.13, 0.19)
	_cloud_material.emission_energy_multiplier = 0.35
	_cloud_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_cloud_bank = MeshInstance3D.new()
	_cloud_bank.name = "CloudBank"
	_cloud_bank.mesh = _make_cloud_bank([8, 18, 30][clampi(GameSettings.weather_quality, 0, 2)])
	_cloud_bank.material_override = _cloud_material
	_cloud_bank.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_clouds.add_child(_cloud_bank)
	_rain = _make_particles("Lluvia", 320, Vector3(0, -1, 0), 12.0, 20.0, 1.4, Vector3(0, -22, 0), Color(0.48, 0.62, 0.78, 0.42), Vector3(0.018, 0.42, 0.018))
	_snow = _make_particles("Nieve", 180, Vector3(0, -1, 0), 1.0, 2.8, 4.0, Vector3(0, -0.7, 0), Color(0.82, 0.88, 0.95, 0.86), Vector3(0.07, 0.07, 0.07))
	_wind = _make_particles("Hojas al viento", 90, Vector3(1, 0.12, 0), 4.0, 8.0, 2.8, Vector3(0, -0.3, 0), Color(0.48, 0.40, 0.29, 0.75), Vector3(0.07, 0.025, 0.035))
	_lightning_light = OmniLight3D.new()
	_lightning_light.name = "Relampago"
	_lightning_light.light_color = Color(0.72, 0.82, 1.0)
	_lightning_light.light_energy = 0.0
	_lightning_light.omni_range = 110.0
	_lightning_light.shadow_enabled = false
	_lightning_light.visible = false
	add_child(_lightning_light)
	_applied_weather_quality = clampi(GameSettings.weather_quality, 0, 2)

func _make_cloud_mass(seed_value: int) -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value + 1907
	var rings := [Vector2(0.72, -1.6), Vector2(1.0, -0.7), Vector2(0.92, 0.3), Vector2(0.66, 1.25), Vector2(0.32, 2.0), Vector2(0.0, 2.3)]
	var segments := 24
	var width := rng.randf_range(16.0, 30.0)
	var depth := rng.randf_range(12.0, 23.0)
	for ring_index in range(rings.size() - 1):
		for segment in range(segments):
			var angle_a := TAU * float(segment) / segments
			var angle_b := TAU * float(segment + 1) / segments
			var v00 := _cloud_vertex(angle_a, rings[ring_index], width, depth, seed_value)
			var v01 := _cloud_vertex(angle_b, rings[ring_index], width, depth, seed_value)
			var v10 := _cloud_vertex(angle_a, rings[ring_index + 1], width, depth, seed_value)
			var v11 := _cloud_vertex(angle_b, rings[ring_index + 1], width, depth, seed_value)
			_add_cloud_triangle(surface, v00, v10, v01)
			_add_cloud_triangle(surface, v01, v10, v11)
	surface.generate_normals()
	return surface.commit()

func _make_cloud_bank(count: int) -> ArrayMesh:
	var bank := SurfaceTool.new()
	bank.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng := RandomNumberGenerator.new()
	rng.seed = 41027
	for i in range(count):
		var cloud_mesh := _make_cloud_mass(i)
		var arrays := cloud_mesh.surface_get_arrays(0)
		var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		var indices := PackedInt32Array()
		if arrays[Mesh.ARRAY_INDEX] != null:
			indices = arrays[Mesh.ARRAY_INDEX] as PackedInt32Array
		var position := Vector3(float((i * 79) % 220) - 110.0, float(i % 4) * 0.7, float((i * 137) % 220) - 110.0)
		var size := Vector3(0.85 + rng.randf() * 0.45, 0.75 + rng.randf() * 0.4, 0.8 + rng.randf() * 0.5)
		var basis := Basis().rotated(Vector3.UP, rng.randf_range(0.0, TAU)).scaled(size)
		if indices.is_empty():
			for vertex in vertices:
				bank.add_vertex(position + basis * vertex)
		else:
			for vertex_index in indices:
				bank.add_vertex(position + basis * vertices[vertex_index])
	bank.generate_normals()
	return bank.commit()

func _cloud_vertex(angle: float, ring: Vector2, width: float, depth: float, seed_value: int) -> Vector3:
	var contour := 1.0 + 0.12 * sin(angle * 3.0 + seed_value) + 0.07 * cos(angle * 5.0 - seed_value * 0.7)
	var radius := ring.x * contour
	var puff_height := 0.5 * sin(angle * 4.0 + seed_value * 0.35) + 0.22 * cos(angle * 7.0)
	return Vector3(cos(angle) * radius * width, ring.y + puff_height * ring.x, sin(angle) * radius * depth)

func _add_cloud_triangle(surface: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	surface.add_vertex(a)
	surface.add_vertex(b)
	surface.add_vertex(c)

func _make_particles(label: String, amount: int, direction: Vector3, speed_min: float, speed_max: float, lifetime: float, gravity: Vector3, color: Color, size: Vector3) -> CPUParticles3D:
	var particles := CPUParticles3D.new()
	particles.name = label
	particles.amount = roundi(float(amount) * [0.35, 0.65, 1.0][clampi(GameSettings.weather_quality, 0, 2)])
	particles.lifetime = lifetime
	particles.emitting = false
	particles.local_coords = true
	particles.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	particles.emission_box_extents = Vector3(24, 8, 24)
	particles.direction = direction
	particles.spread = 12.0
	particles.gravity = gravity
	particles.initial_velocity_min = speed_min
	particles.initial_velocity_max = speed_max
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var particle_mesh := BoxMesh.new()
	particle_mesh.size = size
	particle_mesh.material = material
	particles.mesh = particle_mesh
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(particles)
	return particles

func apply_weather_quality() -> void:
	var quality := clampi(GameSettings.weather_quality, 0, 2)
	if quality == _applied_weather_quality and is_instance_valid(_cloud_bank):
		return
	if is_instance_valid(_rain):
		_rain.amount = roundi(320.0 * [0.35, 0.65, 1.0][quality])
	if is_instance_valid(_snow):
		_snow.amount = roundi(180.0 * [0.35, 0.65, 1.0][quality])
	if is_instance_valid(_wind):
		_wind.amount = roundi(90.0 * [0.35, 0.65, 1.0][quality])
	if is_instance_valid(_cloud_bank):
		_cloud_bank.mesh = _make_cloud_bank([8, 18, 30][quality])
	_applied_weather_quality = quality

func _apply_weather() -> void:
	if not is_instance_valid(world_environment) or world_environment.environment == null:
		return
	if not is_instance_valid(_clouds) or not is_instance_valid(_rain) or not is_instance_valid(_snow) or not is_instance_valid(_wind) or _cloud_material == null:
		return
	var env := world_environment.environment
	var daylight := clampf(_daylight_factor, 0.0, 1.0)
	var is_cloudy := weather_index >= 2
	_clouds.visible = is_cloudy
	_rain.emitting = weather_index == 3
	_snow.emitting = weather_index == 4
	_wind.emitting = weather_index == 5
	_cloud_drift = 0.7 if weather_index == 2 else (2.0 if weather_index == 3 else (12.0 if weather_index == 5 else 0.2))
	_clouds.scale = Vector3.ONE
	if is_instance_valid(_stars):
		_stars.visible = weather_index == 0 and daylight < 0.32
	if is_instance_valid(_milky_way):
		_milky_way.visible = weather_index == 0 and daylight < 0.32
	env.fog_mode = Environment.FOG_MODE_DEPTH
	env.fog_depth_begin = 35.0
	env.fog_depth_end = 320.0
	env.fog_depth_curve = 1.15
	env.fog_density = 0.12
	env.fog_enabled = weather_index >= 1
	env.fog_light_color = Color(0.075, 0.09, 0.14).lerp(Color(0.52, 0.56, 0.53), daylight)
	env.fog_sky_affect = 0.12
	_cloud_material.albedo_color = Color(0.10, 0.12, 0.17, 0.82)
	_cloud_material.emission = Color(0.10, 0.13, 0.19)
	_cloud_material.emission_energy_multiplier = 0.35
	if weather_index == 1:
		env.fog_depth_begin = 0.0
		env.fog_depth_end = lerpf(23.0, 32.0, daylight)
		env.fog_depth_curve = 1.15
		env.fog_density = 0.38
		env.fog_light_color = Color(0.12, 0.15, 0.20).lerp(Color(0.62, 0.65, 0.61), daylight)
		env.fog_sky_affect = 0.72
		_clouds.visible = false
	elif weather_index == 2:
		env.fog_enabled = true
		env.fog_depth_begin = 95.0
		env.fog_depth_end = 280.0
		env.fog_density = 0.16
		env.fog_light_color = Color(0.08, 0.10, 0.15).lerp(Color(0.48, 0.51, 0.50), daylight)
		_cloud_material.albedo_color = Color(0.055, 0.065, 0.09, 0.94)
		_cloud_material.emission = Color(0.09, 0.11, 0.16)
		_cloud_material.emission_energy_multiplier = 0.48
	elif weather_index == 3:
		env.fog_enabled = true
		env.fog_depth_begin = 18.0
		env.fog_depth_end = lerpf(96.0, 128.0, daylight)
		env.fog_density = 0.2
		env.fog_light_color = Color(0.045, 0.06, 0.09).lerp(Color(0.36, 0.42, 0.47), daylight)
		_cloud_material.albedo_color = Color(0.04, 0.048, 0.065, 0.97)
		_clouds.scale = Vector3(0.9, 0.9, 0.9)
		_cloud_material.emission = Color(0.13, 0.15, 0.20)
		_cloud_material.emission_energy_multiplier = 0.55
	elif weather_index == 4:
		env.fog_enabled = true
		env.fog_depth_begin = 16.0
		env.fog_depth_end = lerpf(92.0, 145.0, daylight)
		env.fog_depth_curve = 1.2
		env.fog_density = 0.16
		env.fog_light_color = Color(0.28, 0.33, 0.43).lerp(Color(0.72, 0.76, 0.78), daylight)
		_cloud_material.albedo_color = Color(0.22, 0.24, 0.29, 0.9)
		_cloud_material.emission = Color(0.18, 0.20, 0.24)
		_cloud_material.emission_energy_multiplier = 0.4
	elif weather_index == 5:
		env.fog_enabled = true
		env.fog_depth_begin = 75.0
		env.fog_depth_end = 260.0
		env.fog_density = 0.14
		env.fog_light_color = Color(0.06, 0.08, 0.12).lerp(Color(0.46, 0.50, 0.50), daylight)
		_cloud_material.albedo_color = Color(0.075, 0.085, 0.12, 0.87)
		_cloud_material.emission = Color(0.08, 0.10, 0.15)
		_cloud_material.emission_energy_multiplier = 0.36
	var cloud_color := _cloud_material.albedo_color
	var cloud_tint := Color(0.56, 0.61, 0.76).lerp(Color(1.0, 0.98, 0.92), daylight)
	_cloud_material.albedo_color = Color(cloud_color.r * cloud_tint.r, cloud_color.g * cloud_tint.g, cloud_color.b * cloud_tint.b, cloud_color.a)
	if env.sky and env.sky.sky_material is ProceduralSkyMaterial:
		var sky_material := env.sky.sky_material as ProceduralSkyMaterial
		var storm_strengths := [0.0, 0.05, 0.24, 0.52, 0.16, 0.3]
		var storm_strength := float(storm_strengths[weather_index])
		var storm_top := Color(0.008, 0.014, 0.03).lerp(Color(0.14, 0.19, 0.24), daylight)
		var storm_horizon := Color(0.035, 0.045, 0.065).lerp(Color(0.32, 0.38, 0.40), daylight)
		sky_material.sky_top_color = sky_material.sky_top_color.lerp(storm_top, storm_strength)
		sky_material.sky_horizon_color = sky_material.sky_horizon_color.lerp(storm_horizon, storm_strength)
	_apply_celestial_state()
	if is_instance_valid(_weather_status):
		_weather_status.text = "CLIMA: %s · %s" % [WEATHER_NAMES[weather_index].to_upper(), "AUTO" if _weather_auto else "MANUAL"]
	for button_index in range(6):
		var button := get_node_or_null("WeatherMenu/Panel/Margin/Content/WeatherButtons/Mode%d" % button_index) as Button
		if button:
			button.disabled = button_index == weather_index
	for wind_material in _wind_materials:
		wind_material.set_shader_parameter("wind_strength", 0.24 if weather_index == 5 else 0.035)

func get_sunlight_multiplier() -> float:
	match weather_index:
		1:
			return 0.78
		2:
			return 0.62
		3:
			return 0.42
		4:
			return 0.76
		5:
			return 0.55
	return 1.0

func _apply_celestial_state() -> void:
	if is_instance_valid(moon_mesh):
		moon_mesh.visible = weather_index != 1 and _daylight_factor < 0.36
		if _moon_material == null:
			_moon_material = StandardMaterial3D.new()
			_moon_material.albedo_color = Color(0.42, 0.45, 0.52)
			_moon_material.roughness = 1.0
			_moon_material.emission_enabled = true
			_moon_material.emission = Color(0.12, 0.14, 0.19)
			_moon_material.emission_energy_multiplier = 0.38
			moon_mesh.material_override = _moon_material
	if is_instance_valid(moon_light):
		var intensities := [0.12, 0.0, 0.09, 0.065, 0.05, 0.10]
		moon_light.light_energy = float(intensities[weather_index]) * (1.0 - _daylight_factor)
		moon_light.visible = moon_light.light_energy > 0.003
		var cast_moon_shadows := weather_index != 1 and weather_index != 3 and weather_index != 4 and _daylight_factor < 0.7
		moon_light.set_meta("graphics_shadow_requested", cast_moon_shadows)
		moon_light.shadow_enabled = cast_moon_shadows and GameSettings.shadow_quality > 0 and (GameSettings.shadow_quality > 1 or bool(moon_light.get_meta("graphics_shadow_low_priority", true)))

func _set_weather(index: int) -> void:
	_set_weather_mode(index, true)

func _set_weather_mode(index: int, manual: bool) -> void:
	weather_index = clampi(index, 0, WEATHER_NAMES.size() - 1)
	if manual:
		_weather_auto = false
		_weather_auto_timer = 0.0
		if is_instance_valid(_auto_weather_toggle):
			_auto_weather_toggle.set_pressed_no_signal(false)
	_apply_weather()

func _on_clock_changed(hour: int, minute: int, _daylight: float, _phase: float) -> void:
	if is_instance_valid(_time_status):
		_time_status.text = "HORA DEL MUNDO · %02d:%02d" % [hour, minute]
	_sync_clock_controls()

func _sync_clock_controls() -> void:
	if not is_instance_valid(world_clock):
		return
	if is_instance_valid(_time_slider):
		_time_slider.set_value_no_signal(float(world_clock.get("phase")) * 24.0)
	if is_instance_valid(_day_length_slider):
		_day_length_slider.set_value_no_signal(float(world_clock.get("full_day_seconds")) / 60.0)
	if is_instance_valid(_day_length_status):
		_day_length_status.text = "DURACIÓN DEL DÍA · %.0f MIN" % (float(world_clock.get("full_day_seconds")) / 60.0)
	if is_instance_valid(_cycle_toggle):
		_cycle_toggle.set_pressed_no_signal(bool(world_clock.get("cycle_enabled")))
	if is_instance_valid(_time_status):
		_time_status.text = "HORA DEL MUNDO · %02d:%02d" % [int(world_clock.call("current_hour")), int(world_clock.call("current_minute"))]

func _on_time_slider_changed(value: float) -> void:
	if is_instance_valid(world_clock):
		world_clock.call("set_hour", value)

func _on_day_length_changed(value: float) -> void:
	if is_instance_valid(world_clock):
		world_clock.call("set_day_length_minutes", value)
	if is_instance_valid(_day_length_status):
		_day_length_status.text = "DURACIÓN DEL DÍA · %.0f MIN" % value

func _on_cycle_toggled(enabled: bool) -> void:
	if is_instance_valid(world_clock):
		world_clock.call("set_cycle_enabled", enabled)

func _on_auto_weather_toggled(enabled: bool) -> void:
	_weather_auto = enabled
	_weather_auto_timer = _weather_rng.randf_range(210.0, 390.0) if enabled else 0.0
	_apply_weather()

func _update_weather_automation(delta: float) -> void:
	if not _weather_auto:
		return
	_weather_auto_timer -= delta
	if _weather_auto_timer > 0.0:
		return
	var weights := [0.34, 0.09, 0.24, 0.18, 0.05, 0.10]
	if _daylight_factor > 0.72:
		weights[0] += 0.05
		weights[1] = 0.04
	elif _daylight_factor < 0.2:
		weights[0] -= 0.05
		weights[1] += 0.05
	var roll := _weather_rng.randf()
	var selected := 0
	for index in range(weights.size()):
		roll -= weights[index]
		if roll <= 0.0:
			selected = index
			break
	if selected == weather_index:
		selected = (selected + 1 + _weather_rng.randi_range(0, WEATHER_NAMES.size() - 2)) % WEATHER_NAMES.size()
	_set_weather_mode(selected, false)
	_weather_auto_timer = _weather_rng.randf_range(210.0, 390.0)

func _update_lightning(delta: float) -> void:
	if weather_index != 3:
		if is_instance_valid(_lightning_light):
			_lightning_light.visible = false
			_lightning_light.light_energy = 0.0
		_lightning_flash_timer = 0.0
		_thunder_delay = 0.0
		return
	if _lightning_flash_timer > 0.0:
		_lightning_flash_timer = maxf(0.0, _lightning_flash_timer - delta)
		if is_instance_valid(_lightning_light):
			_lightning_light.light_energy = 4.8 * clampf(_lightning_flash_timer / 0.18, 0.0, 1.0)
			_lightning_light.visible = _lightning_flash_timer > 0.0
	if _thunder_delay > 0.0:
		_thunder_delay = maxf(0.0, _thunder_delay - delta)
		if _thunder_delay == 0.0 and is_instance_valid(player):
			weather_event.emit(player.global_position, 115.0, "Un trueno distante reverbera entre los árboles.")
	if _lightning_timer > 0.0:
		_lightning_timer -= delta
	else:
		_lightning_timer = _weather_rng.randf_range(22.0, 48.0)
		_lightning_flash_timer = 0.18
		_thunder_delay = _weather_rng.randf_range(1.2, 3.5)
		if is_instance_valid(_lightning_light) and is_instance_valid(player):
			_lightning_light.global_position = player.global_position + Vector3(0.0, 18.0, 0.0)
			_lightning_light.light_energy = 4.8
			_lightning_light.visible = true

func _build_weather_menu() -> void:
	var layer := CanvasLayer.new()
	layer.name = "WeatherMenu"
	layer.layer = 20
	add_child(layer)
	_weather_menu = PanelContainer.new()
	_weather_menu.name = "Panel"
	_weather_menu.theme = UIStyle.create_theme()
	_weather_menu.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_weather_menu.position = Vector2(-302.0, 12.0)
	_weather_menu.size = Vector2(290.0, 0.0)
	layer.add_child(_weather_menu)
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	_weather_menu.add_child(margin)
	var content := VBoxContainer.new()
	content.name = "Content"
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)
	var title := Label.new()
	title.text = "RELOJ Y CLIMA · DEBUG"
	title.add_theme_color_override("font_color", UIStyle.ACCENT)
	title.add_theme_font_size_override("font_size", 10)
	content.add_child(title)
	_time_status = Label.new()
	_time_status.add_theme_color_override("font_color", UIStyle.AMBER)
	content.add_child(_time_status)
	_time_slider = HSlider.new()
	_time_slider.min_value = 0.0
	_time_slider.max_value = 23.99
	_time_slider.step = 0.25
	_time_slider.tooltip_text = "Cambiar la hora del mundo"
	_time_slider.value_changed.connect(_on_time_slider_changed)
	content.add_child(_time_slider)
	_day_length_status = Label.new()
	_day_length_status.add_theme_color_override("font_color", UIStyle.MUTED)
	_day_length_status.add_theme_font_size_override("font_size", 7)
	content.add_child(_day_length_status)
	_day_length_slider = HSlider.new()
	_day_length_slider.min_value = 1.0
	_day_length_slider.max_value = 120.0
	_day_length_slider.step = 1.0
	_day_length_slider.tooltip_text = "Minutos reales por día de juego"
	_day_length_slider.value_changed.connect(_on_day_length_changed)
	content.add_child(_day_length_slider)
	_cycle_toggle = CheckButton.new()
	_cycle_toggle.text = "Ciclo día/noche activo"
	_cycle_toggle.toggled.connect(_on_cycle_toggled)
	content.add_child(_cycle_toggle)
	_auto_weather_toggle = CheckButton.new()
	_auto_weather_toggle.text = "Cambios de clima automáticos"
	_auto_weather_toggle.toggled.connect(_on_auto_weather_toggled)
	content.add_child(_auto_weather_toggle)
	var climate_heading := Label.new()
	climate_heading.text = "CONDICIONES ATMOSFÉRICAS"
	climate_heading.add_theme_color_override("font_color", UIStyle.ACCENT)
	climate_heading.add_theme_font_size_override("font_size", 8)
	content.add_child(climate_heading)
	_weather_status = Label.new()
	_weather_status.add_theme_color_override("font_color", UIStyle.AMBER)
	content.add_child(_weather_status)
	var hint := Label.new()
	hint.text = "1–6 elegir  ·  G cambiar  ·  F6 cerrar"
	hint.add_theme_color_override("font_color", UIStyle.MUTED)
	hint.add_theme_font_size_override("font_size", 7)
	content.add_child(hint)
	var buttons := VBoxContainer.new()
	buttons.name = "WeatherButtons"
	buttons.add_theme_constant_override("separation", 4)
	content.add_child(buttons)
	for i in range(WEATHER_NAMES.size()):
		var button := Button.new()
		button.name = "Mode%d" % i
		button.text = "%d  %s" % [i + 1, WEATHER_NAMES[i]]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.custom_minimum_size.y = 25.0
		button.add_theme_font_size_override("font_size", 8)
		button.pressed.connect(_set_weather.bind(i))
		buttons.add_child(button)
	_weather_menu.visible = false
	_sync_clock_controls()

func _add_location_beacons(scene_root: Node) -> void:
	if not (scene_root is Node3D):
		return
	if scene_root.find_child("HospitalLocator", true, false) == null:
		_add_beacon(scene_root as Node3D, "HospitalLocator", Vector3(0.0, 3.0, 12.0), Vector3(1.8, 0.35, 0.12), Color(0.34, 0.72, 0.52), 14.0)
	if scene_root.find_child("PoliceLocator", true, false) == null:
		_add_beacon(scene_root as Node3D, "PoliceLocator", Vector3(0.0, 4.4, 220.0), Vector3(3.8, 0.45, 0.12), Color(0.30, 0.52, 0.78), 18.0)

func _add_beacon(root: Node3D, beacon_name: String, at: Vector3, size: Vector3, color: Color, light_range: float) -> void:
	var marker := MeshInstance3D.new()
	marker.name = beacon_name
	var shape := BoxMesh.new()
	shape.size = size
	marker.mesh = shape
	marker.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = color.lightened(0.35)
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 2.0
	marker.material_override = material
	marker.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(marker)
	var lamp := OmniLight3D.new()
	lamp.name = beacon_name + "Glow"
	lamp.position = at
	lamp.light_color = color
	lamp.light_energy = 0.65
	lamp.omni_range = light_range
	lamp.shadow_enabled = false
	root.add_child(lamp)

func _build_forest_details(scene_root: Node) -> void:
	if scene_root.find_child("ForestAmbientDetailPack", true, false) != null:
		return
	var file := FileAccess.open("res://forest_detail_layout.json", FileAccess.READ)
	if file == null:
		push_warning("No se pudo cargar el diseño de detalles del bosque.")
		return
	var rows: Array = JSON.parse_string(file.get_as_text())
	if rows.is_empty():
		return
	var grouped: Array = []
	for kind in range(6):
		grouped.append([])
	for row in rows:
		var kind := int(row[0])
		var yaw := float(row[3])
		var size := float(row[4])
		var transform := Transform3D(Basis().rotated(Vector3.UP, yaw).scaled(Vector3.ONE * size), Vector3(float(row[1]), 0.0, float(row[2])))
		grouped[kind].append({"transform": transform, "variant": int(row[5])})
	var pack := Node3D.new()
	pack.name = "ForestAmbientDetailPack"
	scene_root.add_child(pack)
	var colors := [Color(0.18, 0.26, 0.15), Color(0.24, 0.23, 0.20), Color(0.16, 0.12, 0.09), Color(0.24, 0.20, 0.16), Color(0.31, 0.24, 0.15), Color(0.48, 0.47, 0.38)]
	var labels := ["Ferns", "Rocks", "FallenBranches", "ForestRubble", "Stumps", "Mushrooms"]
	for kind in range(6):
		var entries: Array = grouped[kind]
		if entries.is_empty():
			continue
		var batch := MultiMesh.new()
		batch.transform_format = MultiMesh.TRANSFORM_3D
		batch.use_colors = true
		batch.mesh = _make_detail_mesh(kind)
		batch.instance_count = entries.size()
		for index in range(entries.size()):
			var entry: Dictionary = entries[index]
			batch.set_instance_transform(index, entry["transform"])
			var shade := 0.78 + float(int(entry["variant"]) % 5) * 0.07
			batch.set_instance_color(index, colors[kind] * shade)
		var instance := MultiMeshInstance3D.new()
		instance.name = labels[kind]
		instance.multimesh = batch
		instance.material_override = _make_detail_material()
		instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		pack.add_child(instance)

func _make_detail_mesh(kind: int) -> Mesh:
	if kind == 2:
		var branch := BoxMesh.new()
		branch.size = Vector3(1.7, 0.13, 0.18)
		return branch
	if kind == 3:
		var debris := BoxMesh.new()
		debris.size = Vector3(0.55, 0.32, 0.45)
		return debris
	if kind == 4:
		var stump := CylinderMesh.new()
		stump.top_radius = 0.32
		stump.bottom_radius = 0.42
		stump.height = 0.58
		stump.radial_segments = 6
		return stump
	var stone := SphereMesh.new()
	stone.radius = 0.5 if kind == 1 else (0.22 if kind == 5 else 0.38)
	stone.height = 0.56 if kind == 1 else (0.25 if kind == 5 else 0.64)
	return stone

func _make_detail_material() -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	material.roughness = 1.0
	material.metallic = 0.0
	return material

func _prepare_tree_wind() -> void:
	var wind_materials_by_source: Dictionary = {}
	for canopy in _tree_canopies:
		if not is_instance_valid(canopy) or not (canopy is MultiMeshInstance3D):
			continue
		var mesh_instance := canopy as MultiMeshInstance3D
		var source_material: StandardMaterial3D
		if mesh_instance.material_override is StandardMaterial3D:
			source_material = mesh_instance.material_override
		elif mesh_instance.multimesh and mesh_instance.multimesh.mesh and mesh_instance.multimesh.mesh.get_surface_count() > 0:
			source_material = mesh_instance.multimesh.mesh.surface_get_material(0) as StandardMaterial3D
		if source_material == null:
			continue
		if wind_materials_by_source.has(source_material):
			mesh_instance.material_override = wind_materials_by_source[source_material]
			continue
		var shader := Shader.new()
		shader.code = """
		shader_type spatial;
		uniform vec4 base_color : source_color = vec4(0.16, 0.22, 0.13, 1.0);
		uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;
		uniform bool use_texture = false;
		uniform float wind_strength = 0.035;
		void vertex() {
			float crown_weight = clamp(VERTEX.y / 5.0, 0.0, 1.0);
			float phase = TIME * 1.8 + float(INSTANCE_ID) * 0.17;
			VERTEX.x += sin(phase) * wind_strength * crown_weight;
			VERTEX.z += cos(phase * 0.73) * wind_strength * 0.55 * crown_weight;
		}
		void fragment() {
			vec4 texel = use_texture ? texture(albedo_texture, UV) : vec4(1.0);
			ALBEDO = base_color.rgb * COLOR.rgb * texel.rgb;
			ROUGHNESS = 0.95;
		}
		"""
		var material := ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("base_color", source_material.albedo_color)
		material.set_shader_parameter("wind_strength", 0.035)
		if source_material.albedo_texture:
			material.set_shader_parameter("albedo_texture", source_material.albedo_texture)
			material.set_shader_parameter("use_texture", true)
		mesh_instance.material_override = material
		wind_materials_by_source[source_material] = material
		_wind_materials.append(material)

func _build_starfield() -> MultiMeshInstance3D:
	var star_mesh := QuadMesh.new()
	star_mesh.size = Vector2(0.36, 0.36)
	var star_material := StandardMaterial3D.new()
	star_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	star_material.vertex_color_use_as_albedo = true
	star_material.emission_enabled = true
	star_material.emission = Color(0.62, 0.72, 1.0)
	star_material.emission_energy_multiplier = 2.4
	star_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	star_mesh.material = star_material
	var multimesh := MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_colors = true
	multimesh.mesh = star_mesh
	multimesh.instance_count = 900
	var rng := RandomNumberGenerator.new()
	rng.seed = 701
	var galactic_normal := Vector3(0.34, 0.78, -0.52).normalized()
	var tangent_a := galactic_normal.cross(Vector3.UP).normalized()
	var tangent_b := galactic_normal.cross(tangent_a).normalized()
	for i in range(multimesh.instance_count):
		var direction: Vector3
		if i < 360:
			var angle := rng.randf_range(0.0, TAU)
			var offset := rng.randfn(0.0, 0.105)
			direction = (tangent_a * cos(angle) + tangent_b * sin(angle) + galactic_normal * offset).normalized()
		else:
			direction = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(0.04, 1.0), rng.randf_range(-1.0, 1.0)).normalized()
		if direction.y < 0.04:
			direction.y = absf(direction.y)
			direction = direction.normalized()
		var radius := rng.randf_range(82.0, 100.0)
		var size := rng.randf_range(0.7, 1.2)
		multimesh.set_instance_transform(i, Transform3D(Basis().scaled(Vector3.ONE * size), direction * radius))
		var tint := Color(0.62, 0.72, 1.0).lerp(Color(1.0, 0.84, 0.63), rng.randf() * 0.45)
		multimesh.set_instance_color(i, tint * rng.randf_range(0.5, 1.0))
	var instance := MultiMeshInstance3D.new()
	instance.name = "CieloEstrellado"
	instance.multimesh = multimesh
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return instance

func _build_milky_way() -> MultiMeshInstance3D:
	var band := MultiMeshInstance3D.new()
	band.name = "ViaLactea"
	var dust_mesh := QuadMesh.new()
	dust_mesh.size = Vector2(0.9, 0.9)
	var dust_material := StandardMaterial3D.new()
	dust_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dust_material.vertex_color_use_as_albedo = true
	dust_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dust_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	dust_material.emission_enabled = true
	dust_material.emission = Color(0.43, 0.48, 0.72)
	dust_material.emission_energy_multiplier = 0.45
	dust_mesh.material = dust_material
	var cloud := MultiMesh.new()
	cloud.transform_format = MultiMesh.TRANSFORM_3D
	cloud.use_colors = true
	cloud.mesh = dust_mesh
	cloud.instance_count = 360
	var rng := RandomNumberGenerator.new()
	rng.seed = 7821
	var normal := Vector3(0.34, 0.78, -0.52).normalized()
	var axis_a := normal.cross(Vector3.UP).normalized()
	var axis_b := normal.cross(axis_a).normalized()
	for i in range(cloud.instance_count):
		var angle := rng.randf_range(0.0, TAU)
		var offset := rng.randfn(0.0, 0.06)
		var direction := (axis_a * cos(angle) + axis_b * sin(angle) + normal * offset).normalized()
		if direction.y < 0.04:
			direction.y = absf(direction.y)
			direction = direction.normalized()
		var radius := rng.randf_range(82.0, 100.0)
		var s := Vector3(rng.randf_range(1.2, 4.2), rng.randf_range(0.5, 1.5), rng.randf_range(1.2, 4.2))
		cloud.set_instance_transform(i, Transform3D(Basis().scaled(s), direction * radius))
		cloud.set_instance_color(i, Color(0.24, 0.28, 0.42, rng.randf_range(0.13, 0.30)))
	band.multimesh = cloud
	band.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return band

func _build_snow_cover() -> MeshInstance3D:
	var cover := MeshInstance3D.new()
	cover.name = "AccumulatedSnow"
	var snow := CylinderMesh.new()
	snow.top_radius = 28.0
	snow.bottom_radius = 28.0
	snow.height = 0.06
	snow.radial_segments = 24
	cover.mesh = snow
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.72, 0.78, 0.84, 0.86)
	material.roughness = 1.0
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cover.material_override = material
	cover.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	cover.visible = false
	return cover

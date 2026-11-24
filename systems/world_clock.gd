extends Node

signal hour_changed(hour: int, daylight: float)
signal time_changed(hour: int, minute: int, daylight: float, phase: float)

@export var full_day_seconds := 1800.0

var phase := 0.82
var environment_node: WorldEnvironment
var weather_system: Node
var _sun: DirectionalLight3D
var _update_clock := 0.0
var daylight_factor := 0.0
var cycle_enabled := true

func configure(world_environment: WorldEnvironment, weather: Node) -> void:
	environment_node = world_environment
	weather_system = weather
	_sun = DirectionalLight3D.new()
	_sun.name = "Daylight"
	_sun.light_color = Color(0.88, 0.82, 0.68)
	_sun.light_energy = 0.0
	_sun.shadow_enabled = true
	_sun.directional_shadow_max_distance = 70.0
	add_child(_sun)
	_update_world_state()

func tick(delta: float) -> void:
	if cycle_enabled:
		phase = fposmod(phase + delta / maxf(full_day_seconds, 60.0), 1.0)
	_update_clock += delta
	if _update_clock >= 1.0:
		_update_clock = fposmod(_update_clock, 1.0)
		_update_world_state()

func current_hour() -> int:
	return int(floor(phase * 24.0))

func current_minute() -> int:
	return int(floor(fposmod(phase * 1440.0, 60.0)))

func set_hour(hour_value: float) -> void:
	phase = fposmod(hour_value / 24.0, 1.0)
	_update_clock = 0.0
	_update_world_state()

func set_day_length_minutes(minutes: float) -> void:
	full_day_seconds = clampf(minutes * 60.0, 60.0, 7200.0)

func set_cycle_enabled(enabled: bool) -> void:
	cycle_enabled = enabled

func snapshot() -> Dictionary:
	return {"phase": phase, "cycle_enabled": cycle_enabled, "day_length": full_day_seconds}

func restore(data: Dictionary) -> void:
	phase = fposmod(float(data.get("phase", 0.82)), 1.0)
	cycle_enabled = bool(data.get("cycle_enabled", true))
	full_day_seconds = clampf(float(data.get("day_length", full_day_seconds)), 60.0, 7200.0)
	_update_world_state()

func _update_world_state() -> void:
	var sun_elevation := sin((phase - 0.25) * TAU)
	var daylight_progress := clampf((sun_elevation + 0.08) / 0.35, 0.0, 1.0)
	daylight_factor = daylight_progress * daylight_progress * (3.0 - 2.0 * daylight_progress)
	var dawn_amount := _time_of_day_glow(0.25, 0.11)
	var dusk_amount := _time_of_day_glow(0.75, 0.11)
	var twilight := maxf(dawn_amount, dusk_amount)
	if is_instance_valid(environment_node) and environment_node.environment:
		var env := environment_node.environment
		env.ambient_light_energy = lerpf(0.12, 0.36, daylight_factor)
		env.ambient_light_color = Color(0.075, 0.09, 0.15).lerp(Color(0.48, 0.43, 0.35), daylight_factor)
		env.ambient_light_color = env.ambient_light_color.lerp(Color(0.58, 0.30, 0.19), twilight * 0.42)
		if env.sky and env.sky.sky_material is ProceduralSkyMaterial:
			var sky_material := env.sky.sky_material as ProceduralSkyMaterial
			sky_material.sky_top_color = Color(0.006, 0.009, 0.025).lerp(Color(0.22, 0.38, 0.58), daylight_factor)
			sky_material.sky_horizon_color = Color(0.028, 0.038, 0.065).lerp(Color(0.62, 0.52, 0.39), daylight_factor)
			sky_material.sky_horizon_color = sky_material.sky_horizon_color.lerp(Color(0.82, 0.39, 0.23), twilight * 0.62)
	if is_instance_valid(_sun):
		_sun.visible = daylight_factor > 0.025
		var sunlight_multiplier := 1.0
		if is_instance_valid(weather_system) and weather_system.has_method("get_sunlight_multiplier"):
			sunlight_multiplier = float(weather_system.call("get_sunlight_multiplier"))
		_sun.light_energy = daylight_factor * 0.82 * sunlight_multiplier
		_sun.light_color = Color(1.0, 0.69, 0.45).lerp(Color(0.93, 0.88, 0.75), daylight_factor)
		_sun.rotation_degrees = Vector3(-rad_to_deg(asin(sun_elevation)), -28.0, 0.0)
	if is_instance_valid(weather_system):
		weather_system.set_world_phase(phase, daylight_factor)
	time_changed.emit(current_hour(), current_minute(), daylight_factor, phase)
	hour_changed.emit(current_hour(), daylight_factor)

func _time_of_day_glow(center_phase: float, width: float) -> float:
	var distance := absf(fposmod(phase - center_phase + 0.5, 1.0) - 0.5)
	return clampf(1.0 - distance / width, 0.0, 1.0)

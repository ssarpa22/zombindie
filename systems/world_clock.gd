extends Node

signal hour_changed(hour: int, daylight: float)

@export var full_day_seconds := 1800.0

var phase := 0.82
var environment_node: WorldEnvironment
var weather_system: Node
var _sun: DirectionalLight3D
var _update_clock := 0.0
var daylight_factor := 0.0

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
	phase = fposmod(phase + delta / maxf(full_day_seconds, 60.0), 1.0)
	_update_clock += delta
	if _update_clock >= 1.0:
		_update_clock = 0.0
		_update_world_state()

func current_hour() -> int:
	return int(floor(phase * 24.0))

func snapshot() -> Dictionary:
	return {"phase": phase}

func restore(data: Dictionary) -> void:
	phase = fposmod(float(data.get("phase", 0.82)), 1.0)
	_update_world_state()

func _update_world_state() -> void:
	daylight_factor = clampf((sin(phase * TAU) + 0.12) * 1.35, 0.0, 1.0)
	if is_instance_valid(weather_system):
		weather_system.set_world_phase(phase, daylight_factor)
	if is_instance_valid(environment_node) and environment_node.environment:
		var env := environment_node.environment
		env.ambient_light_energy = lerpf(0.12, 0.36, daylight_factor)
		env.ambient_light_color = Color(0.09, 0.12, 0.18).lerp(Color(0.48, 0.42, 0.32), daylight_factor)
		if env.sky and env.sky.sky_material is ProceduralSkyMaterial:
			var sky_material := env.sky.sky_material as ProceduralSkyMaterial
			sky_material.sky_top_color = Color(0.006, 0.009, 0.025).lerp(Color(0.22, 0.38, 0.58), daylight_factor)
			sky_material.sky_horizon_color = Color(0.035, 0.045, 0.07).lerp(Color(0.62, 0.49, 0.31), daylight_factor)
	if is_instance_valid(_sun):
		_sun.visible = daylight_factor > 0.06
		_sun.light_energy = daylight_factor * 0.78
		_sun.rotation_degrees = Vector3(phase * 360.0 - 90.0, -28.0, 0.0)
	hour_changed.emit(current_hour(), daylight_factor)

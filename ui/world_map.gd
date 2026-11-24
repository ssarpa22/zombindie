extends Control

var player_position := Vector2.ZERO
var discovered: Dictionary = {}
var quest_marker := Vector2(1.4, 228.0)
var show_quest_marker := true

const WORLD_RADIUS := 2121.32
const PLAYER_ICON_COLOR := Color(0.95, 0.78, 0.35, 1.0)
var player_node: Node3D

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()

func configure(position: Vector2, discovered_locations: Dictionary, active_marker: Vector2, active: bool) -> void:
	player_position = position
	discovered = discovered_locations.duplicate(true)
	quest_marker = active_marker
	show_quest_marker = active
	queue_redraw()

func set_player_node(value: Node3D) -> void:
	player_node = value

func _process(_delta: float) -> void:
	if is_instance_valid(player_node):
		var next_position := Vector2(player_node.global_position.x, player_node.global_position.z)
		if next_position.distance_squared_to(player_position) >= 1.0:
			player_position = next_position
			queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var scale_factor := minf(size.x, size.y) / (WORLD_RADIUS * 2.0)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.035, 0.045, 0.041, 1.0))
	var map_rect := Rect2(center - Vector2(WORLD_RADIUS, WORLD_RADIUS) * scale_factor, Vector2.ONE * WORLD_RADIUS * 2.0 * scale_factor)
	draw_rect(map_rect, Color(0.07, 0.095, 0.078, 1.0))
	# Illustrated forest belts and clearings, not a projection of the 3D scene.
	for grove in [Vector2(-1250, 750), Vector2(-1050, -480), Vector2(900, 820), Vector2(1050, -680), Vector2(-250, -1200), Vector2(1250, 100)]:
		_draw_woodland(center, scale_factor, grove, Vector2(500, 410), 21)
	_draw_route(center, scale_factor, [Vector2(1, 228), Vector2(70, 430), Vector2(210, 690), Vector2(330, 1040), Vector2(560, 1450), Vector2(620, 1810)], Color(0.72, 0.57, 0.34), 4.0)
	_draw_route(center, scale_factor, [Vector2(1, 228), Vector2(-180, 330), Vector2(-390, 620), Vector2(-620, 920), Vector2(-960, 1190), Vector2(-1340, 1480)], Color(0.58, 0.48, 0.34), 2.5)
	_draw_route(center, scale_factor, [Vector2(1, 228), Vector2(-80, -160), Vector2(-270, -460), Vector2(-430, -820), Vector2(-180, -1180), Vector2(220, -1460)], Color(0.58, 0.48, 0.34), 2.5)
	_draw_route(center, scale_factor, [Vector2(-390, 620), Vector2(-520, 730), Vector2(-620, 920)], Color(0.76, 0.75, 0.66), 1.4)
	_draw_region(center, scale_factor, Vector2(-1340, 1480), Vector2(200, 150), Color(0.24, 0.25, 0.22, 0.8), "LAS ÁNIMAS")
	_draw_region(center, scale_factor, Vector2(620, 1810), Vector2(240, 170), Color(0.22, 0.26, 0.24, 0.85), "DISTRITO INDUSTRIAL")
	_draw_region(center, scale_factor, Vector2(220, -1460), Vector2(150, 120), Color(0.25, 0.24, 0.20, 0.85), "TERMINAL SUR")
	_draw_region(center, scale_factor, Vector2(-430, -820), Vector2(125, 105), Color(0.22, 0.27, 0.24, 0.8), "COMPLEJO SANITARIO")
	_draw_poi(center, scale_factor, Vector2.ZERO, "CLÍNICA", Color(0.73, 0.78, 0.66), bool(discovered.get("clinic", false)))
	_draw_poi(center, scale_factor, quest_marker, "COMISARÍA", Color(0.76, 0.72, 0.55), bool(discovered.get("police_station", false)))
	_draw_poi(center, scale_factor, Vector2(-1340, 1480), "LAS ÁNIMAS", Color(0.77, 0.65, 0.46), bool(discovered.get("town_ghost", false)))
	_draw_poi(center, scale_factor, Vector2(620, 1810), "INDUSTRIA", Color(0.68, 0.72, 0.67), bool(discovered.get("industrial_district", false)))
	_draw_poi(center, scale_factor, Vector2(220, -1460), "AUTOPISTA", Color(0.75, 0.69, 0.52), bool(discovered.get("south_terminal", false)))
	_draw_poi(center, scale_factor, Vector2(-430, -820), "SANITARIO", Color(0.68, 0.75, 0.69), bool(discovered.get("sanatorium", false)))
	_draw_poi(center, scale_factor, Vector2(-390, 620), "REFUGIO", Color(0.75, 0.69, 0.52), bool(discovered.get("ranger_shelter", false)))
	_draw_poi(center, scale_factor, Vector2(95, 515), "CLOACAS", Color(0.52, 0.68, 0.62), bool(discovered.get("sewer_access", false)))
	if show_quest_marker:
		var target := _map_point(center, scale_factor, quest_marker)
		draw_circle(target, 7.0, Color(0.9, 0.53, 0.28, 0.24))
	var player_map := _map_point(center, scale_factor, player_position)
	draw_circle(player_map, 7.0, Color(0.72, 0.82, 0.68, 0.2))
	var angle := 0.0
	if is_instance_valid(player_node):
		angle = player_node.rotation.y
	var heading := Vector2(sin(angle), -cos(angle))
	var side := Vector2(-heading.y, heading.x)
	var arrow := PackedVector2Array([player_map + heading * 8.0, player_map - heading * 5.0 + side * 4.0, player_map - heading * 5.0 - side * 4.0])
	draw_colored_polygon(arrow, PLAYER_ICON_COLOR)
	draw_rect(Rect2(8, 8, 142, 76), Color(0.018, 0.027, 0.026, 0.88))
	draw_string(font(), Vector2(16, 25), "N  BOSQUE NORTE", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(0.82, 0.84, 0.75))
	draw_string(font(), Vector2(16, 43), "— Ruta principal   ·   - - Secundaria", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color(0.76, 0.72, 0.62))
	draw_circle(Vector2(20, 61), 3.0, PLAYER_ICON_COLOR)
	draw_string(font(), Vector2(30, 64), "Jugador   ◆ Lugar de interés", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color(0.76, 0.81, 0.72))
	draw_string(font(), Vector2(10.0, size.y - 10.0), "N", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.64, 0.70, 0.64, 1.0))

func _map_point(center: Vector2, map_scale: float, world: Vector2) -> Vector2:
	return center + Vector2(world.x, -world.y) * map_scale

func _draw_route(center: Vector2, map_scale: float, points: Array[Vector2], color: Color, width: float) -> void:
	for index in range(points.size() - 1):
		draw_line(_map_point(center, map_scale, points[index]), _map_point(center, map_scale, points[index + 1]), color.darkened(0.55), width + 3.0, true)
		draw_line(_map_point(center, map_scale, points[index]), _map_point(center, map_scale, points[index + 1]), color, width, true)

func _draw_woodland(center: Vector2, map_scale: float, world_center: Vector2, world_size: Vector2, seed_value: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var points := PackedVector2Array()
	for index in range(18):
		var angle := TAU * float(index) / 18.0
		var irregularity := rng.randf_range(0.82, 1.12)
		var world_point := world_center + Vector2(cos(angle) * world_size.x, sin(angle) * world_size.y) * irregularity
		points.append(_map_point(center, map_scale, world_point))
	draw_colored_polygon(points, Color(0.10, 0.17, 0.12, 0.88))
	for index in range(48):
		var local := Vector2(rng.randf_range(-world_size.x * 0.45, world_size.x * 0.45), rng.randf_range(-world_size.y * 0.45, world_size.y * 0.45))
		var tree := _map_point(center, map_scale, world_center + local)
		draw_circle(tree, 1.0, Color(0.18, 0.27, 0.17, 0.8))

func _draw_region(center: Vector2, map_scale: float, world_center: Vector2, world_size: Vector2, color: Color, label: String) -> void:
	var rect_center := _map_point(center, map_scale, world_center)
	var rect_size := world_size * 2.0 * map_scale
	draw_rect(Rect2(rect_center - rect_size * 0.5, rect_size), color)
	draw_string(font(), rect_center, label, HORIZONTAL_ALIGNMENT_CENTER, -1, 7, Color(0.81, 0.82, 0.74))

func _draw_poi(center: Vector2, map_scale: float, world: Vector2, label: String, color: Color, known: bool) -> void:
	var point := _map_point(center, map_scale, world)
	var marker_color := color if known else color.darkened(0.55)
	draw_colored_polygon(PackedVector2Array([point + Vector2(0, -4), point + Vector2(4, 0), point + Vector2(0, 4), point + Vector2(-4, 0)]), marker_color)
	if known:
		draw_string(font(), point + Vector2(6, 3), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 7, Color(0.82, 0.84, 0.75))

func font() -> Font:
	return ThemeDB.fallback_font

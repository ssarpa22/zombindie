extends Node

signal region_changed(region_name: String, coordinates: Vector2)
signal point_discovered(point_id: String, point_name: String)

const POINTS := {
	"clinic": {"name": "Hospital San Gabriel", "position": Vector3(0.0, 0.0, 0.0), "radius": 22.0},
	"police_station": {"name": "Comisaría del Bosque", "position": Vector3(1.4, 0.0, 228.0), "radius": 24.0},
	"town_ghost": {"name": "Pueblo Las Ánimas", "position": Vector3(-1340.0, 0.0, 1480.0), "radius": 105.0},
	"industrial_district": {"name": "Distrito industrial", "position": Vector3(620.0, 0.0, 1810.0), "radius": 115.0},
	"south_terminal": {"name": "Terminal de autopista", "position": Vector3(220.0, 0.0, -1460.0), "radius": 70.0},
	"sanatorium": {"name": "Complejo sanitario", "position": Vector3(-430.0, 0.0, -820.0), "radius": 65.0},
	"ranger_shelter": {"name": "Refugio de guardabosques", "position": Vector3(-390.0, 0.0, 620.0), "radius": 38.0},
	"sewer_access": {"name": "Acceso a cloacas", "position": Vector3(95.0, 0.0, 515.0), "radius": 15.0},
	"creek_bridge": {"name": "Puente del arroyo", "position": Vector3(-370.0, 0.0, -635.0), "radius": 28.0}
}

var player: Node3D
var quest_service: Node
var discovered: Dictionary = {}
var region_name := "Clínica San Gabriel"
var coordinates := Vector2.ZERO
var _clock := 0.0

func configure(player_node: Node3D, quests: Node) -> void:
	player = player_node
	quest_service = quests
	_discover("clinic")

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	_clock += delta
	if _clock < 0.4:
		return
	_clock = 0.0
	var position := player.global_position
	var next_coordinates := Vector2(position.x, position.z)
	var next_region := _region_for(position)
	if next_region != region_name or next_coordinates.distance_to(coordinates) >= 4.0:
		region_name = next_region
		coordinates = next_coordinates
		region_changed.emit(region_name, coordinates)
	for point_id in POINTS:
		var point: Dictionary = POINTS[point_id]
		if Vector2(position.x - point.position.x, position.z - point.position.z).length() <= float(point.radius):
			_discover(str(point_id))

func _region_for(position: Vector3) -> String:
	if Vector2(position.x, position.z).length() < 24.0:
		return "Clínica San Gabriel"
	if Vector2(position.x - 1.4, position.z - 228.0).length() < 32.0:
		return "Comisaría del Bosque"
	if Vector2(position.x + 1340.0, position.z - 1480.0).length() < 140.0:
		return "Pueblo Las Ánimas"
	if Vector2(position.x - 620.0, position.z - 1810.0).length() < 155.0:
		return "Distrito industrial"
	if Vector2(position.x - 220.0, position.z + 1460.0).length() < 100.0:
		return "Terminal de autopista"
	if Vector2(position.x + 430.0, position.z + 820.0).length() < 95.0:
		return "Complejo sanitario"
	if Vector2(position.x + 390.0, position.z - 620.0).length() < 65.0:
		return "Refugio forestal"
	if absf(position.z) < 14.0 and absf(position.x) < 26.0:
		return "Perímetro de la clínica"
	if absf(position.z) < 235.0 and absf(position.x) < 48.0:
		return "Camino forestal"
	return "Bosque profundo"

func is_outdoors() -> bool:
	if not is_instance_valid(player):
		return false
	var p := player.global_position
	return absf(p.x) > 8.5 or p.z > 13.0 or p.z < -23.0

func is_discovered(point_id: String) -> bool:
	return bool(discovered.get(point_id, false))

func discover_location(point_id: String) -> void:
	if POINTS.has(point_id):
		_discover(point_id)

func get_map_summary() -> String:
	var places: Array[String] = []
	for point_id in POINTS:
		if is_discovered(point_id):
			places.append(str(POINTS[point_id].name))
	return "Conocidos: " + (", ".join(PackedStringArray(places)) if not places.is_empty() else "ninguno")

func snapshot() -> Dictionary:
	return {"discovered": discovered.duplicate(true)}

func restore(data: Dictionary) -> void:
	discovered = data.get("discovered", {}).duplicate(true)
	for point_id in discovered:
		if discovered[point_id]:
			quest_service.on_location_discovered(str(point_id))

func _discover(point_id: String) -> void:
	if bool(discovered.get(point_id, false)):
		return
	discovered[point_id] = true
	var point: Dictionary = POINTS[point_id]
	point_discovered.emit(point_id, str(point.name))
	quest_service.on_location_discovered(point_id)

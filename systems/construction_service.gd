extends Node

var game_session: Node
var world_root: Node3D
var _serial := 0

func configure(session: Node, root: Node3D) -> void:
	game_session = session
	world_root = root

func build_barricade() -> bool:
	if not game_session.inventory.has_item("wood_plank", 3) or not game_session.inventory.has_item("scrap_metal", 1):
		game_session.notify("Necesitás 3 tablas y 1 chatarra para construir una barricada.")
		return false
	var camera: Camera3D = game_session.player.get_node("CameraPivot/Camera3D")
	var from := camera.global_position
	var to := from - camera.global_transform.basis.z * 4.0
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [game_session.player.get_rid()]
	var hit: Dictionary = game_session.player.get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty() or absf(hit.position.y) > 1.0:
		game_session.notify("Apuntá a un suelo firme y cercano.")
		return false
	if not game_session.inventory.remove_item("wood_plank", 3) or not game_session.inventory.remove_item("scrap_metal", 1):
		return false
	_serial += 1
	var barricade := StaticBody3D.new()
	barricade.name = "PlayerBarricade_%d" % _serial
	barricade.position = hit.position + Vector3(0.0, 0.72, 0.0)
	barricade.rotation.y = game_session.player.rotation.y
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.2, 1.35, 0.22)
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.25, 0.18, 0.12)
	material.roughness = 1.0
	mesh_instance.material_override = material
	barricade.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = mesh.size
	collision.shape = shape
	barricade.add_child(collision)
	world_root.add_child(barricade)
	game_session.progression.add_experience(12, "crafting")
	game_session.notify("Barricada construida · +12 XP de fabricación")
	return true

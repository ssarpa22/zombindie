extends StaticBody3D

const ItemCatalog = preload("res://systems/item_catalog.gd")

var game_session: Node
var item_id := "water"
var amount := 1
var _bob_time := 0.0
var _mesh: MeshInstance3D

func configure(session: Node, id: String, quantity: int = 1) -> void:
	game_session = session
	item_id = id
	amount = quantity

func _ready() -> void:
	add_to_group("interactables")
	_mesh = MeshInstance3D.new()
	_mesh.name = "PickupVisual"
	var box := BoxMesh.new()
	box.size = Vector3(0.38, 0.42, 0.3)
	_mesh.mesh = box
	_mesh.position.y = 0.48
	var material := StandardMaterial3D.new()
	material.albedo_color = _color_for_item()
	material.roughness = 0.78
	material.emission_enabled = true
	material.emission = material.albedo_color * 0.12
	_mesh.material_override = material
	add_child(_mesh)
	var shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(0.7, 1.0, 0.7)
	shape.shape = box_shape
	shape.position.y = 0.5
	add_child(shape)
	var label := Label3D.new()
	label.text = "%s  ·  E" % ItemCatalog.display_name(item_id)
	label.position.y = 1.12
	label.font_size = 18
	label.pixel_size = 0.004
	label.modulate = Color(0.75, 0.8, 0.72, 0.8)
	add_child(label)

func _process(delta: float) -> void:
	_bob_time += delta
	if is_instance_valid(_mesh):
		_mesh.position.y = 0.48 + sin(_bob_time * 1.4) * 0.035

func interact(_actor: Node = null) -> void:
	if game_session.inventory.add_item(item_id, amount):
		queue_free()
	else:
		game_session.notify("No hay lugar en la mochila.")

func _color_for_item() -> Color:
	match item_id:
		"water": return Color(0.12, 0.32, 0.48)
		"canned_food": return Color(0.45, 0.34, 0.18)
		"bandage", "medical_kit": return Color(0.58, 0.56, 0.44)
		"wood_plank": return Color(0.3, 0.2, 0.13)
		"scrap_metal": return Color(0.32, 0.36, 0.35)
		_: return Color(0.4, 0.42, 0.38)

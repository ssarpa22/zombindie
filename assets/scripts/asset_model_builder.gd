@tool
extends StaticBody3D

signal interaction_performed(action: String, target: Node)
const VISUAL_ROOT_NAME := "GeneratedVisuals"
static var _box_mesh_cache: Dictionary = {}
static var _cylinder_mesh_cache: Dictionary = {}
static var _material_cache: Dictionary = {}
@export var asset_key: String = ""
@export var interaction_action: String = ""
var _visual_root: Node3D

func _ready() -> void:
	if has_node(VISUAL_ROOT_NAME):
		return
	_visual_root = Node3D.new()
	_visual_root.name = VISUAL_ROOT_NAME
	add_child(_visual_root)
	_visual_root.owner = self
	var resolved_key := asset_key.to_lower() if not asset_key.is_empty() else name.to_lower()
	_build_asset(resolved_key)

func interact(actor: Node = null) -> bool:
	if interaction_action.is_empty():
		return false
	interaction_performed.emit(interaction_action, self)
	return true
func _build_asset(asset_key: String) -> void:
	if asset_key.begins_with("building_"):
		_build_building(asset_key)
	elif asset_key.contains("animal") or asset_key.contains("deer") or asset_key.contains("wolf"):
		_build_animal(asset_key)
	elif asset_key.contains("trader") or asset_key.contains("npc"):
		_build_humanoid(asset_key)
	elif asset_key.contains("tree") or asset_key.contains("pine") or asset_key.contains("stump") or asset_key.contains("log"):
		_build_tree(asset_key)
	elif asset_key.contains("wall") or asset_key.contains("roof") or asset_key.contains("floor") or asset_key.contains("opening") or asset_key.contains("window") or asset_key.contains("door") or asset_key.contains("stair") or asset_key.contains("foundation"):
		_build_architecture(asset_key)
	elif asset_key.contains("bench"):
		_build_bench(asset_key)
	elif asset_key.contains("bed") or asset_key.contains("gurney") or asset_key.contains("table"):
		_build_bed_or_table(asset_key)
	elif asset_key.contains("barrel") or asset_key.contains("drum") or asset_key.contains("tank"):
		_build_cylinder_prop(asset_key)
	elif asset_key.contains("fence") or asset_key.contains("gate") or asset_key.contains("railing"):
		_build_fence(asset_key)
	elif asset_key.contains("lamp") or asset_key.contains("light") or asset_key.contains("pole"):
		_build_lamp(asset_key)
	elif asset_key.contains("sign") or asset_key.contains("mailbox") or asset_key.contains("phone"):
		_build_sign_or_box(asset_key)
	elif asset_key.contains("crate") or asset_key.contains("box") or asset_key.contains("container"):
		_build_crate(asset_key)
	else:
		_build_generic_prop(asset_key)

func _build_building(key: String) -> void:
	var variant := absi(hash(key)) % 5
	var width := 10.0 + float(variant) * 1.4
	var depth := 9.0 + float((variant + 2) % 4) * 1.2
	var floors := 1 + (variant % 3)
	var height := float(floors) * 3.0
	var wall_color := _palette(key)
	_add_box("Foundation", Vector3(width + 0.5, 0.25, depth + 0.5), Vector3(0, 0.125, 0), Color(0.26, 0.25, 0.23))
	_add_box("RearWall", Vector3(width, height, 0.25), Vector3(0, height * 0.5, depth * 0.5), wall_color)
	_add_box("LeftWall", Vector3(0.25, height, depth), Vector3(-width * 0.5, height * 0.5, 0), wall_color.darkened(0.08))
	_add_box("RightWall", Vector3(0.25, height, depth), Vector3(width * 0.5, height * 0.5, 0), wall_color.darkened(0.08))
	var door_width := 1.2
	var door_height := 2.2
	_add_box("FrontLeftWall", Vector3((width - door_width) * 0.5, height, 0.25), Vector3(-(width + door_width) * 0.25, height * 0.5, -depth * 0.5), wall_color)
	_add_box("FrontRightWall", Vector3((width - door_width) * 0.5, height, 0.25), Vector3((width + door_width) * 0.25, height * 0.5, -depth * 0.5), wall_color)
	_add_box("FrontDoorHeader", Vector3(door_width, maxf(height - door_height, 0.2), 0.25), Vector3(0, door_height + maxf(height - door_height, 0.2) * 0.5, -depth * 0.5), wall_color)
	_add_box("EntranceDoor", Vector3(door_width * 0.78, door_height, 0.08), Vector3(0, door_height * 0.5, -depth * 0.5 - 0.08), Color(0.19, 0.13, 0.09))
	for floor_index in range(floors):
		for side in [-1.0, 1.0]:
			var window_y := 1.6 + float(floor_index) * 3.0
			_add_box("FrontWindow_%d_%d" % [floor_index, int(side)], Vector3(1.1, 1.0, 0.04), Vector3(side * width * 0.25, window_y, -depth * 0.5 - 0.14), Color(0.045, 0.065, 0.075))
			_add_box("WindowSill_%d_%d" % [floor_index, int(side)], Vector3(1.25, 0.08, 0.12), Vector3(side * width * 0.25, window_y - 0.56, -depth * 0.5 - 0.16), Color(0.32, 0.30, 0.27))
	_add_box("Roof", Vector3(width + 0.5, 0.3, depth + 0.5), Vector3(0, height + 0.15, 0), Color(0.12, 0.14, 0.15))
	_add_box("RoofVent", Vector3(0.9, 0.6, 0.8), Vector3(width * 0.24, height + 0.6, depth * 0.18), Color(0.22, 0.21, 0.19))
	_add_collision(Vector3((width - door_width) * 0.5, height, 0.25), Vector3(-(width + door_width) * 0.25, height * 0.5, -depth * 0.5))
	_add_collision(Vector3((width - door_width) * 0.5, height, 0.25), Vector3((width + door_width) * 0.25, height * 0.5, -depth * 0.5))
	_add_collision(Vector3(width, height, 0.25), Vector3(0, height * 0.5, depth * 0.5))
	_add_collision(Vector3(0.25, height, depth), Vector3(-width * 0.5, height * 0.5, 0))
	_add_collision(Vector3(0.25, height, depth), Vector3(width * 0.5, height * 0.5, 0))

func _build_architecture(key: String) -> void:
	var material := _palette(key)
	if key.contains("roof"):
		_add_box("RoofSlab", Vector3(4.2, 0.35, 4.2), Vector3(0, 2.7, 0), material)
		_add_collision(Vector3(4.2, 0.35, 4.2), Vector3(0, 2.7, 0))
	elif key.contains("floor") or key.contains("foundation"):
		_add_box("FloorSlab", Vector3(4.0, 0.25, 4.0), Vector3(0, 0.125, 0), material)
		_add_collision(Vector3(4.0, 0.25, 4.0), Vector3(0, 0.125, 0))
	elif key.contains("stair"):
		for step in range(6):
			_add_box("Step_%02d" % step, Vector3(1.8, 0.22, 0.42), Vector3(0, 0.11 + step * 0.22, -step * 0.42), material)
		_add_collision(Vector3(1.8, 1.35, 2.55), Vector3(0, 0.67, -1.05))
	elif key.contains("window") or key.contains("opening"):
		_add_box("OpeningLeftJamb", Vector3(0.18, 2.4, 0.18), Vector3(-0.9, 1.2, 0), material)
		_add_box("OpeningRightJamb", Vector3(0.18, 2.4, 0.18), Vector3(0.9, 1.2, 0), material)
		_add_box("OpeningLintel", Vector3(1.8, 0.18, 0.18), Vector3(0, 2.31, 0), material)
		_add_box("GlassOrBoarding", Vector3(1.45, 1.75, 0.06), Vector3(0, 1.15, 0.02), Color(0.08, 0.13, 0.15))
		_add_collision(Vector3(0.18, 2.4, 0.18), Vector3(-0.9, 1.2, 0))
		_add_collision(Vector3(0.18, 2.4, 0.18), Vector3(0.9, 1.2, 0))
		_add_collision(Vector3(1.8, 0.18, 0.18), Vector3(0, 2.31, 0))
	elif key.contains("door"):
		_add_box("DoorFrameLeft", Vector3(0.16, 2.3, 0.18), Vector3(-0.58, 1.15, 0), material)
		_add_box("DoorFrameRight", Vector3(0.16, 2.3, 0.18), Vector3(0.58, 1.15, 0), material)
		_add_box("DoorFrameTop", Vector3(1.32, 0.18, 0.18), Vector3(0, 2.21, 0), material)
		_add_box("DoorPanel", Vector3(0.96, 2.0, 0.08), Vector3(0, 1.0, -0.05), Color(0.2, 0.14, 0.1))
		_add_collision(Vector3(0.16, 2.3, 0.18), Vector3(-0.58, 1.15, 0))
		_add_collision(Vector3(0.16, 2.3, 0.18), Vector3(0.58, 1.15, 0))
	else:
		_add_box("WallPanel", Vector3(4.0, 3.0, 0.2), Vector3(0, 1.5, 0), material)
		_add_collision(Vector3(4.0, 3.0, 0.2), Vector3(0, 1.5, 0))
func _build_tree(key: String, exclude_from_areas: Array = []) -> void:
	if key.contains("stump"):
		_add_cylinder("CutTrunk", 0.42, 0.5, 0.75, Vector3(0, 0.375, 0), Color(0.23, 0.15, 0.09))
	elif key.contains("log"):
		_add_cylinder("FallenTrunk", 0.34, 0.38, 3.4, Vector3(0, 0.4, 0), Color(0.2, 0.13, 0.08), Vector3(0, 0, PI * 0.5))
	else:
		_add_cylinder("Trunk", 0.2, 0.28, 4.0, Vector3(0, 2.0, 0), Color(0.2, 0.13, 0.08))
		for layer in range(3):
			var radius := 1.8 - layer * 0.35
			_add_cylinder("Canopy_%d" % layer, 0.0, radius, 2.3, Vector3(0, 4.2 + layer * 1.1, 0), Color(0.09, 0.15 + layer * 0.015, 0.1))
	_add_collision(Vector3(0.8, 3.5, 0.8), Vector3(0, 1.75, 0))

func _build_humanoid(key: String) -> void:
	var coat := _palette(key)
	_add_box("Torso", Vector3(0.65, 0.9, 0.38), Vector3(0, 1.35, 0), coat)
	_add_box("LeftLeg", Vector3(0.22, 0.75, 0.24), Vector3(-0.18, 0.55, 0), Color(0.12, 0.12, 0.11))
	_add_box("RightLeg", Vector3(0.22, 0.75, 0.24), Vector3(0.18, 0.55, 0), Color(0.12, 0.12, 0.11))
	_add_box("LeftArm", Vector3(0.18, 0.75, 0.2), Vector3(-0.44, 1.38, 0), coat.darkened(0.1))
	_add_box("RightArm", Vector3(0.18, 0.75, 0.2), Vector3(0.44, 1.38, 0), coat.darkened(0.1))
	_add_sphere("Head", 0.22, Vector3(0, 2.02, 0), Color(0.48, 0.36, 0.28))
	_add_collision(Vector3(0.8, 2.25, 0.5), Vector3(0, 1.12, 0))

func _build_animal(key: String) -> void:
	var fur := Color(0.3, 0.25, 0.18) if key.contains("deer") else Color(0.16, 0.15, 0.13)
	_add_box("Body", Vector3(0.65, 0.75, 1.6), Vector3(0, 1.05, 0), fur)
	_add_box("Neck", Vector3(0.38, 0.8, 0.42), Vector3(0, 1.45, -0.62), fur)
	_add_sphere("Head", 0.28, Vector3(0, 1.72, -0.9), fur)
	for x in [-0.22, 0.22]:
		for z in [-0.55, 0.55]:
			_add_cylinder("Leg_%d_%d" % [int(x * 10), int(z * 10)], 0.07, 0.09, 0.8, Vector3(x, 0.42, z), fur)
	_add_collision(Vector3(0.8, 1.8, 1.9), Vector3(0, 0.9, 0))
func _build_bench(key: String) -> void:
	var material := _palette(key)
	_add_box("Seat", Vector3(1.7, 0.12, 0.48), Vector3(0, 0.55, 0), material)
	_add_box("Back", Vector3(1.7, 0.75, 0.12), Vector3(0, 1.0, 0.2), material)
	for x in [-0.7, 0.7]:
		_add_box("Leg_%d" % int(x * 10), Vector3(0.12, 0.55, 0.12), Vector3(x, 0.275, 0), Color(0.16, 0.16, 0.15))
	_add_collision(Vector3(1.8, 1.25, 0.6), Vector3(0, 0.62, 0))

func _build_bed_or_table(key: String) -> void:
	var width := 1.0 if key.contains("bed") or key.contains("gurney") else 1.3
	var length := 2.0 if key.contains("bed") or key.contains("gurney") else 0.9
	_add_box("Frame", Vector3(width, 0.16, length), Vector3(0, 0.55, 0), Color(0.28, 0.3, 0.29))
	_add_box("TopOrMattress", Vector3(width * 0.94, 0.2, length * 0.94), Vector3(0, 0.72, 0), Color(0.62, 0.62, 0.56))
	for x in [-0.38, 0.38]:
		for z in [-0.75, 0.75]:
			_add_cylinder("Leg_%d_%d" % [int(x * 10), int(z * 10)], 0.035, 0.035, 0.55, Vector3(x, 0.275, z), Color(0.22, 0.24, 0.23))
	_add_collision(Vector3(width, 0.9, length), Vector3(0, 0.45, 0))

func _build_cylinder_prop(key: String) -> void:
	var material := _palette(key)
	_add_cylinder("MainBody", 0.48, 0.48, 1.0, Vector3(0, 0.5, 0), material)
	_add_cylinder("TopRim", 0.51, 0.51, 0.08, Vector3(0, 0.9, 0), material.darkened(0.25))
	_add_cylinder("BottomRim", 0.51, 0.51, 0.08, Vector3(0, 0.1, 0), material.darkened(0.25))
	_add_collision(Vector3(1.0, 1.0, 1.0), Vector3(0, 0.5, 0))

func _build_fence(key: String) -> void:
	var material := _palette(key)
	for post in range(3):
		_add_box("Post_%d" % post, Vector3(0.16, 1.5, 0.16), Vector3(-1.5 + post * 1.5, 0.75, 0), material.darkened(0.08))
	for rail in range(2):
		_add_box("Rail_%d" % rail, Vector3(3.0, 0.12, 0.12), Vector3(0, 0.45 + rail * 0.55, 0), material)
	_add_collision(Vector3(3.0, 1.5, 0.2), Vector3(0, 0.75, 0))

func _build_lamp(key: String) -> void:
	var metal := _palette(key)
	_add_cylinder("Pole", 0.08, 0.1, 3.8, Vector3(0, 1.9, 0), metal)
	_add_box("Arm", Vector3(1.0, 0.08, 0.08), Vector3(0.42, 3.65, 0), metal)
	_add_box("LampHead", Vector3(0.45, 0.14, 0.3), Vector3(0.82, 3.55, 0), Color(0.75, 0.68, 0.46))
	_add_collision(Vector3(0.35, 3.8, 0.35), Vector3(0, 1.9, 0))

func _build_sign_or_box(key: String) -> void:
	var metal := _palette(key)
	if key.contains("mailbox") or key.contains("box"):
		_add_cylinder("Support", 0.06, 0.06, 1.1, Vector3(0, 0.55, 0), Color(0.2, 0.2, 0.19))
	_add_box("SignBoard", Vector3(1.2, 0.8, 0.12), Vector3(0, 1.75, 0), metal)
	_add_box("SignFace", Vector3(1.05, 0.65, 0.035), Vector3(0, 1.75, -0.08), Color(0.34, 0.31, 0.25))
	_add_collision(Vector3(1.25, 2.5, 0.2), Vector3(0, 1.25, 0))

func _build_crate(key: String) -> void:
	_add_box("CrateBody", Vector3(0.9, 0.9, 0.9), Vector3(0, 0.45, 0), _palette(key))
	for i in range(3):
		_add_box("Board_%d" % i, Vector3(0.92, 0.08, 0.06), Vector3(0, 0.2 + i * 0.28, -0.47), Color(0.27, 0.19, 0.11))
	_add_collision(Vector3(0.9, 0.9, 0.9), Vector3(0, 0.45, 0))

func _build_generic_prop(key: String) -> void:
	var material := _palette(key)
	if key.contains("cone") or key.contains("bollard"):
		_add_cylinder("ConeBody", 0.0, 0.32, 0.8, Vector3(0, 0.4, 0), Color(0.65, 0.24, 0.08))
		_add_box("Base", Vector3(0.55, 0.08, 0.55), Vector3(0, 0.04, 0), Color(0.18, 0.18, 0.17))
	elif key.contains("vehicle") or key.contains("car") or key.contains("truck"):
		_add_box("Chassis", Vector3(2.0, 0.55, 4.0), Vector3(0, 0.7, 0), Color(0.2, 0.22, 0.2))
		_add_box("Cabin", Vector3(1.7, 0.75, 1.8), Vector3(0, 1.3, 0.2), Color(0.12, 0.16, 0.17))
		for x in [-0.85, 0.85]:
			for z in [-1.25, 1.25]:
				_add_cylinder("Wheel_%d_%d" % [int(x * 10), int(z * 10)], 0.38, 0.38, 0.18, Vector3(x, 0.38, z), Color(0.08, 0.08, 0.075), Vector3(0, 0, PI * 0.5))
	else:
		_add_box("MainBody", Vector3(0.9, 1.0, 0.7), Vector3(0, 0.5, 0), material)
		_add_box("Detail", Vector3(0.65, 0.18, 0.74), Vector3(0, 0.62, 0), material.darkened(0.2))
	_add_collision(Vector3(2.1, 1.6, 4.1) if key.contains("vehicle") or key.contains("car") or key.contains("truck") else Vector3(1.0, 1.2, 1.0), Vector3(0, 0.7, 0))

func _add_collision(size: Vector3, position: Vector3) -> void:
	var collision := CollisionShape3D.new()
	collision.name = "Collision_%02d" % get_child_count()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	collision.position = position
	add_child(collision)
	collision.owner = self

func _add_box(label: String, size: Vector3, position: Vector3, color: Color) -> void:
	var mesh := BoxMesh.new()
	mesh.size = size
	var instance := MeshInstance3D.new()
	instance.name = label
	instance.mesh = mesh
	instance.position = position
	instance.material_override = _material(color)
	_visual_root.add_child(instance)
	instance.owner = self

func _add_cylinder(label: String, top_radius: float, bottom_radius: float, height: float, position: Vector3, color: Color, rotation: Vector3 = Vector3.ZERO) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = 8
	var instance := MeshInstance3D.new()
	instance.name = label
	instance.mesh = mesh
	instance.position = position
	instance.rotation = rotation
	instance.material_override = _material(color)
	_visual_root.add_child(instance)
	instance.owner = self

func _add_sphere(label: String, radius: float, position: Vector3, color: Color) -> void:
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 8
	mesh.rings = 4
	var instance := MeshInstance3D.new()
	instance.name = label
	instance.mesh = mesh
	instance.position = position
	instance.material_override = _material(color)
	_visual_root.add_child(instance)
	instance.owner = self
func _material(color: Color) -> StandardMaterial3D:
	var result := StandardMaterial3D.new()
	result.albedo_color = color
	result.roughness = 0.88
	return result

func _palette(key: String) -> Color:
	if key.contains("hospital") or key.contains("medical") or key.contains("clinic"):
		return Color(0.48, 0.49, 0.44)
	if key.contains("wood") or key.contains("bench") or key.contains("tree"):
		return Color(0.26, 0.18, 0.11)
	if key.contains("rust") or key.contains("industrial") or key.contains("barrel"):
		return Color(0.3, 0.2, 0.14)
	if key.contains("forest") or key.contains("foliage") or key.contains("pine"):
		return Color(0.1, 0.19, 0.12)
	return Color(0.34, 0.33, 0.29)
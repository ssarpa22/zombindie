extends SceneTree

const OUTPUT_PATH := "res://WorldAssetLibrary.tscn"
const GRID_SPACING := 18.0
const GRID_COLUMNS := 8

var _root: Node3D
var _groups: Dictionary = {}
var _materials: Dictionary = {}
var _next_slot := 0

func _initialize() -> void:
	call_deferred("_build_library")

func _build_library() -> void:
	_root = Node3D.new()
	_root.name = "WorldAssetLibrary"
	_create_materials()
	_create_categories()
	_create_ground_assets()
	_create_roads_and_fences()
	_create_props()
	_create_vegetation()
	_create_buildings()
	_set_owner_recursive(_root, _root)
	var packed := PackedScene.new()
	var pack_error := packed.pack(_root)
	if pack_error != OK:
		push_error("No se pudo empaquetar la biblioteca: %s" % error_string(pack_error))
		quit(1)
		return
	var save_error := ResourceSaver.save(packed, OUTPUT_PATH)
	if save_error != OK:
		push_error("No se pudo guardar la biblioteca: %s" % error_string(save_error))
		quit(1)
		return
	var asset_count := _save_individual_assets()
	_validate_individual_assets()
	print("Biblioteca generada: %s (%d assets, %d escenas individuales)" % [OUTPUT_PATH, _next_slot, asset_count])
	quit()

func _save_individual_assets() -> int:
	var asset_directory := "res://assets/models"
	var absolute_directory := ProjectSettings.globalize_path(asset_directory)
	var directory_error := DirAccess.make_dir_recursive_absolute(absolute_directory)
	if directory_error != OK and directory_error != ERR_ALREADY_EXISTS:
		push_error("No se pudo crear la carpeta de assets: %s" % error_string(directory_error))
		return 0
	var saved_count := 0
	for category: Node3D in _root.get_children():
		for asset: Node in category.get_children():
			_set_owner_recursive(asset, asset)
			var asset_scene := PackedScene.new()
			if asset_scene.pack(asset) != OK:
				push_warning("No se pudo empaquetar el asset %s" % asset.name)
				continue
			var file_name := "%03d_%s.tscn" % [saved_count + 1, String(asset.name).get_slice("_", 1)]
			var resource_path := "%s/%s" % [asset_directory, file_name]
			if ResourceSaver.save(asset_scene, resource_path) == OK:
				saved_count += 1
	return saved_count

func _validate_individual_assets() -> void:
	var files := DirAccess.get_files_at("res://assets/models")
	var invalid: Array[String] = []
	var checked := 0
	for file_name: String in files:
		if not file_name.ends_with(".tscn"):
			continue
		var packed := load("res://assets/models/%s" % file_name) as PackedScene
		if packed == null:
			invalid.append(file_name + " (scene load failed)")
			continue
		var instance := packed.instantiate()
		if not (instance is StaticBody3D):
			invalid.append(file_name + " (root is not StaticBody3D)")
		elif instance.find_child("Collision", true, false) == null:
			invalid.append(file_name + " (missing collision)")
		checked += 1
		instance.free()
	if not invalid.is_empty():
		push_error("Asset validation failed: " + ", ".join(PackedStringArray(invalid)))
	else:
		print("Validación correcta: %d assets independientes con colisión" % checked)

func _create_materials() -> void:
	_materials = {
		"concrete": _material(Color(0.31, 0.32, 0.30)),
		"concrete_dark": _material(Color(0.19, 0.21, 0.20)),
		"asphalt": _material(Color(0.105, 0.115, 0.112)),
		"dirt": _material(Color(0.30, 0.235, 0.16)),
		"gravel": _material(Color(0.33, 0.31, 0.26)),
		"grass": _material(Color(0.12, 0.20, 0.12)),
		"stone": _material(Color(0.34, 0.34, 0.30)),
		"wood": _material(Color(0.27, 0.19, 0.12)),
		"wood_dark": _material(Color(0.15, 0.11, 0.08)),
		"metal": _material(Color(0.16, 0.19, 0.19), 0.35),
		"rust": _material(Color(0.32, 0.17, 0.09), 0.18),
		"paint": _material(Color(0.39, 0.43, 0.38)),
		"paint_faded": _material(Color(0.28, 0.31, 0.28)),
		"fabric": _material(Color(0.42, 0.42, 0.35)),
		"glass": _material(Color(0.13, 0.22, 0.27), 0.0, true),
		"brick": _material(Color(0.30, 0.19, 0.15)),
		"foliage": _material(Color(0.055, 0.12, 0.075)),
		"foliage_light": _material(Color(0.12, 0.20, 0.11)),
		"white": _material(Color(0.58, 0.57, 0.49)),
		"yellow": _material(Color(0.64, 0.48, 0.17)),
		"red": _material(Color(0.34, 0.08, 0.055))
	}

func _material(color: Color, metalness: float = 0.0, transparent: bool = false) -> StandardMaterial3D:
	var value := StandardMaterial3D.new()
	value.albedo_color = color
	value.metallic = metalness
	value.roughness = 0.94
	if transparent:
		value.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return value

func _create_categories() -> void:
	for category_name in ["00_Terrain", "01_Roads_And_Fences", "02_Street_Infrastructure", "03_Hospital_And_Interior", "04_Residences_And_Industry", "05_Forest_And_Nature"]:
		var category := Node3D.new()
		category.name = category_name
		_root.add_child(category)
		_groups[category_name] = category

func _new_asset(category_name: String, asset_name: String, size: Vector3, material_key: String, collision: bool = true) -> StaticBody3D:
	var asset := StaticBody3D.new()
	asset.name = "%03d_%s" % [_next_slot + 1, asset_name]
	asset.set_meta("asset_category", category_name)
	asset.set_meta("editable_asset", true)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _materials[material_key]
	asset.add_child(mesh_instance)
	if collision:
		var collision_node := CollisionShape3D.new()
		collision_node.name = "Collision"
		var shape := BoxShape3D.new()
		shape.size = size
		collision_node.shape = shape
		asset.add_child(collision_node)
	var category: Node3D = _groups[category_name]
	category.add_child(asset)
	asset.position = _slot_position(_next_slot)
	_next_slot += 1
	return asset

func _slot_position(index: int) -> Vector3:
	var column := index % GRID_COLUMNS
	var row := int(index / GRID_COLUMNS)
	return Vector3(float(column) * GRID_SPACING, 0.0, float(row) * GRID_SPACING)

func _add_box_part(parent: Node3D, part_name: String, position: Vector3, size: Vector3, material_key: String) -> void:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := BoxMesh.new()
	mesh.size = size
	part.mesh = mesh
	part.position = position
	part.material_override = _materials[material_key]
	parent.add_child(part)

func _add_cylinder_part(parent: Node3D, part_name: String, position: Vector3, radius: float, height: float, material_key: String, sides: int = 8) -> void:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = sides
	part.mesh = mesh
	part.position = position
	part.material_override = _materials[material_key]
	parent.add_child(part)

func _set_collision(asset: StaticBody3D, position: Vector3, size: Vector3) -> void:
	var collision_node := CollisionShape3D.new()
	collision_node.name = "Collision"
	collision_node.position = position
	var shape := BoxShape3D.new()
	shape.size = size
	collision_node.shape = shape
	asset.add_child(collision_node)

func _create_ground_assets() -> void:
	for spec: Dictionary in [
		{"name": "Grass_Tile_8m", "mat": "grass"}, {"name": "Forest_Litter_Tile", "mat": "dirt"},
		{"name": "Mud_Tile", "mat": "dirt"}, {"name": "Gravel_Tile", "mat": "gravel"},
		{"name": "Rocky_Ground_Tile", "mat": "stone"}, {"name": "Concrete_Slab", "mat": "concrete"},
		{"name": "Wet_Ground_Tile", "mat": "asphalt"}, {"name": "Hospital_Floor_Tile", "mat": "white"}
	]:
		_new_asset("00_Terrain", str(spec.name), Vector3(8.0, 0.12, 8.0), str(spec.mat))
	var cobble := _new_asset("00_Terrain", "Cobblestone_Path_Module", Vector3(4.0, 0.16, 4.0), "stone")
	for z in range(4):
		for x in range(4):
			_add_box_part(cobble, "Paver_%d_%d" % [x, z], Vector3(-1.45 + x * 0.96, 0.09, -1.45 + z * 0.96), Vector3(0.88, 0.16, 0.88), "concrete" if (x + z) % 3 else "concrete_dark")
	var stepping_stones := _new_asset("00_Terrain", "Stepping_Stone_Path", Vector3(4.0, 0.1, 8.0), "grass")
	for index in range(7):
		_add_box_part(stepping_stones, "Stone_%02d" % index, Vector3(sin(float(index) * 1.4) * 0.8, 0.12, -3.0 + index), Vector3(0.9, 0.2, 0.7), "stone")

func _create_roads_and_fences() -> void:
	for spec: Dictionary in [
		{"name": "Asphalt_Road_Straight_12m", "size": Vector3(12, 0.18, 8), "mat": "asphalt"},
		{"name": "Dirt_Road_Straight_8m", "size": Vector3(8, 0.12, 8), "mat": "dirt"},
		{"name": "Highway_Asphalt_24m", "size": Vector3(24, 0.2, 12), "mat": "asphalt"},
		{"name": "Concrete_Sidewalk", "size": Vector3(2, 0.22, 8), "mat": "concrete"},
		{"name": "Road_Curb", "size": Vector3(0.28, 0.3, 8), "mat": "concrete_dark"},
		{"name": "Drainage_Channel", "size": Vector3(1.2, 0.24, 8), "mat": "concrete_dark"},
		{"name": "Bridge_Deck_Module", "size": Vector3(8, 0.35, 6), "mat": "concrete"},
		{"name": "Rail_Crossing", "size": Vector3(8, 0.18, 5), "mat": "wood"}
	]:
		_new_asset("01_Roads_And_Fences", str(spec.name), spec.size, str(spec.mat))
	_add_fence("Wood_Picket_Fence", "wood", 2.0, false)
	_add_fence("Farm_Rail_Fence", "wood_dark", 2.5, false)
	_add_fence("Concrete_Perimeter_Wall", "concrete", 2.8, true)
	_add_fence("Rusted_Chainlink_Fence", "metal", 2.2, true)
	var gate := _new_asset("01_Roads_And_Fences", "Double_Security_Gate", Vector3(5.0, 2.2, 0.16), "metal")
	_add_box_part(gate, "Diagonal_A", Vector3.ZERO, Vector3(0.12, 2.4, 0.12), "rust")
	_add_box_part(gate, "Diagonal_B", Vector3.ZERO, Vector3(0.12, 2.4, 0.12), "rust")

func _add_fence(asset_name: String, material_key: String, height: float, solid: bool) -> void:
	var asset := _new_asset("01_Roads_And_Fences", asset_name, Vector3(4.0, height, 0.18), material_key, false)
	for x in [-2.0, 0.0, 2.0]:
		_add_box_part(asset, "Post_%s" % str(x), Vector3(x, height * 0.5, 0), Vector3(0.16, height + 0.15, 0.18), material_key)
	if not solid:
		for y_ratio in [0.24, 0.52, 0.8]:
			_add_box_part(asset, "Rail_%s" % str(y_ratio), Vector3(0, height * y_ratio, 0), Vector3(4.1, 0.12, 0.12), material_key)
	else:
		_add_box_part(asset, "Wall_Panel", Vector3(0, height * 0.5, 0), Vector3(3.9, height, 0.16), material_key)
	_set_collision(asset, Vector3(0, height * 0.5, 0), Vector3(4.0, height, 0.22))

func _create_props() -> void:
	for spec: Dictionary in [
		{"name": "Hospital_Bed_Frame", "size": Vector3(1.2, 0.8, 2.2), "mat": "metal"},
		{"name": "Mattress_Rolled", "size": Vector3(1.05, 0.24, 1.9), "mat": "fabric"},
		{"name": "Medical_Locker", "size": Vector3(0.9, 1.9, 0.55), "mat": "paint"},
		{"name": "Metal_Shelving", "size": Vector3(1.4, 1.9, 0.48), "mat": "metal"},
		{"name": "Waiting_Room_Bench", "size": Vector3(2.0, 0.55, 0.65), "mat": "wood"},
		{"name": "Office_Desk", "size": Vector3(1.8, 0.82, 0.82), "mat": "wood"},
		{"name": "Metal_Drum", "size": Vector3(0.62, 0.9, 0.62), "mat": "rust"},
		{"name": "Waste_Bin", "size": Vector3(0.55, 0.75, 0.55), "mat": "metal"},
		{"name": "Dumpster", "size": Vector3(2.1, 1.35, 1.2), "mat": "rust"},
		{"name": "Wooden_Crate", "size": Vector3(0.8, 0.75, 0.8), "mat": "wood"},
		{"name": "Pallet", "size": Vector3(1.2, 0.16, 1.0), "mat": "wood_dark"},
		{"name": "Concrete_Barricade", "size": Vector3(2.4, 0.8, 0.65), "mat": "concrete"},
		{"name": "Road_Sign_Post", "size": Vector3(0.12, 2.5, 0.12), "mat": "metal"},
		{"name": "Warning_Sign", "size": Vector3(0.9, 0.8, 0.08), "mat": "yellow"},
		{"name": "Power_Transformer", "size": Vector3(1.1, 1.0, 0.9), "mat": "metal"},
		{"name": "Air_Conditioner_Outdoor", "size": Vector3(0.9, 0.7, 0.42), "mat": "paint_faded"},
		{"name": "Generator_Industrial", "size": Vector3(1.8, 1.4, 1.0), "mat": "metal"},
		{"name": "Fuel_Pump", "size": Vector3(0.6, 1.65, 0.55), "mat": "red"},
		{"name": "Fire_Hydrant", "size": Vector3(0.38, 0.8, 0.38), "mat": "red"},
		{"name": "Concrete_Planter", "size": Vector3(1.4, 0.55, 0.65), "mat": "concrete"},
		{"name": "Bus_Stop_Shelter", "size": Vector3(2.6, 2.3, 1.2), "mat": "metal"},
		{"name": "Sewer_Manhole_Cover", "size": Vector3(1.1, 0.12, 1.1), "mat": "metal"},
		{"name": "Storm_Drain_Grate", "size": Vector3(1.6, 0.12, 0.62), "mat": "metal"},
		{"name": "Wood_Door", "size": Vector3(0.95, 2.05, 0.12), "mat": "wood"},
		{"name": "Steel_Security_Door", "size": Vector3(0.95, 2.05, 0.14), "mat": "metal"}
	]:
		var asset := _new_asset("03_Hospital_And_Interior", str(spec.name), spec.size, str(spec.mat))
		if str(spec.name) == "Fuel_Pump":
			_add_box_part(asset, "Display", Vector3(0, 0.42, -0.29), Vector3(0.34, 0.24, 0.025), "white")
		elif str(spec.name) == "Generator_Industrial":
			_add_box_part(asset, "Control_Panel", Vector3(0, 0.24, -0.52), Vector3(0.75, 0.38, 0.04), "paint")
		elif str(spec.name) == "Storm_Drain_Grate":
			for index in range(7):
				_add_box_part(asset, "Slot_%02d" % index, Vector3(-0.64 + index * 0.21, 0.08, 0), Vector3(0.055, 0.14, 0.72), "concrete_dark")

func _create_vegetation() -> void:
	var pine := _new_asset("05_Forest_And_Nature", "Pine_Tree_LowPoly", Vector3(0.7, 8.0, 0.7), "wood")
	_add_cylinder_part(pine, "Trunk", Vector3(0, 3.6, 0), 0.32, 7.2, "wood_dark", 6)
	for index in range(4):
		var crown := MeshInstance3D.new()
		crown.name = "Canopy_Tier_%02d" % index
		var cone := CylinderMesh.new()
		cone.top_radius = 0.0
		cone.bottom_radius = 2.2 - index * 0.38
		cone.height = 3.0
		cone.radial_segments = 6
		crown.mesh = cone
		crown.position = Vector3(0, 3.2 + index * 1.35, 0)
		crown.material_override = _materials["foliage" if index % 2 == 0 else "foliage_light"]
		pine.add_child(crown)
	var dead_tree := _new_asset("05_Forest_And_Nature", "Dead_Tree_Snag", Vector3(0.48, 5.2, 0.48), "wood_dark")
	_add_cylinder_part(dead_tree, "Trunk", Vector3(0, 2.6, 0), 0.24, 5.2, "wood_dark", 5)
	_add_box_part(dead_tree, "Broken_Branch_A", Vector3(0.48, 3.1, 0), Vector3(1.2, 0.16, 0.16), "wood")
	_add_box_part(dead_tree, "Broken_Branch_B", Vector3(-0.36, 4.0, 0), Vector3(0.9, 0.14, 0.14), "wood")
	for spec: Dictionary in [
		{"name": "Forest_Stump", "size": Vector3(0.9, 0.42, 0.9), "mat": "wood"},
		{"name": "Fallen_Log", "size": Vector3(2.2, 0.5, 0.55), "mat": "wood_dark"},
		{"name": "Bush_Dense", "size": Vector3(1.4, 1.0, 1.4), "mat": "foliage"},
		{"name": "Tall_Grass_Clump", "size": Vector3(1.2, 0.65, 1.2), "mat": "foliage_light"}
	]:
		_new_asset("05_Forest_And_Nature", str(spec.name), spec.size, str(spec.mat))

func _create_buildings() -> void:
	_add_building("Abandoned_Cabin", Vector3(6.2, 3.2, 6.2), "wood", "wood_dark", "wood")
	_add_building("Rural_Farmhouse", Vector3(8.4, 4.1, 7.0), "paint_faded", "wood_dark", "brick")
	_add_building("Detached_Garage", Vector3(7.0, 3.2, 6.0), "concrete", "metal", "concrete_dark")
	_add_building("Industrial_Shed", Vector3(13.0, 5.4, 9.0), "metal", "rust", "concrete")
	_add_building("Police_Checkpoint_Booth", Vector3(4.2, 3.1, 4.2), "paint", "metal", "concrete")
	_add_building("Clinic_Annex", Vector3(10.0, 4.2, 8.0), "white", "concrete_dark", "concrete")
	_add_building("Small_Apartment_Block", Vector3(12.0, 8.0, 10.0), "brick", "concrete_dark", "concrete")
	_add_building("Roadside_Diner", Vector3(9.0, 4.0, 7.5), "paint_faded", "wood_dark", "concrete")
	_add_building("Ranger_Outpost", Vector3(6.8, 3.7, 6.5), "wood", "wood_dark", "stone")
	_add_building("Pump_House", Vector3(4.5, 3.4, 4.5), "concrete", "metal", "concrete_dark")

func _add_building(asset_name: String, dimensions: Vector3, wall_material: String, roof_material: String, foundation_material: String) -> void:
	var asset := StaticBody3D.new()
	asset.name = "%03d_%s" % [_next_slot + 1, asset_name]
	asset.set_meta("asset_category", "building_shell")
	asset.set_meta("editable_asset", true)
	_groups["04_Residences_And_Industry"].add_child(asset)
	asset.position = _slot_position(_next_slot)
	_next_slot += 1
	_add_box_part(asset, "Foundation", Vector3(0, 0.15, 0), Vector3(dimensions.x + 0.5, 0.3, dimensions.z + 0.5), foundation_material)
	_add_box_part(asset, "Main_Shell", Vector3(0, dimensions.y * 0.5 + 0.3, 0), dimensions, wall_material)
	_add_box_part(asset, "Roof", Vector3(0, dimensions.y + 0.42, 0), Vector3(dimensions.x + 0.8, 0.34, dimensions.z + 0.8), roof_material)
	_add_box_part(asset, "Doorway_Dark", Vector3(0, 1.35, -dimensions.z * 0.5 - 0.012), Vector3(1.0, 2.7, 0.03), "wood_dark")
	for side in [-1.0, 1.0]:
		_add_box_part(asset, "Front_Window_%s" % str(side), Vector3(side * dimensions.x * 0.28, dimensions.y * 0.58, -dimensions.z * 0.5 - 0.018), Vector3(1.05, 0.85, 0.035), "glass")
	var collision := CollisionShape3D.new()
	collision.name = "Collision"
	collision.position = Vector3(0, dimensions.y * 0.5 + 0.3, 0)
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	asset.add_child(collision)

func _set_owner_recursive(node: Node, scene_root: Node) -> void:
	for child: Node in node.get_children():
		child.owner = scene_root
		_set_owner_recursive(child, scene_root)

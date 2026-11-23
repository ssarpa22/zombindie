extends Node3D

const PlayerScene = preload("res://player.tscn")

func _ready() -> void:
	_build_room()
	_build_exterior()
	_build_lighting()
	var player = PlayerScene.instantiate()
	player.position = Vector3(0, 0, 4)
	add_child(player)
	_build_sign()

func _build_room() -> void:
	# A small clinic wing built from simple, reusable box pieces.
	_add_box("Floor", Vector3(0, -0.15, 0), Vector3(16, 0.3, 24), Color(0.16, 0.17, 0.15))
	_add_box("Ceiling", Vector3(0, 3.2, 0), Vector3(16, 0.25, 24), Color(0.07, 0.08, 0.08))
	_add_box("BackWall", Vector3(0, 1.5, -12), Vector3(16, 3, 0.3), Color(0.22, 0.21, 0.18))
	_add_box("LeftWall", Vector3(-8, 1.5, 0), Vector3(0.3, 3, 24), Color(0.18, 0.19, 0.18))
	_add_box("RightWall", Vector3(8, 1.5, 0), Vector3(0.3, 3, 24), Color(0.18, 0.19, 0.18))
	_add_box("EntranceLeft", Vector3(-6, 1.5, 12), Vector3(4, 3, 0.3), Color(0.22, 0.21, 0.18))
	_add_box("EntranceRight", Vector3(6, 1.5, 12), Vector3(4, 3, 0.3), Color(0.22, 0.21, 0.18))
	_add_box("EntranceLintel", Vector3(0, 2.8, 12), Vector3(8, 0.4, 0.3), Color(0.22, 0.21, 0.18))

	# Hallway walls leave door-sized gaps into the side rooms.
	_add_box("HallLeftFront", Vector3(-2.5, 1.5, 7.5), Vector3(0.2, 3, 9), Color(0.29, 0.30, 0.27))
	_add_box("HallLeftMiddle", Vector3(-2.5, 1.5, -1.5), Vector3(0.2, 3, 5), Color(0.29, 0.30, 0.27))
	_add_box("HallLeftRear", Vector3(-2.5, 1.5, -8), Vector3(0.2, 3, 8), Color(0.29, 0.30, 0.27))
	_add_box("HallRightFront", Vector3(2.5, 1.5, 7), Vector3(0.2, 3, 10), Color(0.29, 0.30, 0.27))
	_add_box("HallRightMiddle", Vector3(2.5, 1.5, -2.5), Vector3(0.2, 3, 4), Color(0.29, 0.30, 0.27))
	_add_box("HallRightRear", Vector3(2.5, 1.5, -8.5), Vector3(0.2, 3, 7), Color(0.29, 0.30, 0.27))
	_add_box("LeftRoomDivider", Vector3(-6.2, 1.5, -4), Vector3(3.4, 3, 0.2), Color(0.29, 0.30, 0.27))
	_add_box("RightRoomDivider", Vector3(6.2, 1.5, -5), Vector3(3.4, 3, 0.2), Color(0.29, 0.30, 0.27))

	# Reception furniture, patient beds and a little visual storytelling.
	_add_box("ReceptionCounter", Vector3(-5.5, 0.6, 7.5), Vector3(3.6, 1.2, 0.85), Color(0.25, 0.20, 0.15))
	_add_box("ReceptionDeskTop", Vector3(-5.5, 1.23, 7.5), Vector3(3.8, 0.12, 1.0), Color(0.34, 0.28, 0.19))
	_add_box("ReceptionMonitor", Vector3(-5.5, 1.55, 7.25), Vector3(0.75, 0.48, 0.12), Color(0.07, 0.10, 0.10))
	_add_box("WaitingBench", Vector3(-5.5, 0.42, 3), Vector3(2.6, 0.25, 0.65), Color(0.25, 0.29, 0.27))
	_add_box("BenchLegA", Vector3(-6.45, 0.2, 3), Vector3(0.12, 0.4, 0.12), Color(0.12, 0.13, 0.12))
	_add_box("BenchLegB", Vector3(-4.55, 0.2, 3), Vector3(0.12, 0.4, 0.12), Color(0.12, 0.13, 0.12))
	_add_bed("WardBedA", Vector3(4.5, 0, -7.5))
	_add_bed("WardBedB", Vector3(6.8, 0, -7.5))
	_add_box("IVStand", Vector3(3.5, 1.2, -6.3), Vector3(0.07, 2.4, 0.07), Color(0.42, 0.44, 0.40))
	_add_box("IVBase", Vector3(3.5, 0.12, -6.3), Vector3(0.6, 0.12, 0.6), Color(0.38, 0.40, 0.37))
	_add_box("StorageCabinet", Vector3(-5.5, 1.15, -7.5), Vector3(1.1, 2.3, 0.55), Color(0.23, 0.27, 0.24))
	_add_box("ServiceCart", Vector3(-3.8, 0.55, -9.6), Vector3(1.0, 0.9, 0.65), Color(0.32, 0.34, 0.30))
	_add_box("WayfindingSign", Vector3(0, 2.45, 5), Vector3(2.0, 0.45, 0.08), Color(0.09, 0.20, 0.17))
	_add_box("CeilingLight", Vector3(0, 3.0, 0), Vector3(1.5, 0.08, 0.45), Color(0.65, 0.64, 0.47))
	_add_box("CeilingLightRear", Vector3(0, 3.0, -7), Vector3(1.5, 0.08, 0.45), Color(0.55, 0.22, 0.13))

func _add_bed(bed_name: String, bed_position: Vector3) -> void:
	_add_box(bed_name + "Frame", bed_position + Vector3(0, 0.52, 0), Vector3(1.0, 0.18, 2.1), Color(0.36, 0.38, 0.35))
	_add_box(bed_name + "Mattress", bed_position + Vector3(0, 0.68, 0), Vector3(0.92, 0.16, 1.9), Color(0.48, 0.46, 0.37))
	_add_box(bed_name + "Head", bed_position + Vector3(0, 0.8, -0.92), Vector3(0.95, 0.28, 0.08), Color(0.42, 0.43, 0.39))
	_add_box(bed_name + "LegFrontA", bed_position + Vector3(-0.4, 0.25, 0.8), Vector3(0.08, 0.5, 0.08), Color(0.26, 0.28, 0.27))
	_add_box(bed_name + "LegFrontB", bed_position + Vector3(0.4, 0.25, 0.8), Vector3(0.08, 0.5, 0.08), Color(0.26, 0.28, 0.27))
	_add_box(bed_name + "LegBackA", bed_position + Vector3(-0.4, 0.25, -0.8), Vector3(0.08, 0.5, 0.08), Color(0.26, 0.28, 0.27))
	_add_box(bed_name + "LegBackB", bed_position + Vector3(0.4, 0.25, -0.8), Vector3(0.08, 0.5, 0.08), Color(0.26, 0.28, 0.27))

func _build_lighting() -> void:
	var world = WorldEnvironment.new()
	var environment = Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky = Sky.new()
	var sky_material = ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.006, 0.009, 0.025)
	sky_material.sky_horizon_color = Color(0.035, 0.045, 0.07)
	sky_material.ground_bottom_color = Color(0.008, 0.012, 0.014)
	sky_material.ground_horizon_color = Color(0.025, 0.033, 0.04)
	sky.sky_material = sky_material
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.09, 0.11, 0.14)
	environment.ambient_light_energy = 0.22
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color(0.055, 0.07, 0.09)
	environment.fog_density = 0.018
	world.environment = environment
	add_child(world)
	var lamp = OmniLight3D.new()
	lamp.position = Vector3(0, 2.65, 1)
	lamp.light_color = Color(0.72, 0.78, 0.72)
	lamp.light_energy = 0.55
	lamp.omni_range = 8
	add_child(lamp)
	var moon_light = DirectionalLight3D.new()
	moon_light.name = "Moonlight"
	moon_light.rotation_degrees = Vector3(-28, -20, 0)
	moon_light.light_color = Color(0.43, 0.51, 0.68)
	moon_light.light_energy = 0.16
	moon_light.shadow_enabled = false
	moon_light.light_cull_mask = 2
	add_child(moon_light)

func _build_exterior() -> void:
	_add_visual_box("NightGround", Vector3(0, -0.08, 36), Vector3(70, 0.16, 48), Color(0.025, 0.04, 0.035))
	_add_visual_box("PathToForest", Vector3(0, 0.01, 20), Vector3(3.2, 0.02, 16), Color(0.11, 0.12, 0.105))
	var rng = RandomNumberGenerator.new()
	rng.seed = 27011
	for index in range(32):
		var tree_x = rng.randf_range(-28.0, 28.0)
		var tree_z = rng.randf_range(23.0, 55.0)
		if absf(tree_x) < 3.5 and tree_z < 31.0:
			continue
		_add_tree(Vector3(tree_x, 0, tree_z), rng.randf_range(7.0, 12.0), rng.randf_range(0.75, 1.35))
	_add_moon(Vector3(1.5, 19, 49))

func _add_tree(tree_position: Vector3, tree_height: float, tree_scale: float) -> void:
	var trunk_mesh = CylinderMesh.new()
	trunk_mesh.top_radius = 0.16 * tree_scale
	trunk_mesh.bottom_radius = 0.36 * tree_scale
	trunk_mesh.height = tree_height
	trunk_mesh.radial_segments = 5
	var trunk = MeshInstance3D.new()
	trunk.name = "PineTrunk"
	trunk.mesh = trunk_mesh
	trunk.layers = 2
	trunk.position = tree_position + Vector3(0, tree_height * 0.5, 0)
	trunk.material_override = _make_material(Color(0.055, 0.064, 0.055))
	add_child(trunk)
	for tier in range(3):
		var foliage_mesh = CylinderMesh.new()
		foliage_mesh.top_radius = 0.0
		foliage_mesh.bottom_radius = (1.9 - tier * 0.48) * tree_scale
		foliage_mesh.height = tree_height * 0.43
		foliage_mesh.radial_segments = 5
		var foliage = MeshInstance3D.new()
		foliage.name = "PineCanopy"
		foliage.mesh = foliage_mesh
		foliage.layers = 2
		foliage.position = tree_position + Vector3(0, tree_height * (0.35 + tier * 0.18), 0)
		foliage.material_override = _make_material(Color(0.018 + tier * 0.004, 0.045 + tier * 0.006, 0.04 + tier * 0.006))
		add_child(foliage)

func _add_moon(moon_position: Vector3) -> void:
	var moon_mesh = SphereMesh.new()
	moon_mesh.radius = 2.2
	moon_mesh.height = 4.4
	moon_mesh.radial_segments = 12
	moon_mesh.rings = 6
	var moon = MeshInstance3D.new()
	moon.name = "FullMoon"
	moon.mesh = moon_mesh
	moon.layers = 2
	moon.position = moon_position
	var moon_material = StandardMaterial3D.new()
	moon_material.albedo_color = Color(0.62, 0.67, 0.78)
	moon_material.emission_enabled = true
	moon_material.emission = Color(0.27, 0.34, 0.52)
	moon_material.emission_energy_multiplier = 0.7
	moon_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	moon.material_override = moon_material
	add_child(moon)

func _add_visual_box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> void:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = box_name
	mesh_instance.position = box_position
	mesh_instance.layers = 2
	var mesh = BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _make_material(color)
	add_child(mesh_instance)

func _make_material(color: Color) -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	return material

func _build_sign() -> void:
	var label = Label3D.new()
	label.text = "RECEPCION   |   SALIDA"
	label.position = Vector3(0, 2.5, 11.78)
	label.font_size = 36
	label.modulate = Color(0.72, 0.16, 0.12)
	label.pixel_size = 0.006
	add_child(label)

func _add_box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> void:
	var body = StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	var mesh_instance = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

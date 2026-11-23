extends Node3D

const PlayerScene = preload("res://player.tscn")
const DoorScript = preload("res://door.gd")

var _grain_texture: ImageTexture
var _flicker_lights: Array[OmniLight3D] = []
var _flicker_clock := 0.0

func _ready() -> void:
	_grain_texture = _create_grain_texture()
	_build_room()
	_build_tile_floor()
	_build_doors()
	_build_detail_pass()
	_build_exterior()
	_build_lighting()
	var player = PlayerScene.instantiate()
	player.position = Vector3(0, 0, 4)
	add_child(player)
	_build_sign()

func _process(delta: float) -> void:
	_flicker_clock -= delta
	if _flicker_clock <= 0.0:
		_flicker_clock = randf_range(0.06, 0.22)
		for lamp in _flicker_lights:
			var base_energy: float = lamp.get_meta("base_energy", 0.6)
			lamp.light_energy = base_energy * (randf_range(0.04, 0.18) if randf() < 0.025 else randf_range(0.84, 1.0))

func _build_room() -> void:
	# A small clinic wing built from simple, reusable box pieces.
	_add_box("Floor", Vector3(0, -0.15, 0), Vector3(16, 0.3, 24), Color(0.16, 0.17, 0.15))
	_add_box("Ceiling", Vector3(0, 3.2, 0), Vector3(16.6, 0.25, 24.6), Color(0.07, 0.08, 0.08))
	_add_box("BackWall", Vector3(0, 1.5, -12), Vector3(16, 3, 0.3), Color(0.22, 0.21, 0.18))
	_build_side_wall(-8, "LeftWall")
	_build_side_wall(8, "RightWall")
	_add_box("EntranceLeft", Vector3(-6, 1.5, 12), Vector3(4, 3, 0.3), Color(0.22, 0.21, 0.18))
	_add_box("EntranceRight", Vector3(6, 1.5, 12), Vector3(4, 3, 0.3), Color(0.22, 0.21, 0.18))
	_add_box("EntranceLintel", Vector3(0, 2.9, 12), Vector3(8, 0.6, 0.3), Color(0.22, 0.21, 0.18))

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
	environment.ambient_light_energy = 0.16
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color(0.055, 0.07, 0.09)
	environment.fog_density = 0.018
	world.environment = environment
	add_child(world)
	var moon_light = DirectionalLight3D.new()
	moon_light.name = "Moonlight"
	moon_light.rotation_degrees = Vector3(-28, -20, 0)
	moon_light.light_color = Color(0.43, 0.51, 0.68)
	moon_light.light_energy = 0.34
	moon_light.shadow_enabled = true
	moon_light.directional_shadow_max_distance = 60.0
	moon_light.light_cull_mask = 3
	add_child(moon_light)
	_add_fixture_light(Vector3(0, 2.92, 1), Color(0.68, 0.72, 0.61), 0.62, 7.5, true)
	_add_fixture_light(Vector3(-5.1, 2.88, 6.7), Color(0.62, 0.68, 0.58), 0.43, 5.0, false)
	_add_fixture_light(Vector3(5.1, 2.88, -7.4), Color(0.58, 0.66, 0.73), 0.48, 5.5, false)
	_add_window_light(-7.35, 5)
	_add_window_light(-7.35, -5)
	_add_window_light(7.35, 5)
	_add_window_light(7.35, -5)

func _build_exterior() -> void:
	_add_visual_box("NightGround", Vector3(0, -0.08, 36), Vector3(70, 0.16, 48), Color(0.025, 0.04, 0.035))
	_add_visual_box("PathToForest", Vector3(0, 0.01, 20), Vector3(3.2, 0.02, 16), Color(0.11, 0.12, 0.105))
	_add_visual_box("NightGroundLeft", Vector3(-22, -0.08, 0), Vector3(28, 0.16, 24), Color(0.025, 0.04, 0.035))
	_add_visual_box("NightGroundRight", Vector3(22, -0.08, 0), Vector3(28, 0.16, 24), Color(0.025, 0.04, 0.035))
	var rng = RandomNumberGenerator.new()
	rng.seed = 27011
	for side in [-1, 1]:
		for tree_z in [5.0, -5.0]:
			_add_tree(Vector3(side * 15.0, 0, tree_z), rng.randf_range(8.0, 11.0), rng.randf_range(0.85, 1.2))
	for index in range(32):
		var tree_x = rng.randf_range(-28.0, 28.0)
		var tree_z = rng.randf_range(23.0, 55.0)
		if absf(tree_x) < 3.5 and tree_z < 31.0:
			continue
		_add_tree(Vector3(tree_x, 0, tree_z), rng.randf_range(7.0, 12.0), rng.randf_range(0.75, 1.35))
	_add_moon(Vector3(1.5, 19, 49))

func _build_tile_floor() -> void:
	var tile_mesh = BoxMesh.new()
	tile_mesh.size = Vector3(0.97, 0.035, 0.97)
	var multi_mesh = MultiMesh.new()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.use_colors = true
	multi_mesh.mesh = tile_mesh
	multi_mesh.instance_count = 16 * 24
	var rng = RandomNumberGenerator.new()
	rng.seed = 54019
	var palette = [Color(0.44, 0.48, 0.43), Color(0.38, 0.42, 0.39), Color(0.47, 0.47, 0.40), Color(0.34, 0.39, 0.37)]
	var instance_index := 0
	for z_index in range(24):
		for x_index in range(16):
			var tile_position = Vector3(-7.5 + x_index, 0.025, -11.5 + z_index)
			multi_mesh.set_instance_transform(instance_index, Transform3D(Basis(), tile_position))
			var tile_color: Color = palette[rng.randi_range(0, palette.size() - 1)]
			if rng.randf() < 0.035:
				tile_color = Color(0.24, 0.28, 0.27)
			multi_mesh.set_instance_color(instance_index, tile_color)
			instance_index += 1
	var tiles = MultiMeshInstance3D.new()
	tiles.name = "LowResolutionFloorTiles"
	tiles.multimesh = multi_mesh
	tiles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var tile_material = StandardMaterial3D.new()
	tile_material.vertex_color_use_as_albedo = true
	tile_material.roughness = 1.0
	tile_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	tiles.material_override = tile_material
	add_child(tiles)

func _build_doors() -> void:
	_add_door_frame(Vector3(-2.5, 0, 2), 1.9, true)
	_add_door("ReceptionDoor", Vector3(-2.5, 0, 1.05), -PI / 2.0)
	_add_door_frame(Vector3(2.5, 0, 0.75), 1.9, true)
	_add_door("WardDoor", Vector3(2.5, 0, 1.85), PI / 2.0)
	_add_door_frame(Vector3(-3.5, 0, -4), 1.9, false)
	_add_door("StorageDoor", Vector3(-4.42, 0, -4), 0.0)
	_add_door_frame(Vector3(3.5, 0, -5), 1.9, false)
	_add_door("WardRearDoor", Vector3(2.55, 0, -5), 0.0)

func _add_door_frame(center: Vector3, width: float, along_side_wall: bool) -> void:
	var frame_color = Color(0.22, 0.24, 0.21)
	if along_side_wall:
		_add_box("DoorJamb", Vector3(center.x, 1.35, center.z - width * 0.5), Vector3(0.28, 2.7, 0.16), frame_color)
		_add_box("DoorJamb", Vector3(center.x, 1.35, center.z + width * 0.5), Vector3(0.28, 2.7, 0.16), frame_color)
		_add_box("DoorHeader", Vector3(center.x, 2.75, center.z), Vector3(0.3, 0.22, width + 0.16), frame_color)
	else:
		_add_box("DoorJamb", Vector3(center.x - width * 0.5, 1.35, center.z), Vector3(0.16, 2.7, 0.28), frame_color)
		_add_box("DoorJamb", Vector3(center.x + width * 0.5, 1.35, center.z), Vector3(0.16, 2.7, 0.28), frame_color)
		_add_box("DoorHeader", Vector3(center.x, 2.75, center.z), Vector3(width + 0.16, 0.22, 0.3), frame_color)

func _add_door(door_name: String, hinge_position: Vector3, yaw: float) -> void:
	var door = AnimatableBody3D.new()
	door.name = door_name
	door.set_script(DoorScript)
	door.position = hinge_position
	door.rotation.y = yaw
	var leaf = MeshInstance3D.new()
	leaf.name = "DoorLeaf"
	leaf.position = Vector3(0.86, 1.3, 0)
	var leaf_mesh = BoxMesh.new()
	leaf_mesh.size = Vector3(1.72, 2.6, 0.1)
	leaf.mesh = leaf_mesh
	var leaf_material = _make_material(Color(0.18, 0.25, 0.23))
	leaf_material.albedo_texture = _grain_texture
	leaf_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	leaf_material.uv1_scale = Vector3(2, 2, 1)
	leaf.material_override = leaf_material
	door.add_child(leaf)
	var collision = CollisionShape3D.new()
	collision.position = Vector3(0.86, 1.3, 0)
	var shape = BoxShape3D.new()
	shape.size = Vector3(1.72, 2.6, 0.12)
	collision.shape = shape
	door.add_child(collision)
	var observation_glass = MeshInstance3D.new()
	observation_glass.name = "DoorWindow"
	observation_glass.position = Vector3(0.86, 1.95, 0.057)
	var glass_mesh = BoxMesh.new()
	glass_mesh.size = Vector3(0.44, 0.38, 0.025)
	observation_glass.mesh = glass_mesh
	var glass_material = StandardMaterial3D.new()
	glass_material.albedo_color = Color(0.13, 0.21, 0.27, 0.52)
	glass_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass_material.roughness = 0.28
	observation_glass.material_override = glass_material
	door.add_child(observation_glass)
	var handle = MeshInstance3D.new()
	handle.name = "Handle"
	handle.position = Vector3(1.52, 1.15, 0.08)
	var handle_mesh = SphereMesh.new()
	handle_mesh.radius = 0.055
	handle_mesh.height = 0.11
	handle.mesh = handle_mesh
	handle.material_override = _make_material(Color(0.57, 0.48, 0.3))
	door.add_child(handle)
	add_child(door)
	var label = Label3D.new()
	label.text = "E  ABRIR / CERRAR"
	label.position = hinge_position + Vector3(0, 2.92, 0)
	label.font_size = 22
	label.pixel_size = 0.004
	label.modulate = Color(0.64, 0.69, 0.61, 0.72)
	add_child(label)

func _build_detail_pass() -> void:
	# Scuffed wall protection, exposed pipework and small traces of the evacuation.
	_add_box("LeftWallWainscotFront", Vector3(-7.78, 0.42, 9.15), Vector3(0.08, 0.84, 5.5), Color(0.16, 0.25, 0.22))
	_add_box("LeftWallWainscotMiddle", Vector3(-7.78, 0.42, 0), Vector3(0.08, 0.84, 7.1), Color(0.16, 0.25, 0.22))
	_add_box("LeftWallWainscotRear", Vector3(-7.78, 0.42, -9.15), Vector3(0.08, 0.84, 5.5), Color(0.16, 0.25, 0.22))
	_add_box("RightWallWainscotFront", Vector3(7.78, 0.42, 9.15), Vector3(0.08, 0.84, 5.5), Color(0.16, 0.25, 0.22))
	_add_box("RightWallWainscotMiddle", Vector3(7.78, 0.42, 0), Vector3(0.08, 0.84, 7.1), Color(0.16, 0.25, 0.22))
	_add_box("RightWallWainscotRear", Vector3(7.78, 0.42, -9.15), Vector3(0.08, 0.84, 5.5), Color(0.16, 0.25, 0.22))
	_add_box("LeftPipe", Vector3(-7.62, 2.55, -2), Vector3(0.12, 0.12, 15), Color(0.24, 0.29, 0.27))
	_add_box("RightPipe", Vector3(7.62, 2.55, -5), Vector3(0.12, 0.12, 11), Color(0.26, 0.28, 0.25))
	_add_box("CeilingCable", Vector3(0.75, 2.98, -3), Vector3(0.07, 0.16, 3.4), Color(0.035, 0.04, 0.04))
	_add_box("CeilingCableDrop", Vector3(0.75, 2.45, -4.7), Vector3(0.07, 1.0, 0.07), Color(0.035, 0.04, 0.04))
	_add_box("TriageCurtainRail", Vector3(5.6, 2.55, -7.6), Vector3(3.8, 0.08, 0.08), Color(0.34, 0.36, 0.32))
	_add_visual_box("TriageCurtain", Vector3(5.6, 1.55, -7.6), Vector3(3.5, 2.0, 0.045), Color(0.16, 0.23, 0.22), 1)
	_add_box("FallenCeilingTile", Vector3(-1.1, 0.06, -1.6), Vector3(1.0, 0.07, 0.55), Color(0.34, 0.32, 0.26))
	_add_box("ScatteredPaperA", Vector3(-4.8, 0.055, 5.5), Vector3(0.42, 0.025, 0.32), Color(0.46, 0.43, 0.32))
	_add_box("ScatteredPaperB", Vector3(4.0, 0.055, -3.2), Vector3(0.35, 0.025, 0.25), Color(0.49, 0.46, 0.35))
	_add_stain(Vector3(3.3, 0.045, -8.6), Vector3(0.75, 0.025, 0.42), Color(0.16, 0.025, 0.02, 0.78))
	_add_stain(Vector3(4.0, 0.045, -8.2), Vector3(0.28, 0.025, 0.18), Color(0.12, 0.02, 0.018, 0.72))
	_add_stain(Vector3(-1.2, 0.045, 6.0), Vector3(0.52, 0.025, 0.3), Color(0.1, 0.025, 0.02, 0.55))
	_add_fluorescent_fixture(Vector3(0, 3.01, 1), Color(0.44, 0.49, 0.42))
	_add_fluorescent_fixture(Vector3(-5.1, 3.01, 6.7), Color(0.39, 0.43, 0.36))
	_add_fluorescent_fixture(Vector3(5.1, 3.01, -7.4), Color(0.38, 0.44, 0.5))

func _add_fluorescent_fixture(fixture_position: Vector3, color: Color) -> void:
	var fixture = MeshInstance3D.new()
	fixture.position = fixture_position
	var fixture_mesh = BoxMesh.new()
	fixture_mesh.size = Vector3(1.55, 0.07, 0.42)
	fixture.mesh = fixture_mesh
	var fixture_material = StandardMaterial3D.new()
	fixture_material.albedo_color = color
	fixture_material.emission_enabled = true
	fixture_material.emission = color * 0.35
	fixture_material.emission_energy_multiplier = 0.45
	fixture.material_override = fixture_material
	add_child(fixture)

func _add_fixture_light(light_position: Vector3, color: Color, energy: float, radius: float, shadows: bool) -> void:
	var lamp = OmniLight3D.new()
	lamp.name = "FlickeringFluorescent"
	lamp.position = light_position
	lamp.light_color = color
	lamp.light_energy = energy
	lamp.omni_range = radius
	lamp.shadow_enabled = shadows
	lamp.set_meta("base_energy", energy)
	_flicker_lights.append(lamp)
	add_child(lamp)

func _add_stain(stain_position: Vector3, stain_scale: Vector3, color: Color) -> void:
	var stain = MeshInstance3D.new()
	stain.position = stain_position
	stain.scale = stain_scale
	var stain_mesh = SphereMesh.new()
	stain_mesh.radius = 0.5
	stain_mesh.height = 0.2
	stain_mesh.radial_segments = 8
	stain_mesh.rings = 4
	stain.mesh = stain_mesh
	var stain_material = StandardMaterial3D.new()
	stain_material.albedo_color = color
	stain_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	stain_material.roughness = 1.0
	stain.material_override = stain_material
	add_child(stain)

func _create_grain_texture() -> ImageTexture:
	var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	var rng = RandomNumberGenerator.new()
	rng.seed = 81273
	for y in range(16):
		for x in range(16):
			var value = rng.randf_range(0.78, 1.0)
			if x % 8 == 0 or y % 8 == 0:
				value *= 0.72
			image.set_pixel(x, y, Color(value, value, value, 1.0))
	return ImageTexture.create_from_image(image)

func _build_side_wall(x_position: float, wall_name: String) -> void:
	var wall_color = Color(0.18, 0.19, 0.18)
	_add_box(wall_name + "FrontSection", Vector3(x_position, 1.5, 9.15), Vector3(0.3, 3, 5.7), wall_color)
	_add_box(wall_name + "MiddleSection", Vector3(x_position, 1.5, 0), Vector3(0.3, 3, 7.4), wall_color)
	_add_box(wall_name + "RearSection", Vector3(x_position, 1.5, -9.15), Vector3(0.3, 3, 5.7), wall_color)
	_add_window(x_position, 5, wall_name + "FrontWindow")
	_add_window(x_position, -5, wall_name + "RearWindow")

func _add_window(x_position: float, z_position: float, window_name: String) -> void:
	var frame_color = Color(0.32, 0.34, 0.31)
	var pane_color = Color(0.12, 0.19, 0.27, 0.28)
	_add_box(window_name + "Sill", Vector3(x_position, 0.84, z_position), Vector3(0.36, 0.32, 2.8), frame_color)
	_add_box(window_name + "Header", Vector3(x_position, 2.65, z_position), Vector3(0.36, 0.9, 2.8), frame_color)
	_add_box(window_name + "JambA", Vector3(x_position, 1.6, z_position - 1.36), Vector3(0.36, 1.5, 0.12), frame_color)
	_add_box(window_name + "JambB", Vector3(x_position, 1.6, z_position + 1.36), Vector3(0.36, 1.5, 0.12), frame_color)
	_add_glass(window_name + "Pane", Vector3(x_position, 1.61, z_position), Vector3(0.035, 1.12, 2.58), pane_color)
	_add_box(window_name + "Mullion", Vector3(x_position, 1.6, z_position), Vector3(0.08, 1.15, 0.07), frame_color)

func _add_window_light(x_position: float, z_position: float) -> void:
	var window_light = OmniLight3D.new()
	window_light.name = "MoonlightThroughWindow"
	window_light.position = Vector3(x_position, 1.7, z_position)
	window_light.light_color = Color(0.42, 0.53, 0.72)
	window_light.light_energy = 0.28
	window_light.omni_range = 4.8
	add_child(window_light)

func _add_glass(glass_name: String, glass_position: Vector3, glass_size: Vector3, color: Color) -> void:
	var pane = MeshInstance3D.new()
	pane.name = glass_name
	pane.position = glass_position
	var mesh = BoxMesh.new()
	mesh.size = glass_size
	pane.mesh = mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.roughness = 0.35
	pane.material_override = material
	pane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(pane)

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

func _add_visual_box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color, layer_mask: int = 2) -> void:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = box_name
	mesh_instance.position = box_position
	mesh_instance.layers = layer_mask
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
	if is_equal_approx(box_size.y, 3.0):
		box_position.y = 1.55
		box_size.y = 3.2
	if box_size.y > 3.0 and minf(box_size.x, box_size.z) < 0.6:
		if box_size.x > box_size.z:
			box_size.x += 0.04
		else:
			box_size.z += 0.04
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
	if _grain_texture != null and (box_size.y > 2.0 or box_name.contains("Wall") or box_name.contains("Section") or box_name.contains("Divider") or box_name.contains("Floor") or box_name.contains("Ceiling") or box_name.contains("Door") or box_name.contains("Pipe")):
		material.albedo_texture = _grain_texture
		material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		material.uv1_scale = Vector3(2.0, 2.0, 1.0)
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

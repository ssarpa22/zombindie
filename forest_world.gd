extends Node3D

const WORLD_RADIUS := 300.0
const STATION_X := 1.4
const STATION_Z := 220.0

func _ready() -> void:
	_build_terrain()
	_build_dirt_road()
	_build_batched_forest()
	_build_police_station()
	_build_world_boundary()

func _build_world_boundary() -> void:
	var segments := 48
	var radius := WORLD_RADIUS - 3.0
	var segment_length := 2.0 * radius * tan(PI / float(segments)) + 1.5
	for index in range(segments):
		var angle := TAU * float(index) / float(segments)
		var wall := StaticBody3D.new()
		wall.name = "WorldLimit_%02d" % index
		wall.position = Vector3(sin(angle) * radius, 4.0, cos(angle) * radius)
		wall.rotation.y = angle + PI * 0.5
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = Vector3(2.0, 10.0, segment_length)
		collision.shape = shape
		wall.add_child(collision)
		add_child(wall)

func _build_terrain() -> void:
	var ground = StaticBody3D.new()
	ground.name = "ForestGround"
	ground.position.y = -0.16
	var ground_mesh = MeshInstance3D.new()
	var disc = CylinderMesh.new()
	disc.top_radius = WORLD_RADIUS
	disc.bottom_radius = WORLD_RADIUS
	disc.height = 0.16
	disc.radial_segments = 96
	ground_mesh.mesh = disc
	ground_mesh.material_override = _make_material(Color(0.025, 0.04, 0.035))
	ground_mesh.layers = 2
	ground.add_child(ground_mesh)
	var ground_collision = CollisionShape3D.new()
	var disc_shape = CylinderShape3D.new()
	disc_shape.radius = WORLD_RADIUS
	disc_shape.height = 0.18
	ground_collision.shape = disc_shape
	ground.add_child(ground_collision)
	add_child(ground)

func _build_dirt_road() -> void:
	var road_material = _make_dirt_material()
	var start_z := 12.0
	var end_z := 210.0
	var segment_length := 8.0
	var previous = Vector3(_road_x(start_z), -0.035, start_z)
	var z_value := start_z + segment_length
	while z_value <= end_z + 0.01:
		var next = Vector3(_road_x(z_value), -0.035, z_value)
		_add_road_segment(previous, next, segment_length, road_material)
		previous = next
		z_value += segment_length
	var finish = Vector3(STATION_X, -0.035, 220.0)
	_add_road_segment(previous, finish, previous.distance_to(finish), road_material)

func _road_x(z_value: float) -> float:
	var progress = clampf((z_value - 12.0) / 198.0, 0.0, 1.0)
	return STATION_X + 10.0 * sin(progress * PI) + 3.0 * sin(progress * PI * 2.0)

func _add_road_segment(start: Vector3, finish: Vector3, _nominal_length: float, road_material: StandardMaterial3D) -> void:
	var delta = finish - start
	var length = Vector2(delta.x, delta.z).length()
	var road = MeshInstance3D.new()
	var road_mesh = BoxMesh.new()
	road_mesh.size = Vector3(5.2, 0.055, length + 0.35)
	road.mesh = road_mesh
	road.position = (start + finish) * 0.5
	road.position.y = -0.035
	road.rotation.y = atan2(delta.x, delta.z)
	road.material_override = road_material
	road.layers = 2
	add_child(road)

func _build_batched_forest() -> void:
	var specs: Array[Dictionary] = []
	var rng = RandomNumberGenerator.new()
	rng.seed = 622019
	var attempts := 0
	while specs.size() < 2600 and attempts < 12000:
		attempts += 1
		var angle = rng.randf_range(0.0, TAU)
		var radius = sqrt(rng.randf_range(28.0 * 28.0, 296.0 * 296.0))
		var x = sin(angle) * radius
		var z = cos(angle) * radius
		if Vector2(x - STATION_X, z - STATION_Z).length() < 21.0:
			continue
		if z > 8.0 and z < STATION_Z + 10.0 and absf(x - _road_x(z)) < 8.5:
			continue
		if Vector2(x, z).length() < 28.0:
			continue
		specs.append({
			"position": Vector3(x, -0.08, z),
			"height": rng.randf_range(7.0, 13.0),
			"scale": rng.randf_range(0.75, 1.45),
			"shade": rng.randf_range(0.76, 1.18)
		})
	_add_tree_batch(specs)

func _add_tree_batch(specs: Array[Dictionary]) -> void:
	var trunks = MultiMesh.new()
	trunks.transform_format = MultiMesh.TRANSFORM_3D
	trunks.use_colors = true
	var trunk_mesh = CylinderMesh.new()
	trunk_mesh.top_radius = 0.14
	trunk_mesh.bottom_radius = 0.32
	trunk_mesh.height = 1.0
	trunk_mesh.radial_segments = 5
	trunks.mesh = trunk_mesh
	trunks.instance_count = specs.size()
	for index in range(specs.size()):
		var spec: Dictionary = specs[index]
		var pos: Vector3 = spec["position"]
		var tree_height: float = spec["height"]
		var tree_scale: float = spec["scale"]
		trunks.set_instance_transform(index, Transform3D(Basis.from_scale(Vector3(tree_scale, tree_height, tree_scale)), pos + Vector3(0, tree_height * 0.5, 0)))
		var shade: float = spec["shade"]
		trunks.set_instance_color(index, Color(shade, shade, shade, 1.0))
	_add_multimesh("ForestTrunks", trunks, Color(0.055, 0.062, 0.051))
	for tier in range(3):
		var canopy_mesh = CylinderMesh.new()
		canopy_mesh.top_radius = 0.0
		canopy_mesh.bottom_radius = 1.0
		canopy_mesh.height = 1.0
		canopy_mesh.radial_segments = 5
		var crowns = MultiMesh.new()
		crowns.transform_format = MultiMesh.TRANSFORM_3D
		crowns.use_colors = true
		crowns.mesh = canopy_mesh
		crowns.instance_count = specs.size()
		for index in range(specs.size()):
			var spec: Dictionary = specs[index]
			var pos: Vector3 = spec["position"]
			var tree_height: float = spec["height"]
			var tree_scale: float = spec["scale"]
			var crown_radius := (2.05 - tier * 0.48) * tree_scale
			var crown_height := tree_height * 0.42
			var crown_position = pos + Vector3(0, tree_height * (0.38 + tier * 0.17), 0)
			crowns.set_instance_transform(index, Transform3D(Basis.from_scale(Vector3(crown_radius, crown_height, crown_radius)), crown_position))
			var shade: float = spec["shade"]
			crowns.set_instance_color(index, Color(shade, shade, shade, 1.0))
		var base_color = Color(0.018 + tier * 0.005, 0.043 + tier * 0.007, 0.035 + tier * 0.006)
		_add_multimesh("ForestCanopy%d" % tier, crowns, base_color)

func _add_multimesh(instance_name: String, multi_mesh: MultiMesh, base_color: Color) -> void:
	var instance = MultiMeshInstance3D.new()
	instance.name = instance_name
	instance.multimesh = multi_mesh
	instance.layers = 2
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	instance.custom_aabb = AABB(Vector3(-WORLD_RADIUS, -2, -WORLD_RADIUS), Vector3(WORLD_RADIUS * 2, 20, WORLD_RADIUS * 2))
	var material = StandardMaterial3D.new()
	material.albedo_color = base_color
	material.vertex_color_use_as_albedo = true
	material.roughness = 1.0
	instance.material_override = material
	add_child(instance)

func _build_police_station() -> void:
	var station_center = Vector3(STATION_X, 0, STATION_Z + 8.0)
	var wall_color = Color(0.24, 0.26, 0.24)
	_add_station_box("StationFloor", station_center + Vector3(0, -0.15, 0), Vector3(22, 0.3, 16), Color(0.12, 0.14, 0.13))
	_add_station_box("StationLeftWall", station_center + Vector3(-11, 2.0, 0), Vector3(0.3, 4.0, 16), wall_color)
	_add_station_box("StationRightWall", station_center + Vector3(11, 2.0, 0), Vector3(0.3, 4.0, 16), wall_color)
	_add_station_box("StationRearWall", station_center + Vector3(0, 2.0, 8), Vector3(22, 4.0, 0.3), wall_color)
	_add_station_box("StationFrontLeft", station_center + Vector3(-6.3, 2.0, -8), Vector3(9.4, 4.0, 0.3), wall_color)
	_add_station_box("StationFrontRight", station_center + Vector3(6.3, 2.0, -8), Vector3(9.4, 4.0, 0.3), wall_color)
	_add_station_box("StationEntryHeader", station_center + Vector3(0, 3.6, -8), Vector3(3.2, 0.8, 0.3), wall_color)
	_add_station_box("StationRoof", station_center + Vector3(0, 4.0, 0), Vector3(22.4, 0.4, 16.4), Color(0.13, 0.15, 0.14))
	_add_station_box("BookingDesk", station_center + Vector3(0, 0.6, -2), Vector3(5.0, 1.2, 1.0), Color(0.24, 0.19, 0.14))
	_add_station_box("DeskTop", station_center + Vector3(0, 1.25, -2), Vector3(5.2, 0.12, 1.1), Color(0.34, 0.28, 0.2))
	_add_station_box("InteriorPartition", station_center + Vector3(0, 1.8, 2.0), Vector3(16, 3.6, 0.2), Color(0.18, 0.21, 0.2))
	_add_jail_bars(station_center)
	var sign = Label3D.new()
	sign.text = "COMISARIA"
	sign.position = station_center + Vector3(0, 3.35, -8.4)
	sign.font_size = 56
	sign.pixel_size = 0.006
	sign.modulate = Color(0.7, 0.75, 0.69)
	add_child(sign)
	_add_station_car(station_center + Vector3(7.0, 0, -12.0))
	_add_radio_tower(station_center + Vector3(9.5, 0, 7.0))

func _add_jail_bars(center: Vector3) -> void:
	for index in range(9):
		var x = -3.0 + index * 0.75
		_add_station_box("CellBar", center + Vector3(x, 1.4, 3.5), Vector3(0.07, 2.8, 0.07), Color(0.19, 0.23, 0.23))
	_add_station_box("CellTopBar", center + Vector3(0, 2.8, 3.5), Vector3(6.2, 0.08, 0.08), Color(0.19, 0.23, 0.23))

func _add_station_car(car_position: Vector3) -> void:
	_add_station_box("PatrolCarBody", car_position + Vector3(0, 0.58, 0), Vector3(2.2, 0.68, 4.2), Color(0.15, 0.18, 0.18))
	_add_station_visual("PatrolCarCab", car_position + Vector3(0, 1.15, 0.15), Vector3(1.75, 0.65, 2.0), Color(0.19, 0.22, 0.22))
	_add_station_visual("PoliceLightRed", car_position + Vector3(-0.4, 1.55, 0.1), Vector3(0.55, 0.16, 0.22), Color(0.42, 0.045, 0.035), true)
	_add_station_visual("PoliceLightBlue", car_position + Vector3(0.4, 1.55, 0.1), Vector3(0.55, 0.16, 0.22), Color(0.035, 0.13, 0.38), true)
	for side in [-1, 1]:
		for z_offset in [-1.35, 1.35]:
			var wheel = MeshInstance3D.new()
			wheel.position = car_position + Vector3(side * 1.12, 0.38, z_offset)
			var wheel_mesh = CylinderMesh.new()
			wheel_mesh.top_radius = 0.36
			wheel_mesh.bottom_radius = 0.36
			wheel_mesh.height = 0.2
			wheel_mesh.radial_segments = 8
			wheel.mesh = wheel_mesh
			wheel.rotation.z = PI / 2.0
			wheel.material_override = _make_material(Color(0.035, 0.04, 0.04))
			add_child(wheel)

func _add_radio_tower(base_position: Vector3) -> void:
	_add_station_box("RadioTowerMast", base_position + Vector3(0, 7, 0), Vector3(0.18, 14, 0.18), Color(0.16, 0.19, 0.18))
	for height in [3.5, 7.0, 10.5]:
		_add_station_box("RadioTowerCrossbar", base_position + Vector3(0, height, 0), Vector3(4.0, 0.08, 0.08), Color(0.16, 0.19, 0.18))
	_add_station_box("RadioTowerDiagonal", base_position + Vector3(1.1, 4.5, 0), Vector3(0.08, 7.0, 0.08), Color(0.16, 0.19, 0.18))

func _add_station_box(box_name: String, box_position: Vector3, box_size: Vector3, color: Color) -> void:
	var body = StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	var mesh_instance = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _make_material(color)
	body.add_child(mesh_instance)
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _add_station_visual(object_name: String, object_position: Vector3, object_size: Vector3, color: Color, emissive: bool = false) -> void:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = object_name
	mesh_instance.position = object_position
	var mesh = BoxMesh.new()
	mesh.size = object_size
	mesh_instance.mesh = mesh
	var material = _make_material(color)
	if emissive:
		material.emission_enabled = true
		material.emission = color
		material.emission_energy_multiplier = 0.7
	mesh_instance.material_override = material
	add_child(mesh_instance)

func _make_dirt_material() -> StandardMaterial3D:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	var rng = RandomNumberGenerator.new()
	rng.seed = 1781
	for y in range(32):
		for x in range(32):
			var shade = rng.randf_range(0.68, 1.0)
			image.set_pixel(x, y, Color(0.29 * shade, 0.24 * shade, 0.17 * shade, 1.0))
	var material = StandardMaterial3D.new()
	material.albedo_texture = ImageTexture.create_from_image(image)
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	material.uv1_scale = Vector3(3, 1, 8)
	material.roughness = 1.0
	return material

func _make_material(color: Color) -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	return material

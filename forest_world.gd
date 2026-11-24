extends Node3D

const WORLD_RADIUS := 2121.32
const WorldLayoutScene: PackedScene = preload("res://WorldLayout.tscn")
const STATION_X := 1.4
const STATION_Z := 220.0
const FOREST_SECTOR_COUNT := 11
const FOREST_MAX_DRAW_DISTANCE := WORLD_RADIUS
const FOREST_VIEW_MARGIN := 6.0
const FOREST_VIEW_HYSTERESIS := 8.0
const FOREST_DISTANCE_HYSTERESIS := 12.0

var _forest_sectors: Array[Dictionary] = []
var _world_layout: Node3D

func _ready() -> void:
	if has_node("ForestGround") and has_node("EditableWorldLayout"):
		return
	_world_layout = WorldLayoutScene.instantiate() as Node3D
	_world_layout.name = "EditableWorldLayout"
	add_child(_world_layout)
	_build_terrain()
	_build_dirt_road()
	_build_regional_roads()
	_build_batched_forest()
	_build_police_station()
	_build_world_boundary()

func _process(_delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not is_instance_valid(camera):
		return

	_update_forest_visibility(camera)

func _update_forest_visibility(camera: Camera3D) -> void:
	if not is_instance_valid(camera):
		return
	var frustum: Array[Plane] = camera.get_frustum()
	var camera_transform: Transform3D = camera.global_transform
	var camera_position: Vector3 = camera.global_position
	for sector: Dictionary in _forest_sectors:
		var batches: Array = sector["batches"]
		if batches.is_empty():
			continue
		var first_batch: MultiMeshInstance3D = batches[0]
		var currently_visible: bool = first_batch.visible
		var local_bounds: AABB = sector["bounds"]
		var view_margin: float = FOREST_VIEW_MARGIN
		if currently_visible:
			view_margin += FOREST_VIEW_HYSTERESIS
		var world_bounds: AABB = (global_transform * local_bounds).grow(view_margin)
		var inside_probe: Vector3 = camera_transform.origin - camera_transform.basis.z * (camera.near + 0.1)
		var inside_view: bool = _aabb_intersects_frustum(world_bounds, frustum, inside_probe)
		var draw_distance: float = minf(FOREST_MAX_DRAW_DISTANCE, GameSettings.view_distance)
		if currently_visible:
			draw_distance += FOREST_DISTANCE_HYSTERESIS
		var inside_draw_distance: bool = _aabb_distance_squared(world_bounds, camera_position) <= draw_distance * draw_distance
		var should_be_visible: bool = inside_view and inside_draw_distance
		if should_be_visible == currently_visible:
			continue
		for batch_variant: Variant in batches:
			var batch: MultiMeshInstance3D = batch_variant
			batch.visible = should_be_visible

static func _aabb_intersects_frustum(bounds: AABB, frustum: Array[Plane], inside_probe: Vector3) -> bool:
	for plane: Plane in frustum:
		var inward_plane: Plane = plane
		if not plane.is_point_over(inside_probe):
			inward_plane = -plane
		var support_point: Vector3 = bounds.get_support(inward_plane.normal)
		if inward_plane.distance_to(support_point) < 0.0:
			return false
	return true

static func _aabb_distance_squared(bounds: AABB, point: Vector3) -> float:
	var closest_point := Vector3(
		clampf(point.x, bounds.position.x, bounds.end.x),
		clampf(point.y, bounds.position.y, bounds.end.y),
		clampf(point.z, bounds.position.z, bounds.end.z)
	)
	return closest_point.distance_squared_to(point)

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

func _build_regional_roads() -> void:
	var road_material := _make_dirt_material()
	var routes := _world_layout.get_node("Roads").get_children()
	for route_node: Node in routes:
		var waypoints := route_node.get_children()
		for index in range(waypoints.size() - 1):
			var start := (waypoints[index] as Node3D).global_position
			var finish := (waypoints[index + 1] as Node3D).global_position
			_add_road_segment(start, finish, start.distance_to(finish), road_material)

func _build_batched_forest() -> void:
	var sector_size: float = float(WORLD_RADIUS * 2) / float(FOREST_SECTOR_COUNT)
	var sector_specs: Dictionary = {}
	var rng = RandomNumberGenerator.new()
	rng.seed = 622019
	var attempts := 0
	var tree_count := 0
	var tree_targets := [900, 1600, 2600]
	var foliage_quality := clampi(GameSettings.foliage_quality, 0, 2)
	var target_tree_count: int = tree_targets[foliage_quality]
	var quality := clampi(GameSettings.mesh_quality, 0, 2)
	while tree_count < target_tree_count and attempts < 12000:
		attempts += 1
		var angle: float = rng.randf_range(0.0, TAU)
		var radius: float = sqrt(rng.randf_range(40.0 * 40.0, (WORLD_RADIUS - 25.0) * (WORLD_RADIUS - 25.0)))
		var x: float = sin(angle) * radius
		var z: float = cos(angle) * radius
		if Vector2(x - STATION_X, z - STATION_Z).length() < 21.0:
			continue
		if z > 8.0 and z < STATION_Z + 10.0 and absf(x - _road_x(z)) < 8.5:
			continue
		if _is_near_regional_road(Vector2(x, z)):
			continue
		if Vector2(x, z).length() < 28.0:
			continue
		var sector_x: int = clampi(floori((x + WORLD_RADIUS) / sector_size), 0, FOREST_SECTOR_COUNT - 1)
		var sector_z: int = clampi(floori((z + WORLD_RADIUS) / sector_size), 0, FOREST_SECTOR_COUNT - 1)
		var sector_id := Vector2i(sector_x, sector_z)
		var bucket: Array[Dictionary] = []
		if sector_specs.has(sector_id):
			bucket = sector_specs[sector_id]
		bucket.append({
			"position": Vector3(x, -0.08, z),
			"height": rng.randf_range(7.0, 13.0),
			"scale": rng.randf_range(0.75, 1.45),
			"shade": rng.randf_range(0.76, 1.18)
		})
		sector_specs[sector_id] = bucket
		tree_count += 1
	_add_far_regions()

	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.14
	trunk_mesh.bottom_radius = 0.32
	trunk_mesh.height = 1.0
	var mesh_segments := 3 + quality
	trunk_mesh.radial_segments = mesh_segments
	var canopy_meshes: Array[CylinderMesh] = []
	var canopy_materials: Array[StandardMaterial3D] = []
	for tier in range(3):
		var canopy_mesh := CylinderMesh.new()
		canopy_mesh.top_radius = 0.0
		canopy_mesh.bottom_radius = 1.0
		canopy_mesh.height = 1.0
		canopy_mesh.radial_segments = mesh_segments
		canopy_meshes.append(canopy_mesh)
		var base_color := Color(0.018 + tier * 0.005, 0.043 + tier * 0.007, 0.035 + tier * 0.006)
		var canopy_material := _make_material(base_color)
		canopy_material.vertex_color_use_as_albedo = true
		canopy_materials.append(canopy_material)
	var trunk_material := _make_material(Color(0.055, 0.062, 0.051))
	trunk_material.vertex_color_use_as_albedo = true

	for sector_key: Variant in sector_specs:
		var sector_id: Vector2i = sector_key
		var specs: Array[Dictionary] = sector_specs[sector_id]
		var sector_min_x: float = -WORLD_RADIUS + float(sector_id.x) * sector_size
		var sector_min_z: float = -WORLD_RADIUS + float(sector_id.y) * sector_size
		var sector_bounds := AABB(
			Vector3(sector_min_x, -1.0, sector_min_z),
			Vector3(sector_size, 18.0, sector_size)
		)
		var batches: Array[MultiMeshInstance3D] = []
		batches.append(_add_tree_batch("ForestTrunks", specs, sector_id, sector_bounds, trunk_mesh, trunk_material))
		for tier in range(3):
			batches.append(_add_canopy_batch(tier, specs, sector_id, sector_bounds, canopy_meshes[tier], canopy_materials[tier]))
		_forest_sectors.append({
			"bounds": sector_bounds,
			"batches": batches
		})

func _is_near_regional_road(point: Vector2) -> bool:
	for route_variant: Variant in _world_layout.get_node("Roads").get_children():
		var waypoints := (route_variant as Node).get_children()
		for index in range(waypoints.size() - 1):
			var from_position: Vector3 = (waypoints[index] as Node3D).global_position
			var to_position: Vector3 = (waypoints[index + 1] as Node3D).global_position
			if Geometry2D.get_closest_point_to_segment(point, Vector2(from_position.x, from_position.z), Vector2(to_position.x, to_position.z)).distance_to(point) < 15.0:
				return true
	return false

func _add_far_regions() -> void:
	var settings := {
		"GhostTown_LasAnimas": [Vector2(150, 110), 14, Color(0.22, 0.20, 0.16), 24011],
		"IndustrialDistrict": [Vector2(190, 130), 11, Color(0.20, 0.23, 0.21), 9017],
		"SouthHighwayTerminal": [Vector2(100, 75), 8, Color(0.25, 0.22, 0.16), 5103],
		"Sanatorium": [Vector2(90, 70), 6, Color(0.21, 0.25, 0.23), 833],
		"RangerShelter": [Vector2(48, 38), 3, Color(0.25, 0.19, 0.12), 180],
		"SewerAccess": [Vector2(9, 9), 1, Color(0.15, 0.2, 0.19), 22],
		"CreekBridge": [Vector2(38, 18), 2, Color(0.27, 0.24, 0.19), 41]
	}
	for location: Node3D in _world_layout.get_node("Locations").get_children():
		if not settings.has(location.name):
			continue
		var config: Array = settings[location.name]
		_add_region_buildings(location.name, location.global_position, config[0], int(config[1]), config[2], int(config[3]))

func _add_region_buildings(region_name: String, center: Vector3, footprint: Vector2, count: int, color: Color, seed_value: int) -> void:
	var region := Node3D.new()
	region.name = region_name
	region.position = center
	add_child(region)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	for index in range(count):
		var dimensions := Vector3(rng.randf_range(9.0, 18.0), rng.randf_range(4.0, 9.0), rng.randf_range(8.0, 15.0))
		var body := StaticBody3D.new()
		body.position = Vector3(rng.randf_range(-footprint.x * 0.5, footprint.x * 0.5), dimensions.y * 0.5, rng.randf_range(-footprint.y * 0.5, footprint.y * 0.5))
		var mesh_instance := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = dimensions
		mesh_instance.mesh = mesh
		mesh_instance.material_override = _make_material(color.darkened(rng.randf_range(0.0, 0.25)))
		body.add_child(mesh_instance)
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = dimensions
		collision.shape = shape
		body.add_child(collision)
		region.add_child(body)
	var sign := Label3D.new()
	sign.text = region_name.replace("_", " ").to_upper()
	sign.position.y = 16.0
	sign.font_size = 26
	sign.pixel_size = 0.012
	region.add_child(sign)

func _add_tree_batch(instance_name: String, specs: Array[Dictionary], sector_id: Vector2i, sector_bounds: AABB, trunk_mesh: CylinderMesh, trunk_material: StandardMaterial3D) -> MultiMeshInstance3D:
	var trunks = MultiMesh.new()
	trunks.transform_format = MultiMesh.TRANSFORM_3D
	trunks.use_colors = true
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
	return _add_multimesh("%s_%d_%d" % [instance_name, sector_id.x, sector_id.y], trunks, trunk_material, sector_bounds)

func _add_canopy_batch(tier: int, specs: Array[Dictionary], sector_id: Vector2i, sector_bounds: AABB, canopy_mesh: CylinderMesh, canopy_material: StandardMaterial3D) -> MultiMeshInstance3D:
	var crowns := MultiMesh.new()
	crowns.transform_format = MultiMesh.TRANSFORM_3D
	crowns.use_colors = true
	crowns.mesh = canopy_mesh
	crowns.instance_count = specs.size()
	for index in range(specs.size()):
		var spec: Dictionary = specs[index]
		var pos: Vector3 = spec["position"]
		var tree_height: float = spec["height"]
		var tree_scale: float = spec["scale"]
		var crown_radius: float = (2.05 - tier * 0.48) * tree_scale
		var crown_height: float = tree_height * 0.42
		var crown_position: Vector3 = pos + Vector3(0, tree_height * (0.38 + tier * 0.17), 0)
		crowns.set_instance_transform(index, Transform3D(Basis.from_scale(Vector3(crown_radius, crown_height, crown_radius)), crown_position))
		var shade: float = spec["shade"]
		crowns.set_instance_color(index, Color(shade, shade, shade, 1.0))
	var instance_name := "ForestCanopy%d_%d_%d" % [tier, sector_id.x, sector_id.y]
	return _add_multimesh(instance_name, crowns, canopy_material, sector_bounds)

func _add_multimesh(instance_name: String, multi_mesh: MultiMesh, material: StandardMaterial3D, sector_bounds: AABB) -> MultiMeshInstance3D:
	var instance = MultiMeshInstance3D.new()
	instance.name = instance_name
	instance.multimesh = multi_mesh
	instance.layers = 2
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	instance.custom_aabb = sector_bounds.grow(3.5)
	instance.material_override = material
	add_child(instance)
	return instance

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
	_add_two_sided_label("COMISARIA", station_center + Vector3(0, 3.35, -8.4), 56, 0.006, Color(0.7, 0.75, 0.69))
	_add_station_car(station_center + Vector3(7.0, 0, -12.0))
	_add_radio_tower(station_center + Vector3(9.5, 0, 7.0))

func _add_two_sided_label(label_text: String, label_position: Vector3, font_size: int, pixel_size: float, color: Color) -> void:
	for side in range(2):
		var label := Label3D.new()
		label.text = label_text
		label.position = label_position + Vector3(0.0, 0.0, 0.004 * side)
		label.rotation.y = PI * side
		label.font_size = font_size
		label.pixel_size = pixel_size
		label.modulate = color
		add_child(label)

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
	var texture_size: int = [16, 32, 64][clampi(GameSettings.texture_quality, 0, 2)]
	var image = Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	var rng = RandomNumberGenerator.new()
	rng.seed = 1781
	for y in range(texture_size):
		for x in range(texture_size):
			var shade = rng.randf_range(0.68, 1.0)
			image.set_pixel(x, y, Color(0.29 * shade, 0.24 * shade, 0.17 * shade, 1.0))
	image.generate_mipmaps()
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


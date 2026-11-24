extends SceneTree

const ForestWorldScript = preload("res://forest_world.gd")

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var frustum: Array[Plane] = [
		Plane(Vector3(1, 0, 0), -10),
		Plane(Vector3(-1, 0, 0), -10),
		Plane(Vector3(0, 1, 0), -10),
		Plane(Vector3(0, -1, 0), -10),
		Plane(Vector3(0, 0, -1), 1),
		Plane(Vector3(0, 0, 1), -20)
	]
	var inside_probe := Vector3(0, 0, -10)
	var partial_sector := AABB(Vector3(9, -1, -11), Vector3(3, 2, 2))
	var side_sector := AABB(Vector3(11, -1, -11), Vector3(2, 2, 2))
	var rear_sector := AABB(Vector3(-1, -1, 1), Vector3(2, 2, 2))
	assert(ForestWorldScript._aabb_intersects_frustum(partial_sector, frustum, inside_probe))
	assert(not ForestWorldScript._aabb_intersects_frustum(side_sector, frustum, inside_probe))
	assert(not ForestWorldScript._aabb_intersects_frustum(rear_sector, frustum, inside_probe))

	var sector_bounds := AABB(Vector3(-10, -10, -20), Vector3(20, 20, 20))
	assert(ForestWorldScript._aabb_distance_squared(sector_bounds, Vector3.ZERO) == 0.0)
	assert(ForestWorldScript._aabb_distance_squared(sector_bounds, Vector3(350, 0, 0)) > 300.0 * 300.0)

	var viewport := SubViewport.new()
	viewport.size = Vector2i(640, 360)
	root.add_child(viewport)
	var camera := Camera3D.new()
	camera.fov = 78.0
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.far = 300.0
	camera.position = Vector3(0, 2, 4)
	viewport.add_child(camera)
	camera.look_at(Vector3(0, 2, -100), Vector3.UP)
	camera.current = true
	var forest_world: Node3D = ForestWorldScript.new()
	viewport.add_child(forest_world)
	await process_frame
	forest_world.call("_update_forest_visibility", camera)
	var sectors: Array = forest_world.get("_forest_sectors")
	assert(sectors.size() >= 4 and sectors.size() <= 16)
	var tree_count := 0
	var visible_tree_count := 0
	var visible_batch_count := 0
	for sector_variant: Variant in sectors:
		var sector: Dictionary = sector_variant
		var batches: Array = sector["batches"]
		assert(batches.size() == 4)
		var trunk_batch: MultiMeshInstance3D = batches[0]
		tree_count += trunk_batch.multimesh.instance_count
		if trunk_batch.visible:
			visible_tree_count += trunk_batch.multimesh.instance_count
		for batch_variant: Variant in batches:
			if (batch_variant as MultiMeshInstance3D).visible:
				visible_batch_count += 1
	assert(tree_count == 2600)
	assert(visible_tree_count > 0 and visible_tree_count < tree_count)
	assert(visible_batch_count < sectors.size() * 4)
	var original_child_count: int = forest_world.get_child_count()
	camera.look_at(Vector3(0, 2, 100), Vector3.UP)
	await process_frame
	forest_world.call("_update_forest_visibility", camera)
	assert(forest_world.get_child_count() == original_child_count)
	var rotated_visible_tree_count := 0
	for sector_variant: Variant in sectors:
		var sector: Dictionary = sector_variant
		var rotated_trunk_batch: MultiMeshInstance3D = sector["batches"][0]
		if rotated_trunk_batch.visible:
			rotated_visible_tree_count += rotated_trunk_batch.multimesh.instance_count
	assert(rotated_visible_tree_count > 0 and rotated_visible_tree_count < tree_count)
	forest_world.free()
	viewport.free()
	print("FOREST_VISIBILITY_TEST_OK sectors=%d trees=%d visible_trees=%d visible_batches=%d rotated_visible_trees=%d" % [sectors.size(), tree_count, visible_tree_count, visible_batch_count, rotated_visible_tree_count])
	quit()

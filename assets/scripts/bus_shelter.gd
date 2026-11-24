extends StaticBody3D

func _ready() -> void:
	# Bus shelter: public transit waiting area
	var shelter_width := 3.0
	var shelter_depth := 2.5
	var roof_height := 2.0
	
	# Shelter floor
	var floor_mesh := BoxMesh.new()
	floor_mesh.size := Vector3(shelter_width, 0.1, shelter_depth)
	
	var floor_instance := MeshInstance3D.new()
	floor_instance.mesh := floor_mesh
	floor_instance.name := "BusShelterFloor"
	floor_instance.position := Vector3(0, 0.05, 0)
	floor_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(floor_instance)
	
	# Side walls (open front)
	var wall_mesh := BoxMesh.new()
	wall_mesh.size := Vector3(0.2, roof_height - 0.1, shelter_depth)
	
	for side in [-1, 1]:
		var wall_instance := MeshInstance3D.new()
		wall_instance.mesh := wall_mesh
		wall_instance.name := "BusShelterWall_%d" % (side == -1 and 1 or 2)
		wall_instance.position := Vector3(side * shelter_width * 0.5, roof_height * 0.5, -shelter_depth * 0.5 + 0.1)
		wall_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(wall_instance)
	
	# Roof (slanted, overhanging front)
	var roof_mesh := BoxMesh.new()
	roof_mesh.size := Vector3(shelter_width + 1.0, 0.3, shelter_depth + 1.0)
	
	var roof_instance := MeshInstance3D.new()
	roof_instance.mesh := roof_mesh
	roof_instance.name := "BusShelterRoof"
	roof_instance.position := Vector3(0, roof_height, 0)
	roof_instance.rotation.z := PI / 8.0
	roof_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(roof_instance)
	
	# Back wall (closed)
	var back_wall_mesh := BoxMesh.new()
	back_wall_mesh.size := Vector3(0.2, roof_height - 0.1, shelter_depth)
	
	var back_wall_instance := MeshInstance3D.new()
	back_wall_instance.mesh := back_wall_mesh
	back_wall_instance.name := "BusShelterBackWall"
	back_wall_instance.position := Vector3(0, roof_height * 0.5, shelter_depth * 0.5 - 0.1)
	back_wall_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(back_wall_instance)
	
	# Bench inside
	var bench_mesh := BoxMesh.new()
	bench_mesh.size := Vector3(1.5, 0.4, 0.3)
	
	var bench_instance := MeshInstance3D.new()
	bench_instance.mesh := bench_mesh
	bench_instance.name := "BusShelterBench"
	bench_instance.position := Vector3(0, 0.3, 0)
	bench_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(bench_instance)
	
	# Advertisement panel (on side)
	var adv_mesh := BoxMesh.new()
	adv_mesh.size := Vector3(0.8, 1.0, 0.02)
	
	var adv_instance := MeshInstance3D.new()
	adv_instance.mesh := adv_mesh
	adv_instance.name := "BusShelterAd"
	adv_instance.position := Vector3(shelter_width * 0.5 - 0.2, roof_height * 0.5, 0)
	adv_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(adv_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(shelter_width, roof_height, shelter_depth)
	collision.shape := shape
	collision.position := Vector3(0, roof_height * 0.5, 0)
	add_child(collision)
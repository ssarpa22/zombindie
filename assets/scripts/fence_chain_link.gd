extends StaticBody3D

func _ready() -> void:
	# Chain-link fence: diamond-pattern fence segments
	var fence_height := 1.5
	var mesh_density := 0.15 # width of each diamond
	var post_height := 2.0
	var post_depth := 0.2
	
	var total_length := 10.0
	
	# Posts
	for side in [-1, 1]:
		var post_mesh := CylinderMesh.new()
		post_mesh.top_radius := post_depth
		post_mesh.bottom_radius := post_depth
		post_mesh.height := post_height
		post_mesh.radial_segments := 6
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "ChainFence_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * total_length * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	# Diamond mesh segments
	diamond_count := int(total_length / mesh_density)
	for i in range(diamond_count):
		# Each diamond is a rotated box
		var diamond_mesh := BoxMesh.new()
		diamond_mesh.size := Vector3(mesh_density, fence_height * 0.5, mesh_density)
		
		var diamond_instance := MeshInstance3D.new()
		diamond_instance.mesh := diamond_mesh
		diamond_instance.name := "ChainFence_Diamond%d" % i
		
		# Position with offset and rotation
		offset_x := i * mesh_density
		diamond_instance.position := Vector3(
			offset_x - total_length * 0.5 + mesh_density * 0.5,
			fence_height * 0.5,
			0
		)
		# Rotate to diamond shape
		diamond_instance.rotation.z := PI / 4.0
		diamond_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(diamond_instance)
	
	# Top rail
	var rail_mesh := BoxMesh.new()
	rail_mesh.size := Vector3(total_length, 0.05, post_depth)
	
	var rail_instance := MeshInstance3D.new()
	rail_instance.mesh := rail_mesh
	rail_instance.name := "ChainFence_Rail"
	rail_instance.position := Vector3(total_length * 0.5, fence_height + 0.05, 0)
	rail_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(rail_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5, 0)
	add_child(collision)
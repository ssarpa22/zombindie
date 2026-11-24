extends StaticBody3D

func _ready() -> void:
	# Damaged chain-link fence: missing sections, sagging, leaning
	var fence_height := 1.5
	var post_height := 2.2
	var post_depth := 0.2
	
	var total_length := 10.0
	
	# Posts (some leaning)
	for side in [-1, 1]:
		for pos in [-0.5, 0, 0.5]:
			var post_angle := 0.0
			if pos != 0:
				post_angle := 0.1 * (side == -1 and -1 or 1) # slight lean
			
			var post_mesh := CylinderMesh.new()
			post_mesh.top_radius := post_depth
			post_mesh.bottom_radius := post_depth
			post_mesh.height := post_height
			post_mesh.radial_segments := 6
			
			var post_instance := MeshInstance3D.new()
			post_instance.mesh := post_mesh
			post_instance.name := "DamChainFence_Post_%d_%d" % (side == -1 and 1 or 2, pos == -0.5 and 1 or (pos == 0 and 2 or 3))
			post_instance.position := Vector3(side * (total_length * 0.5 + 0.5), post_height * 0.5, pos * 1.5 - 1.0)
			post_instance.rotation.z := post_angle
			post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
			add_child(post_instance)
	
	# Chain-link diamonds (partial - some sections missing)
	diamond_count := int(total_length / 0.5)
	for i in range(diamond_count):
		# Every other section is missing for "damaged" look
		if i % 3 != 1: # Keep 2 out of 3 sections
			var diamond_mesh := BoxMesh.new()
			diamond_mesh.size := Vector3(0.5, fence_height * 0.5, 0.5)
			
			var diamond_instance := MeshInstance3D.new()
			diamond_instance.mesh := diamond_mesh
			diamond_instance.name := "DamChainFence_Diamond%d" % i
			diamond_instance.position := Vector3(
				i * 0.5 - total_length * 0.5 + 0.25,
				fence_height * 0.5,
				0
			)
			diamond_instance.rotation.z := PI / 4.0
			diamond_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
			add_child(diamond_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5, 0)
	add_child(collision)
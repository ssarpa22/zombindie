extends StaticBody3D

func _ready() -> void:
	# Single gate: pedestrian gate
	var gate_width := 1.0
	var gate_height := 2.0
	var post_depth := 0.2
	var post_height := 2.5
	
	# Gate leaves (two halves that meet in middle)
	for leaf in [0, 1]:
		var leaf_mesh := BoxMesh.new()
		leaf_mesh.size := Vector3(gate_width * 0.5 - 0.1, gate_height, post_depth)
		
		var leaf_instance := MeshInstance3D.new()
		leaf_instance.mesh := leaf_mesh
		leaf_instance.name := "Gate_Leaf%d" % leaf
		leaf_instance.position := Vector3(
			(gate_width * 0.5 - 0.1) * (1 if leaf == 0 else -1),
			gate_height * 0.5,
			post_depth * 0.5
		)
		leaf_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(leaf_instance)
	
	# Gate posts
	for side in [-1, 1]:
		var post_mesh := CylinderMesh.new()
		post_mesh.top_radius := post_depth
		post_mesh.bottom_radius := post_depth
		post_mesh.height := post_height
		post_mesh.radial_segments := 6
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "Gate_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * gate_width * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	# Hinge and latch visual (simplified)
	var hinge_mesh := BoxMesh.new()
	hinge_mesh.size := Vector3(0.05, gate_height, 0.05)
	
	var hinge_instance := MeshInstance3D.new()
	hinge_instance.mesh := hinge_mesh
	hinge_instance.name := "Gate_Hinge"
	hinge_instance.position := Vector3(-gate_width * 0.5 + 0.05, gate_height * 0.5, 0)
	hinge_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(hinge_instance)
	
	var latch_mesh := BoxMesh.new()
	latch_mesh.size := Vector3(0.1, 0.1, 0.05)
	
	var latch_instance := MeshInstance3D.new()
	latch_instance.mesh := latch_mesh
	latch_instance.name := "Gate_Latch"
	latch_instance.position := Vector3(gate_width * 0.5 - 0.1, gate_height * 0.5 - 0.1, 0)
	latch_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
	add_child(latch_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(gate_width, gate_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(gate_width * 0.5, gate_height * 0.5, 0)
	add_child(collision)
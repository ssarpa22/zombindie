extends StaticBody3D

func _ready() -> void:
	# Double gate: wider entrance gate
	var gate_width := 3.0
	var gate_height := 2.5
	var post_depth := 0.3
	var post_height := 3.0
	
	# Gate leaves (two wide leaves)
	for leaf in [0, 1]:
		var leaf_mesh := BoxMesh.new()
		leaf_mesh.size := Vector3(gate_width * 0.5, gate_height, post_depth)
		
		var leaf_instance := MeshInstance3D.new()
		leaf_instance.mesh := leaf_mesh
		leaf_instance.name := "DoubleGate_Leaf%d" % leaf
		leaf_instance.position := Vector3(
			(gate_width * 0.5) * (1 if leaf == 0 else -1),
			gate_height * 0.5,
			post_depth * 0.5
		)
		leaf_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(leaf_instance)
	
	# Gate posts (two outer posts)
	for side in [-1, 1]:
		var post_mesh := CylinderMesh.new()
		post_mesh.top_radius := post_depth
		post_mesh.bottom_radius := post_depth
		post_mesh.height := post_height
		post_mesh.radial_segments := 6
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "DoubleGate_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * gate_width * 0.6, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	# Cross bracing
	for i in range(4):
		var brace_angle := i * PI / 2.0
		var brace_mesh := BoxMesh.new()
		brace_mesh.size := Vector3(0.15, gate_height * 0.6, 0.05)
		
		var brace_instance := MeshInstance3D.new()
		brace_instance.mesh := brace_mesh
		brace_instance.name := "DoubleGate_Brace%d" % i
		brace_instance.position := Vector3(
			cos(brace_angle) * gate_width * 0.4,
			gate_height * 0.3,
			sin(brace_angle) * gate_width * 0.4
		)
		brace_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(brace_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(gate_width, gate_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(gate_width * 0.5, gate_height * 0.5, 0)
	add_child(collision)
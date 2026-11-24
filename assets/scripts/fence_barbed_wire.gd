extends StaticBody3D

func _ready() -> void:
	# Barbed wire-topped wall/fence: standard fence with barbed wire on top
	var fence_height := 1.8
	var barbed_height := 0.3
	var post_height := 2.5
	var post_depth := 0.2
	
	var total_length := 10.0
	
	# Base fence panels (using concrete perimeter style)
	for i in range(int(total_length / 2.0)):
		var panel_mesh := BoxMesh.new()
		panel_mesh.size := Vector3(2.0, fence_height, post_depth)
		
		var panel_instance := MeshInstance3D.new()
		panel_instance.mesh := panel_mesh
		panel_instance.name := "BarbedFence_Panel%d" % i
		panel_instance.position := Vector3(i * 2.0 - total_length * 0.5 + 1.0, fence_height * 0.5, 0)
		panel_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
		add_child(panel_instance)
	
	# Posts
	for side in [-1, 1]:
		var post_mesh := CylinderMesh.new()
		post_mesh.top_radius := post_depth
		post_mesh.bottom_radius := post_depth
		post_mesh.height := post_height
		post_mesh.radial_segments := 6
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "BarbedFence_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * total_length * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	# Barbed wire on top (coil visual)
	for i in range(6):
		var coil_mesh := BoxMesh.new()
		coil_mesh.size := Vector3(0.2, 0.15, 0.2)
		
		var coil_instance := MeshInstance3D.new()
		coil_instance.mesh := coil_mesh
		coil_instance.name := "BarbedWire_Coil%d" % i
		coil_instance.position := Vector3(
			i * total_length / 5.0 - total_length * 0.3,
			fence_height + barbed_height * 0.5,
			0
		)
		coil_instance.rotation.z := PI / 2.0
		coil_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(coil_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + barbed_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5 + barbed_height * 0.5, 0)
	add_child(collision)
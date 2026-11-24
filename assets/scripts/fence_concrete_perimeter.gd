extends StaticBody3D

func _ready() -> void:
	# Concrete perimeter fence: solid panels
	var fence_height := 2.0
	var panel_width := 2.0
	var post_depth := 0.2
	var post_height := 2.5
	
	var total_length := 10.0
	
	# Posts at panel ends
	for side in [-1, 1]:
		for panel_end in [-1, 1]:
			var post_mesh := CylinderMesh.new()
			post_mesh.top_radius := post_depth
			post_mesh.bottom_radius := post_depth
			post_mesh.height := post_height
			post_mesh.radial_segments := 6
			
			var post_instance := MeshInstance3D.new()
			post_instance.mesh := post_mesh
			post_instance.name := "ConcreteFence_Post_%d_%d" % (side == -1 and 1 or 2, panel_end == -1 and 1 or 2)
			post_instance.position := Vector3(side * (total_length * 0.5 - panel_width * 0.5), post_height * 0.5, panel_end * (fence_height * 0.5 + post_depth * 0.5))
			post_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
			add_child(post_instance)
	
	# Concrete panels between posts
	panel_count := int(total_length / panel_width)
	for i in range(panel_count):
		var panel_mesh := BoxMesh.new()
		panel_mesh.size := Vector3(panel_width, fence_height, post_depth)
		
		var panel_instance := MeshInstance3D.new()
		panel_instance.mesh := panel_mesh
		panel_instance.name := "ConcreteFence_Panel%d" % i
		panel_instance.position := Vector3(
			i * panel_width - total_length * 0.5 + panel_width * 0.5,
			fence_height * 0.5,
			0
		)
		panel_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
		add_child(panel_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5, 0)
	add_child(collision)
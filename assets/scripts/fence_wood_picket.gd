extends StaticBody3D

func _ready() -> void:
	# Wood picket fence: segments that tile without gaps
	var fence_height := 1.0
	var picket_width := 0.1
	var picket_spacing := 0.02
	var post_depth := 0.15
	var post_height := 1.3
	
	# Posts at intervals
	var post_interval := 2.0 # meters between posts
	
	var total_length := 10.0 # default, will be adjusted by instances
	
	# End posts
	for side in [-1, 1]:
		var post_mesh := CylinderMesh.new()
		post_mesh.top_radius := post_depth
		post_mesh.bottom_radius := post_depth
		post_mesh.height := post_height
		post_mesh.radial_segments := 6
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "PicketFence_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * total_length * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(post_instance)
	
	# Pickets (vertical slats)
	picket_count := int(total_length / (picket_width + picket_spacing))
	for i in range(picket_count):
		var picket_mesh := BoxMesh.new()
		picket_mesh.size := Vector3(picket_width, fence_height, picket_width + picket_spacing)
		
		var picket_instance := MeshInstance3D.new()
		picket_instance.mesh := picket_mesh
		picket_instance.name := "PicketFence_Picket%d" % i
		picket_instance.position := Vector3(
			-i * (picket_width + picket_spacing) + (total_length - picket_count * (picket_width + picket_spacing)) * 0.5 + picket_width * 0.5,
			fence_height * 0.5,
			0
		)
		picket_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(picket_instance)
	
	# Top rail
	var rail_mesh := BoxMesh.new()
	rail_mesh.size := Vector3(total_length, 0.05, post_depth)
	
	var rail_instance := MeshInstance3D.new()
	rail_instance.mesh := rail_mesh
	rail_instance.name := "PicketFence_Rail"
	rail_instance.position := Vector3(total_length * 0.5, fence_height + 0.05, 0)
	rail_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(rail_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5, 0)
	add_child(collision)
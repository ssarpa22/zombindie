extends StaticBody3D

func _ready() -> void:
	# Farm rail fence: wooden rail fence with rounded rails
	var fence_height := 1.1
	var rail_diameter := 0.1
	var post_height := 1.5
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
		post_instance.name := "FarmRail_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * total_length * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(post_instance)
	
	# Top and middle rails
	for rail_level in [0.0, 0.55]:
		var rail_mesh := CylinderMesh.new()
		rail_mesh.top_radius := rail_diameter
		rail_mesh.bottom_radius := rail_diameter
		rail_mesh.height := 0.05
		rail_mesh.radial_segments := 6
		
		var rail_instance := MeshInstance3D.new()
		rail_instance.mesh := rail_mesh
		rail_instance.name := "FarmRail_Rail_%d" % (rail_level > 0 and 1 or 2)
		rail_instance.position := Vector3(total_length * 0.5, post_height * 0.5 + rail_level, 0)
		rail_instance.rotation.z := PI / 2.0
		rail_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(rail_instance)
	
	# Diagonal rails (rustic look)
	for i in range(2):
		var diag_mesh := BoxMesh.new()
		diag_mesh.size := Vector3(total_length * 0.5, 0.05, rail_diameter * 2)
		
		var diag_instance := MeshInstance3D.new()
		diag_instance.mesh := diag_mesh
		diag_instance.name := "FarmRail_Diag_%d" % i
		diag_instance.position := Vector3(
			total_length * 0.25 * (1 if i == 0 else -1),
			post_height * 0.5,
			0
		)
		diag_instance.rotation.z := PI / 4.0 * (1 if i == 0 else -1)
		diag_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(diag_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(total_length, fence_height + 0.1, post_depth * 2)
	collision.shape := shape
	collision.position := Vector3(total_length * 0.5, fence_height * 0.5, 0)
	add_child(collision)
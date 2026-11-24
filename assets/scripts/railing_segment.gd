extends StaticBody3D

func _ready() -> void:
	# Railing segment: 2m railing with posts, for walkways or balconies
	var railing_length := 2.0
	var railing_height := 1.0
	var post_distance := 2.0
	
	# Horizontal rail
	var rail_mesh := BoxMesh.new()
	rail_mesh.size := Vector3(railing_length, 0.08, 0.08)
	
	var rail_instance := MeshInstance3D.new()
	rail_instance.mesh := rail_mesh
	rail_instance.name := "Railing_Rail"
	rail_instance.position := Vector3(railing_length * 0.5, railing_height * 0.5, 0)
	rail_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(rail_instance)
	
	# End posts
	var post_height := railing_height + 0.2
	
	for side in [-1, 1]:
		var post_mesh := BoxMesh.new()
		post_mesh.size := Vector3(0.1, post_height, 0.1)
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "Railing_Post_%d" % (side == -1 and 1 or 2)
		post_instance.position := Vector3(side * railing_length * 0.5, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	# Middle post (if segment is long enough)
	if railing_length > post_distance:
		var middle_post_x := 0
		var post_mesh := BoxMesh.new()
		post_mesh.size := Vector3(0.1, post_height, 0.1)
		
		var post_instance := MeshInstance3D.new()
		post_instance.mesh := post_mesh
		post_instance.name := "Railing_Post_Middle"
		post_instance.position := Vector3(middle_post_x, post_height * 0.5, 0)
		post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
		add_child(post_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(railing_length, post_height, 0.2)
	collision.shape := shape
	collision.position := Vector3(railing_length * 0.5, post_height * 0.5, 0)
	add_child(collision)
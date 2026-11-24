extends StaticBody3D

func _ready() -> void:
	# Handrail segment: 2m long railing with posts
	var railing_length := 2.0
	var railing_height := 1.0
	
	# Horizontal rail
	var rail_mesh := BoxMesh.new()
	rail_mesh.size = Vector3(railing_length, 0.08, 0.08)
	var rail_instance = MeshInstance3D.new()
	rail_instance.mesh = rail_mesh
	rail_instance.name = "HandrailSegment"
	rail_instance.position = Vector3(railing_length * 0.5, railing_height * 0.5, 0)
	add_child(rail_instance)
	
	# End posts
	for side in [-1, 1]:
		var post_mesh := BoxMesh.new()
		post_mesh.size = Vector3(0.08, railing_height, 0.08)
		var post_instance = MeshInstance3D.new()
		post_instance.mesh = post_mesh
		post_instance.name = "HandrailPost%d" % (side == -1 and 1 or 2)
		post_instance.position = Vector3(side * railing_length * 0.5, railing_height * 0.5, 0)
		add_child(post_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(railing_length, railing_height, 0.16)
	collision.shape = shape
	collision.position = Vector3(railing_length * 0.5, railing_height * 0.5, 0)
	add_child(collision)
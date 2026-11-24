extends StaticBody3D

func _ready() -> void:
	# Mailbox: wall-mounted or post-mounted
	var post_height := 1.0
	var box_width := 0.25
	var box_height := 0.3
	var box_depth := 0.15
	
	# Post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.08
	post_mesh.bottom_radius := 0.08
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "MailboxPost"
	post_instance.position := Vector3(0, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Mailbox door
	var door_mesh := BoxMesh.new()
	door_mesh.size := Vector3(box_width * 0.9, box_height * 0.9, box_depth * 0.9)
	
	var door_instance := MeshInstance3D.new()
	door_instance.mesh := door_mesh
	door_instance.name := "MailboxDoor"
	door_instance.position := Vector3(0, box_height * 0.5 - post_height * 0.5, box_depth * 0.55 - 0.02)
	door_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(door_instance)
	
	# Flag
	var flag_mesh := BoxMesh.new()
	flag_mesh.size := Vector3(0.1, 0.15, 0.02)
	
	var flag_instance := MeshInstance3D.new()
	flag_instance.mesh := flag_mesh
	flag_instance.name := "MailboxFlag"
	flag_instance.position := Vector3(box_width * 0.45, box_height * 0.5 - post_height * 0.5 + 0.02, box_depth * 0.55)
	flag_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(flag_instance)
	
	# Box body
	var box_mesh := BoxMesh.new()
	box_mesh.size := Vector3(box_width, box_height, box_depth)
	
	var box_instance := MeshInstance3D.new()
	box_instance.mesh := box_mesh
	box_instance.name := "MailboxBox"
	box_instance.position := Vector3(0, -box_height * 0.5 - post_height * 0.5 + 0.1, 0)
	box_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(box_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(box_width + 0.1, body_height + post_height, box_depth + 0.1)
	collision.shape := shape
	collision.position := Vector3(0, (body_height + post_height) * 0.5, 0)
	add_child(collision)
extends StaticBody3D

func _ready() -> void:
	# Warning sign (left direction arrow)
	var sign_width := 0.6
	var sign_height := 0.6
	var post_height := 2.0
	
	# Post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.08
	post_mesh.bottom_radius := 0.08
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "WarningSignPost"
	post_instance.position := Vector3(0, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Sign board (triangular with arrow)
	var sign_mesh := BoxMesh.new()
	sign_mesh.size := Vector3(sign_width, sign_width * 1.1, 0.02)
	
	var sign_instance := MeshInstance3D.new()
	sign_instance.mesh := sign_mesh
	sign_instance.name := "WarningSignBoard"
	sign_instance.position := Vector3(0, post_height * 0.5 - sign_width * 0.25, 0.1)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(1.0, 1.0, 1.0)
	material.roughness := 0.8
	sign_instance.material_override := material
	add_child(sign_instance)
	
	# Arrow pointing left (simple triangle approximation)
	var arrow_mesh := BoxMesh.new()
	arrow_mesh.size := Vector3(sign_width * 0.3, sign_width * 0.3, 0.02)
	
	var arrow_instance := MeshInstance3D.new()
	arrow_instance.mesh := arrow_mesh
	arrow_instance.name := "WarningSignArrow"
	arrow_instance.position := Vector3(-sign_width * 0.15, post_height * 0.5 - sign_width * 0.15, 0.12)
	arrow_instance.rotation.z := PI  # Point left
	arrow_instance.material_override := material
	add_child(arrow_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(sign_width * 1.2, post_height + sign_width * 0.5, 0.2)
	collision.shape := shape
	collision.position := Vector3(0, (post_height + sign_width) * 0.5, 0)
	add_child(collision)
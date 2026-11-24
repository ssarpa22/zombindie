extends StaticBody3D

func _ready() -> void:
	# Warning sign: triangular caution sign on post
	var sign_size := 0.5
	var post_height := 2.5
	
	# Sign post
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
	
	# Sign board (triangular)
	var sign_mesh := BoxMesh.new()
	sign_mesh.size := Vector3(sign_size, sign_size * 1.0, 0.02) # triangle approximated by tall box
	
	var sign_instance := MeshInstance3D.new()
	sign_instance.mesh := sign_mesh
	sign_instance.name := "WarningSignBoard"
	sign_instance.position := Vector3(0, post_height * 0.5 - sign_size * 0.25, 0.1)
	
	# Red/white caution pattern
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(1.0, 1.0, 1.0)
	material.roughness := 0.8
	# Add diagonal red stripes conceptually
	sign_instance.material_override := material
	add_child(sign_instance)
	
	# Mounting bracket
	var bracket_mesh := BoxMesh.new()
	bracket_mesh.size := Vector3(0.05, 0.05, 0.15)
	
	var bracket_instance := MeshInstance3D.new()
	bracket_instance.mesh := bracket_mesh
	bracket_instance.name := "WarningSignBracket"
	bracket_instance.position := Vector3(0, post_height * 0.5 - sign_size * 0.25 + 0.05, 0.15)
	bracket_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(bracket_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(sign_size * 1.2, post_height + sign_size * 0.5, 0.2)
	collision.shape := shape
	collision.position := Vector3(0, (post_height + sign_size) * 0.5, 0)
	add_child(collision)
extends StaticBody3D

func _ready() -> void:
	# Road sign: standard traffic or informational sign
	var sign_width := 0.8
	var sign_height := 1.2
	var post_height := 2.0
	
	# Sign board
	var sign_mesh := BoxMesh.new()
	sign_mesh.size := Vector3(sign_width, sign_height, 0.02)
	
	var sign_instance := MeshInstance3D.new()
	sign_instance.mesh := sign_mesh
	sign_instance.name := "RoadSignBoard"
	sign_instance.position := Vector3(0, sign_height * 0.5 + post_height * 0.5, 0)
	sign_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
	add_child(sign_instance)
	
	# Sign post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.08
	post_mesh.bottom_radius := 0.08
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "RoadSignPost"
	post_instance.position := Vector3(0, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)
	
	# Mounting bracket
	var bracket_mesh := BoxMesh.new()
	bracket_mesh.size := Vector3(0.1, 0.1, 0.3)
	
	var bracket_instance := MeshInstance3D.new()
	bracket_instance.mesh := bracket_mesh
	bracket_instance.name := "SignBracket"
	bracket_instance.position := Vector3(0, sign_height * 0.5 - post_height * 0.5 + 0.1, sign_width * 0.45)
	bracket_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(bracket_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(sign_width + 0.1, sign_height + 0.1, 0.1)
	collision.shape := shape
	collision.position := Vector3(0, sign_height * 0.5 + post_height * 0.5, 0)
	add_child(collision)
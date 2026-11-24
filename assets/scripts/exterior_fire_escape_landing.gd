extends StaticBody3D

func _ready() -> void:
	# Fire escape landing: platform at intermediate level
	var platform_width := 2.0
	var platform_depth := 1.5
	
	# Landing platform
	var platform_mesh := BoxMesh.new()
	platform_mesh.size = Vector3(platform_width, 0.15, platform_depth)
	var platform_instance = MeshInstance3D.new()
	platform_instance.mesh = platform_mesh
	platform_instance.name = "FireEscapeLanding"
	platform_instance.position = Vector3(0, 0.075, 0)
	add_child(platform_instance)
	
	# Drainage grate
	var grate_mesh := BoxMesh.new()
	grate_mesh.size = Vector3(1.5, 0.05, 0.3)
	var grate_instance = MeshInstance3D.new()
	grate_instance.mesh = grate_mesh
	grate_instance.name = "LandingGrate"
	grate_instance.position = Vector3(0, 0.025, platform_depth * 0.5 - 0.15)
	grate_instance.material_override = preload("res://assets/materials/palettes.grate_tres")
	add_child(grate_instance)
	
	# Railing attachment
	var railing_post := BoxMesh.new()
	railing_post.size = Vector3(0.2, 0.3, 0.2)
	var railing_post_instance = MeshInstance3D.new()
	railing_post_instance.mesh = railing_post
	railing_post_instance.name = "LandingRailingPost"
	railing_post_instance.position = Vector3(-0.8, 0.15, 0)
	add_child(railing_post_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(platform_width, 0.2, platform_depth)
	collision.shape = shape
	collision.position = Vector3(0, 0.075, 0)
	add_child(collision)
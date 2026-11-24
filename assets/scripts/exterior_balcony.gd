extends StaticBody3D

func _ready() -> void:
	# Balcony: elevated platform with railing
	var platform_width := 3.0
	var platform_depth := 2.0
	var railing_height := 1.0
	
	# Platform
	var platform_mesh := BoxMesh.new()
	platform_mesh.size = Vector3(platform_width, 0.2, platform_depth)
	var platform_instance = MeshInstance3D.new()
	platform_instance.mesh = platform_mesh
	platform_instance.name = "BalconyPlatform"
	platform_instance.position = Vector3(0, 1.5, 0) # Elevated
	add_child(platform_instance)
	
	# Railing
	var railing_mesh := BoxMesh.new()
	railing_mesh.size = Vector3(platform_width, 0.1, 0.1)
	var railing_instance = MeshInstance3D.new()
	railing_instance.mesh = railing_mesh
	railing_instance.name = "BalconyRailing"
	railing_instance.position = Vector3(0, 1.55, platform_depth * 0.5 + 0.05)
	add_child(railing_instance)
	
	# Railing posts at corners
	for x in [-1, 1]:
		for z in [-1, 1]:
			var post_mesh := BoxMesh.new()
			post_mesh.size = Vector3(0.2, railing_height, 0.2)
			var post_instance = MeshInstance3D.new()
			post_instance.mesh = post_mesh
			post_instance.name = "BalconyPost%x_%z" % (x, z)
			post_instance.position = Vector3(x * 1.2, 1.0 + railing_height * 0.5, z * 0.8)
			post_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
			add_child(post_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(platform_width, 0.3, platform_depth)
	collision.shape = shape
	collision.position = Vector3(0, 1.5 - 0.15, 0)
	add_child(collision)
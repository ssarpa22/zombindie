extends StaticBody3D

func _ready() -> void:
	# Hospital window opening - taller, with glass
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.8, 1.8, 0.05)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "HospitalWindowMesh"
	mesh_instance.position = Vector3(0, 0.9, 0)
	add_child(mesh_instance)
	
	# Glass placeholder
	var glass_mesh := BoxMesh.new()
	glass_mesh.size = Vector3(0.75, 1.7, 0.02)
	var glass_instance = MeshInstance3D.new()
	glass_instance.mesh = glass_mesh
	glass_instance.name = "GlassPane"
	glass_instance.position = Vector3(0, 0.9, 0.425) # Offset forward
	glass_instance.material_override = preload("res://assets/materials/palettes/glass_tres")
	add_child(glass_instance)
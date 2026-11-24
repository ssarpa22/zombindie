extends StaticBody3D

func _ready() -> void:
	# Boarded window - planks over a window opening
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 1.5, 0.2)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "BoardedWindowMesh"
	mesh_instance.position = Vector3(0, 0.75, 0)
	add_child(mesh_instance)
	
	# Add plank details
	for i in range(3):
		var plank_mesh := BoxMesh.new()
		plank_mesh.size = Vector3(0.28, 0.15, 0.2)
		var plank_instance = MeshInstance3D.new()
		plank_instance.mesh = plank_mesh
		plank_instance.name = "Plank%d" % i
		plank_instance.position = Vector3(-0.12 + i * 0.3, 0.45, 0.1)
		plank_instance.material_override = preload("res://assets/materials/palettes/wood_tres")
		add_child(plank_instance)
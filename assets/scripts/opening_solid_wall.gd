extends StaticBody3D

func _ready() -> void:
	# Solid wall opening - just a placeholder opening in a wall
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.0, 3.0, 0.1)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "OpeningMesh"
	mesh_instance.position = Vector3(0, 1.5, 0)
	add_child(mesh_instance)
	
	# No collision shape - this is a visual opening
extends StaticBody3D

func _ready() -> void:
	# Double door opening - 1.6m wide, 2.1m tall
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.6, 2.1, 0.05)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DoubleDoorOpeningMesh"
	mesh_instance.position = Vector3(0, 1.05, 0)
	add_child(mesh_instance)
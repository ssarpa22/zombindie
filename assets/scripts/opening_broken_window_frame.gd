extends StaticBody3D

func _ready() -> void:
	# Broken window frame - damaged frame without glass
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 1.5, 0.1)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "BrokenWindowFrameMesh"
	mesh_instance.position = Vector3(0, 0.75, 0)
	add_child(mesh_instance)
	
	# Crack visual
	var crack_mesh := BoxMesh.new()
	crack_mesh.size = Vector3(0.9, 0.05, 0.1)
	var crack_instance = MeshInstance3D.new()
	crack_instance.mesh = crack_mesh
	crack_instance.name = "CrackVisual"
	crack_instance.position = Vector3(0, 0.75, 0.05)
	crack_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
	add_child(crack_instance)
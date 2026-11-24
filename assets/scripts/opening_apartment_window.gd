extends StaticBody3D

func _ready() -> void:
	# Apartment window opening - standard size
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 1.5, 0.05)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ApartmentWindowMesh"
	mesh_instance.position = Vector3(0, 0.75, 0)
	add_child(mesh_instance)
	
	# Window frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size = Vector3(0.95, 1.55, 0.1)
	var frame_instance = MeshInstance3D.new()
	frame_instance.mesh = frame_mesh
	frame_instance.name = "WindowFrame"
	frame_instance.position = Vector3(0, 0.775, 0)
	frame_instance.material_override = preload("res://assets/materials/palettes/painted_metal_tres")
	add_child(frame_instance)
extends StaticBody3D

func _ready() -> void:
	# Apartment door
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.8, 2.1, 0.1)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "ApartmentDoorMesh"
	mesh_instance.position = Vector3(0, 1.05, 0)
	add_child(mesh_instance)
	
	# Door with window
	var window_mesh := BoxMesh.new()
	window_mesh.size = Vector3(0.3, 0.9, 0.05)
	var window_instance = MeshInstance3D.new()
	window_instance.mesh = window_mesh
	window_instance.name = "DoorWindow"
	window_instance.position = Vector3(0, 1.55, 0.475)
	window_instance.material_override = preload("res://assets/materials/palettes/glass_tres")
	add_child(window_instance)
	
	# Frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size = Vector3(0.85, 2.15, 0.1)
	var frame_instance = MeshInstance3D.new()
	frame_instance.mesh = frame_mesh
	frame_instance.name = "DoorFrame"
	frame_instance.position = Vector3(0, 1.075, 0)
	frame_instance.material_override = preload("res://assets/materials/palettes/wood_tres")
	add_child(frame_instance)
extends StaticBody3D

func _ready() -> void:
	# Hospital interior door
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.9, 2.2, 0.1)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DoorMesh"
	mesh_instance.position = Vector3(0, 1.1, 0)
	add_child(mesh_instance)
	
	# Door details
	var door_mesh := BoxMesh.new()
	door_mesh.size = Vector3(0.85, 2.1, 0.05)
	var door_instance = MeshInstance3D.new()
	door_instance.mesh = door_mesh
	door_instance.name = "DoorLeaf"
	door_instance.position = Vector3(0, 1.1, 0.475)
	door_instance.material_override = preload("res://assets/materials/palettes/painted_metal_tres")
	add_child(door_instance)
	
	# Frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size = Vector3(0.95, 2.25, 0.1)
	var frame_instance = MeshInstance3D.new()
	frame_instance.mesh = frame_mesh
	frame_instance.name = "DoorFrame"
	frame_instance.position = Vector3(0, 1.125, 0)
	frame_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
	add_child(frame_instance)
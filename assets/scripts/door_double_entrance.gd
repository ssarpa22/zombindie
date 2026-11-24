extends StaticBody3D

func _ready() -> void:
	# Double entrance door
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.8, 2.2, 0.1)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DoubleDoorMesh"
	mesh_instance.position = Vector3(0, 1.1, 0)
	add_child(mesh_instance)
	
	# Two door leaves
	for i in range(2):
		var leaf_mesh := BoxMesh.new()
		leaf_mesh.size = Vector3(0.8, 2.0, 0.08)
		var leaf_instance = MeshInstance3D.new()
		leaf_instance.mesh = leaf_mesh
		leaf_instance.name = "DoorLeaf%d" % i
		leaf_instance.position = Vector3(-0.45 + i * 0.9, 1.1, 0.52)
		leaf_instance.material_override = preload("res://assets/materials/palettes/painted_metal_tres")
		add_child(leaf_instance)
	
	# Center frame
	var frame_mesh := BoxMesh.new()
	frame_mesh.size = Vector3(1.85, 2.25, 0.1)
	var frame_instance = MeshInstance3D.new()
	frame_instance.mesh = frame_mesh
	frame_instance.name = "DoorFrame"
	frame_instance.position = Vector3(0, 1.125, 0)
	frame_instance.material_override = preload("res://assets/materials/palettes/wood_tres")
	add_child(frame_instance)
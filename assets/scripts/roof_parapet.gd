extends StaticBody3D

func _ready() -> void:
	# Parapet edge: 4m long, 0.5m high parapet on top of a wall
	var main_mesh := BoxMesh.new()
	main_mesh.size = Vector3(4.0, 0.3, 4.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = main_mesh
	mesh_instance.name = "ParapetMainMesh"
	mesh_instance.position = Vector3(0, 0.15, 0)
	add_child(mesh_instance)
	
	# Parapet wall extension (0.5m high)
	var parapet_mesh := BoxMesh.new()
	parapet_mesh.size = Vector3(4.0, 0.5, 0.2)
	var parapet_instance = MeshInstance3D.new()
	parapet_instance.mesh = parapet_mesh
	parapet_instance.name = "ParapetWall"
	parapet_instance.position = Vector3(0, 0.85, 0) # On top of main roof
	add_child(parapet_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4.0, 0.8, 4.0) # Total height including wall below
	collision.shape = shape
	collision.position = Vector3(0, 0.4, 0)
	add_child(collision)
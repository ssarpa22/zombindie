extends StaticBody3D

func _ready() -> void:
	# Stair landing: 2m x 1m platform at top of stairs
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 0.1, 1.0)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "LandingMesh"
	mesh_instance.position = Vector3(0, 0.05, 0)
	add_child(mesh_instance)
	
	# Railing attachment point
	var rail_mesh := BoxMesh.new()
	rail_mesh.size = Vector3(0.2, 0.1, 0.5)
	var rail_instance = MeshInstance3D.new()
	rail_instance.mesh = rail_mesh
	rail_instance.name = "RailingPost"
	rail_instance.position = Vector3(0.8, 0.05, 0.5)
	add_child(rail_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 0.1, 1.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.05, 0)
	add_child(collision)
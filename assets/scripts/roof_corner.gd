extends StaticBody3D

func _ready() -> void:
	# Roof corner piece - L-shaped roof section
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 0.3, 2.0)
	
	# Two facing roof sections for the corner
	var mesh_instance1 = MeshInstance3D.new()
	mesh_instance1.mesh = mesh
	mesh_instance1.name = "RoofCorner1"
	mesh_instance1.position = Vector3(0, 0.15, 0)
	mesh_instance1.rotation.y = 0.0
	add_child(mesh_instance1)
	
	var mesh_instance2 = MeshInstance3D.new()
	mesh_instance2.mesh = mesh
	mesh_instance2.name = "RoofCorner2"
	mesh_instance2.position = Vector3(0, 0.15, 0)
	mesh_instance2.rotation.y = PI / 2.0
	add_child(mesh_instance2)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 0.3, 2.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.15, 0)
	add_child(collision)
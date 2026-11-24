extends StaticBody3D

func _ready() -> void:
	# Sidewalk curb: 0.2m high, 0.3m wide, lengths vary
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 0.2, 0.3)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "CurbMesh"
	mesh_instance.position = Vector3(0, 0.1, 0)
	add_child(mesh_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 0.2, 0.3)
	collision.shape = shape
	collision.position = Vector3(0, 0.1, 0)
	add_child(collision)